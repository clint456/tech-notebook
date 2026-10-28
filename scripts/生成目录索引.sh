#!/usr/bin/env bash
#
# 生成目录索引.sh —— 扫描仓库中的 Markdown 笔记，生成仓库根目录的「索引.md」。
#
# 与 scripts/生成目录索引.ps1 输出完全一致，供 Linux / macOS 使用：
#   ./scripts/生成目录索引.sh
#
# 主题目录 = 仓库根目录下的一级目录（node_modules、资料、_模板、scripts 等除外）。
# 正文少于 TodoThreshold 字节的笔记会被标记为「待补」。
#
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
root=$(cd -- "$script_dir/.." && pwd)
output_name='索引.md'
todo_threshold=100
collate=''

usage() {
    cat <<'EOF'
用法：scripts/生成目录索引.sh [选项]

扫描仓库中的 Markdown 笔记，生成仓库根目录的「索引.md」。

  -r, --root <目录>        仓库根目录（默认：脚本所在目录的上一级）
  -o, --output <文件名>    输出文件名（默认：索引.md，只写文件名，落在仓库根目录）
  -t, --threshold <字节>   正文小于该字节数的笔记标记「待补」（默认：100）
  -c, --collate <locale>   排序使用的 locale（默认 C.UTF-8，必要时用 C）
  -h, --help               显示本帮助

排序默认按 UTF-8 码位（跨机器结果稳定，拉丁字母在中文之前，与 Windows 版
大体一致）。想要拼音顺序可加 -c zh_CN.UTF-8，但需先安装该 locale：
sudo locale-gen zh_CN.UTF-8
EOF
}

die() {
    printf '错误：%s\n' "$1" >&2
    exit "${2:-1}"
}

