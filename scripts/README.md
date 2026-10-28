# scripts

仓库维护脚本。索引脚本有两个实现，扫描规则和输出格式一致，按系统选一个执行即可。

| 脚本 | 平台 | 运行方式 |
| --- | --- | --- |
| [`生成目录索引.sh`](./生成目录索引.sh) | Linux / macOS（bash 3.2+） | `./scripts/生成目录索引.sh` |
| [`生成目录索引.ps1`](./生成目录索引.ps1) | Windows（PowerShell 5.1+ / 7） | `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\生成目录索引.ps1` |

`.sh` 必须是 LF 换行（仓库已按此提交），从 Windows 拷过来若提示
`bad interpreter`，执行 `chmod +x scripts/生成目录索引.sh` 并确认换行未被改成 CRLF。

## 生成目录索引

扫描仓库内所有 Markdown 笔记，生成仓库根目录的 [索引.md](../索引.md)。

- 主题目录：仓库根目录下的一级目录；`notes/`、`interview/`、`career/`、`misc/` 下的
  二级目录并入主题（如 `notes / cs-basics`），更深的层级作为子分组。
- 跳过：`node_modules`、`.git`、`.obsidian`、`资料`、`_模板`、`scripts`、`dist`、
  `build`、`target`、`bin`、`obj`、`out`，以及任意层级的 `README.md`；根目录的
  `README.md`、`文档规范.md`、`索引.md` 不入索引。
- 标题：优先用首行 `# 标题`（去掉 HTML 标签、链接、`*` `_` 反引号），
  清理后不比文件名长时退回文件名。
- 待补：正文小于阈值（默认 100 字节）的笔记加 `待补` 标记。
- 排序：主题 → 子分组 → 文件名；数字补零到 8 位（`2` < `10`），忽略大小写。
- 换行：输出文件已存在时沿用其换行风格（本仓库的 Markdown 目前是 CRLF）。

### 用法

```bash
./scripts/生成目录索引.sh                    # 默认：仓库根目录 + 索引.md + 100 字节
./scripts/生成目录索引.sh -t 200             # 待补阈值改为 200 字节
./scripts/生成目录索引.sh -o 笔记清单.md      # 换一个输出文件名
./scripts/生成目录索引.sh -r ~/notes         # 扫描其它仓库根目录
./scripts/生成目录索引.sh -c zh_CN.UTF-8     # 中文按拼音排序（需先安装该 locale）
```

| 选项 | 默认值 | 说明 |
| --- | --- | --- |
| `-r, --root <目录>` | 脚本所在目录的上一级 | 仓库根目录 |
| `-o, --output <文件名>` | `索引.md` | 输出文件名，落在仓库根目录 |
| `-t, --threshold <字节>` | `100` | 正文小于该字节数标记 `待补` |
| `-c, --collate <locale>` | `C.UTF-8` | 排序使用的 locale |
| `-h, --help` | — | 显示帮助 |

退出码：`0` 成功；`1` 运行失败（如根目录不存在）；`2` 参数错误。

### 中文排序

两个脚本的分组、标题、待补判定完全一致，但中文文件名的先后依赖系统区域设置：

- Windows 按系统区域排序（中文区域为拼音顺序）。
- Linux / macOS 默认按 UTF-8 码位排序，跨机器结果稳定；已安装 `zh_CN.UTF-8` 时可用
  `-c zh_CN.UTF-8` 得到拼音顺序（Debian/Ubuntu：`sudo locale-gen zh_CN.UTF-8`）。

同一批笔记在上面的两种排序下，中文条目先后可能不同，条目本身不会丢失。

## 约定

- 脚本保持幂等：内容不变时重复运行结果相同。
- `索引.md` 是生成物，不要手改；头部注释已注明。
- 新增脚本同样提供 `.sh`（Linux/macOS）与 `.ps1`（Windows）两份，并在此文件登记。
