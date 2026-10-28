<#
.SYNOPSIS
    扫描仓库中的 Markdown 笔记，生成根目录的「索引.md」。
.DESCRIPTION
    主题目录 = 仓库根目录下的一级目录（node_modules、资料、_模板、scripts 等除外）。
    正文少于 TodoThreshold 字节的笔记会被标记为「待补」。
.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\生成目录索引.ps1
#>
[CmdletBinding()]
param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot),
    [string]$OutputName = '索引.md',
    [int]$TodoThreshold = 100
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\')
# 路径中任意一级目录命中这些名字就跳过（例如 TypeScript/code/01/node_modules）
$excludeAny = @('node_modules', '.git', '.obsidian', '资料', '_模板', 'scripts', 'dist', 'build', 'target', 'bin', 'obj', 'out')
$rootDocs = @('README.md', '文档规范.md', $OutputName)

function Get-UrlPath([string]$relativePath) {
    $p = $relativePath -replace '\\', '/'
    $p = $p -replace ' ', '%20'
    $p = $p -replace '\(', '%28'
    $p = $p -replace '\)', '%29'
    $p = $p -replace '#', '%23'
    return $p
}

# 让 01、2、10 这类文件名按数值顺序排列
function Get-SortKey([string]$text) {
    return [regex]::Replace($text, '\d+', { param($m) $m.Value.PadLeft(8, '0') })
}

# 首行标题可能带 HTML / 链接 / 强调符号，清理后再用；清理结果不可用时退回文件名
function Get-CleanTitle([string]$text) {
    $t = [regex]::Replace($text, '<[^>]+>', '')
    $t = [regex]::Replace($t, '!?\[([^\]]*)\]\([^)]*\)', '$1')
    $t = [regex]::Replace($t, '[*_`]+', '')
    return $t.Trim()
}

$notes = New-Object System.Collections.ArrayList

foreach ($file in Get-ChildItem -LiteralPath $root -Recurse -File -Filter *.md) {
    $relative = $file.FullName.Substring($root.Length + 1)
    $segments = $relative -split '\\'

    $skip = $false
    foreach ($segment in $segments) {
        if ($excludeAny -contains $segment) { $skip = $true; break }
    }
    if ($skip) { continue }
    if ($file.Name -eq 'README.md') { continue }
    if ($segments.Count -eq 1 -and $rootDocs -contains $segments[0]) { continue }

    $title = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $firstLine = Get-Content -LiteralPath $file.FullName -TotalCount 1 -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($firstLine -and $firstLine -match '^\s*#\s+(.+?)\s*$') {
        $candidate = Get-CleanTitle $Matches[1]
        # 标题里带链接残留、或以 "1."/"1、" 开头时，用文件名更清楚
        if ($candidate -and $candidate -notmatch 'https?:' -and $candidate -notmatch '^\d+[\.、]') {
            $title = $candidate
        }
    }

    # 分组：notes/languages/golang/xxx.md -> 主题 "notes / languages"，子分组 "golang"
    $topicDepth = 1
    if ($segments.Count -ge 3 -and @('notes', 'interview', 'career', 'misc') -contains $segments[0]) { $topicDepth = 2 }
    $topic = ($segments[0..($topicDepth - 1)]) -join ' / '

    if ($segments.Count -gt ($topicDepth + 1)) {
        $group = ($segments[$topicDepth..($segments.Count - 2)]) -join ' / '
    }
    else {
        $group = ''
    }

    [void]$notes.Add([pscustomobject]@{
            Top     = $topic
            Group   = $group
            SortKey = (Get-SortKey $group) + '|' + (Get-SortKey $file.Name)
            Title   = $title
            Link    = (Get-UrlPath $relative)
            Todo    = ($file.Length -lt $TodoThreshold)
        })
}


$total = $notes.Count
$todoCount = ($notes | Where-Object { $_.Todo }).Count

$lines = New-Object System.Collections.ArrayList
[void]$lines.Add('# 笔记索引')
[void]$lines.Add('')
[void]$lines.Add('> 本文件由 `scripts/生成目录索引.ps1` 自动生成，请勿手动编辑。')
[void]$lines.Add('> 新增、重命名或删除笔记后重新运行：')
[void]$lines.Add('>')
[void]$lines.Add('> ```powershell')
[void]$lines.Add('> powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\生成目录索引.ps1')
[void]$lines.Add('> ```')
[void]$lines.Add('')
[void]$lines.Add("- 笔记总数：$total")
[void]$lines.Add("- 待补笔记（正文少于 $TodoThreshold 字节）：$todoCount")
[void]$lines.Add('')

foreach ($topic in ($notes | Group-Object Top | Sort-Object Name)) {
    [void]$lines.Add("## $($topic.Name)（$($topic.Count) 篇）")
    [void]$lines.Add('')

    foreach ($group in ($topic.Group | Group-Object Group | Sort-Object Name)) {
        if ($group.Name -ne '') {
            [void]$lines.Add("### $($group.Name)")
            [void]$lines.Add('')
        }
        foreach ($note in ($group.Group | Sort-Object SortKey)) {
            $mark = if ($note.Todo) { ' `待补`' } else { '' }
            [void]$lines.Add("- [$($note.Title)]($($note.Link))$mark")
        }
        [void]$lines.Add('')
    }
}

$outputPath = Join-Path $root $OutputName
[System.IO.File]::WriteAllLines($outputPath, $lines, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "已生成 $outputPath：共 $total 篇笔记，其中 $todoCount 篇待补。"