while (( $# > 0 )); do
    case $1 in
        -r|--root)
            (( $# >= 2 )) || die "$1 缺少参数" 2
            root=$2
            shift 2
            ;;
        -o|--output)
            (( $# >= 2 )) || die "$1 缺少参数" 2
            output_name=$2
            shift 2
            ;;
        -t|--threshold)
            (( $# >= 2 )) || die "$1 缺少参数" 2
            todo_threshold=$2
            shift 2
            ;;
        -c|--collate)
            (( $# >= 2 )) || die "$1 缺少参数" 2
            collate=$2
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            die "未知参数：$1" 2
            ;;
    esac
done

case $todo_threshold in
    ''|*[!0-9]*) die "待补阈值必须是非负整数：$todo_threshold" 2 ;;
esac
case $output_name in
    ''|*/*) die "输出文件名不能为空，也不能带路径分隔符：$output_name" 2 ;;
esac
[[ -d $root ]] || die "根目录不存在：$root"
root=$(cd -- "$root" && pwd)
output_path="$root/$output_name"

# 让 ${#var} 按字符计数（对齐 PowerShell 的 .Length），保证标题长度比较结果一致
if locale -a 2>/dev/null | grep -qiE '^c\.utf-?8$'; then
    export LC_ALL=C.UTF-8
elif locale -a 2>/dev/null | grep -qiE '^en_US\.utf-?8$'; then
    export LC_ALL=en_US.UTF-8
fi

# locale 名字在不同发行版里可能是 zh_CN.utf8 / zh_CN.UTF-8，统一后再比较
locale_available() {
    local want
    want=$(printf '%s' "$1" | tr 'A-Z' 'a-z' | sed 's/utf-8/utf8/')
    locale -a 2>/dev/null | tr 'A-Z' 'a-z' | sed 's/utf-8/utf8/' | grep -qx -- "$want"
}

# 排序用的 locale：默认 C.UTF-8，保证同一批笔记在任何机器上顺序一致
if [[ -z $collate ]]; then
    for candidate in C.UTF-8 C; do
        if locale_available "$candidate"; then
            collate=$candidate
            break
        fi
    done
elif ! locale_available "$collate"; then
    die "不可用的 locale：$collate（可用 locale -a 查看）" 2
fi

work_dir=$(mktemp -d "${TMPDIR:-/tmp}/tech-notebook-index.XXXXXX") || die "无法创建临时目录"
trap 'rm -rf -- "$work_dir"' EXIT

records="$work_dir/records.tsv"
sorted_records="$work_dir/sorted.tsv"
out_tmp="$work_dir/index.md"

# grep -Fxi 做大小写不敏感的整串比较，不依赖 tr 的字符集处理，中文路径也安全
exclude_list="$work_dir/exclude.txt"
printf '%s\n' node_modules .git .obsidian 资料 _模板 scripts dist build target bin obj out >"$exclude_list"
root_docs_list="$work_dir/root-docs.txt"
# 根目录的导航 / 规范文档不进索引；默认输出名与自定义输出名都排除
printf '%s\n' README.md 文档规范.md 索引.md "$output_name" >"$root_docs_list"

# 清理首行标题里的 HTML、链接与强调符号
clean_title() {
    local text=$1
    text=$(printf '%s' "$text" | sed -E 's/<[^>]+>//g')
    text=$(printf '%s' "$text" | sed -E 's/!?\[([^]]*)\]\([^)]*\)/\1/g')
    text=$(printf '%s' "$text" | sed -E 's/[*_`]+//g')
    text=${text#"${text%%[![:space:]]*}"}
    text=${text%"${text##*[![:space:]]}"}
    printf '%s' "$text"
}

# 让 01、2、10 这类文件名按数值顺序排列：数字补零到 8 位
pad_digits() {
    local text=$1 prefix digits rest result=''
    while [[ $text =~ ^([^0-9]*)([0-9]+)(.*)$ ]]; do
        prefix=${BASH_REMATCH[1]}
        digits=${BASH_REMATCH[2]}
        rest=${BASH_REMATCH[3]}
        if (( ${#digits} >= 8 )); then
            result+=$prefix$digits
        else
            result+=$prefix$(printf '%08d' "$((10#$digits))")
        fi
        text=$rest
    done
    printf '%s%s' "$result" "$text"
}

# 生成 Markdown 链接用的相对路径（与 PowerShell 版编码规则一致）
url_path() {
    local path=$1
    path=${path// /%20}
    path=${path//'('/%28}
    path=${path//')'/%29}
    path=${path//'#'/%23}
    printf '%s' "$path"
}

: >"$records"

while IFS= read -r -d '' file; do
    relative=${file#"$root"/}

    # 路径中任意一级目录命中排除名单就跳过
    skip=0
    rest=$relative
    while :; do
        segment=${rest%%/*}
        if grep -Fxiq -- "$segment" "$exclude_list"; then
            skip=1
            break
        fi
        case $rest in
            */*) rest=${rest#*/} ;;
            *) break ;;
        esac
    done
    if (( skip )); then
        continue
    fi

    name=${relative##*/}
    # 任意层级的 README.md 都不进索引
    if grep -Fxiq -- README.md <<<"$name"; then
        continue
    fi
    # 根目录的说明类文档单独跳过
    if [[ $relative != */* ]] && grep -Fxiq -- "$name" "$root_docs_list"; then
        continue
    fi

    IFS=/ read -r -a segments <<<"$relative"
    segment_count=${#segments[@]}

    # 分组：notes/languages/golang/xxx.md -> 主题 "notes / languages"，子分组 "golang"
    topic_depth=1
    if (( segment_count >= 3 )); then
        case ${segments[0]} in
            notes|interview|career|misc) topic_depth=2 ;;
        esac
    fi

    topic=${segments[0]}
    if (( topic_depth == 2 )); then
        topic+=' / '${segments[1]}
    fi

    group=''
    if (( segment_count > topic_depth + 1 )); then
        index=$topic_depth
        while (( index <= segment_count - 2 )); do
            if [[ -n $group ]]; then
                group+=' / '
            fi
            group+=${segments[$index]}
            index=$(( index + 1 ))
        done
    fi

    # 首行标题可能带 HTML / 链接 / 强调符号，清理后再用；清理结果不可用时退回文件名
    base_name=${name%.*}
    title=$base_name
    first_line=''
    IFS= read -r first_line <"$file" || true
    first_line=${first_line#$'\xEF\xBB\xBF'} # 去掉 UTF-8 BOM
    first_line=${first_line%$'\r'}           # 去掉 CRLF 里的 \r
    if [[ $first_line =~ ^[[:space:]]*#[[:space:]]+(.+)$ ]]; then
        raw_heading=${BASH_REMATCH[1]}
        raw_heading=${raw_heading%"${raw_heading##*[![:space:]]}"}
        candidate=$(clean_title "$raw_heading")
        # 只有比文件名信息更丰富时才用首行标题：排除链接残留、编号开头
        if [[ -n $candidate ]] &&
            ! printf '%s' "$raw_heading" | grep -Eiq 'https?://|]\(' &&
            [[ ! $candidate =~ ^[0-9]+[[:space:].、] ]] &&
            (( ${#candidate} > ${#base_name} )); then
            title=$candidate
        fi
    fi

    size=$(wc -c <"$file" | tr -d '[:space:]')
    todo=0
    if (( size < todo_threshold )); then
        todo=1
    fi

    printf '%s\t%s\t%s|%s\t%s\t%s\t%s\n' \
        "$topic" "$group" "$(pad_digits "$group")" "$(pad_digits "$name")" \
        "$title" "$(url_path "$relative")" "$todo" >>"$records"
done < <(find "$root" -type f -iname '*.md' -print0)

# 主题 / 子分组按名称排序（忽略大小写），组内按补零后的文件名排序
[[ -n $collate ]] || collate=C
LC_ALL=$collate sort -f -t $'\t' -k1,1 -k2,2 -k3,3 -- "$records" >"$sorted_records"

read -r total todo_total < <(awk -F '\t' '{ total++; if ($6 == 1) todo++ } END { printf "%d %d\n", total, todo }' "$sorted_records")

# 输出文件已有内容时沿用其换行风格（仓库内的 Markdown 目前是 CRLF）
eol=$'\n'
if [[ -f $output_path ]] && head -c 4096 -- "$output_path" | grep -q $'\r'; then
    eol=$'\r\n'
fi
emit() {
    printf '%s%s' "$1" "$eol"
}

{
    emit '# 笔记索引'
    emit ''
    emit '> 本文件由 `scripts/生成目录索引.sh`（Linux / macOS）与 `scripts/生成目录索引.ps1`（Windows）自动生成，请勿手动编辑。'
    emit '> 新增、重命名或删除笔记后重新运行：'
    emit '>'
    emit '> ```bash'
    emit '> ./scripts/生成目录索引.sh'
    emit '> ```'
    emit '>'
    emit '> ```powershell'
    emit '> powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\生成目录索引.ps1'
    emit '> ```'
    emit ''
    emit "- 笔记总数：$total"
    emit "- 待补笔记（正文少于 $todo_threshold 字节）：$todo_total"
    emit ''
} >"$out_tmp"

awk -F '\t' -v ORS="$eol" '
{
    n = NR
    topic[n] = $1
    group[n] = $2
    title[n] = $4
    link[n] = $5
    todo[n] = $6
    count[$1]++
}
END {
    for (i = 1; i <= n; i++) {
        if (i == 1 || topic[i] != topic[i - 1]) {
            print "## " topic[i] "（" count[topic[i]] " 篇）"
            print ""
        }
        if (i == 1 || topic[i] != topic[i - 1] || group[i] != group[i - 1]) {
            if (group[i] != "") {
                print "### " group[i]
                print ""
            }
        }
        line = "- [" title[i] "](" link[i] ")"
        if (todo[i] == 1) {
            line = line " `待补`"
        }
        print line
        if (i == n || topic[i + 1] != topic[i] || group[i + 1] != group[i]) {
            print ""
        }
    }
}' "$sorted_records" >>"$out_tmp"

mv -f -- "$out_tmp" "$output_path"

printf '已生成 %s：共 %s 篇笔记，其中 %s 篇待补。\n' "$output_path" "$total" "$todo_total"
