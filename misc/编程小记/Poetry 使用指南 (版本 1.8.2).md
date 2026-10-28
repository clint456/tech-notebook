## 用法:


`poetry 命令 [选项] [参数]`



### 选项:


+ `-h, --help`：显示给定命令的帮助信息。当Q
+ `-q, --quiet`：不输出任何信息。
+ `-V, --version`：显示应用程序版本。
+ `--ansi`：强制使用 ANSI 输出。
+ `--no-ansi`：禁用 ANSI 输出。
+ `-n, --no-interaction`：不询问任何交互式问题。
+ `--no-plugins`：禁用插件。
+ `--no-cache`：禁用 Poetry 源缓存。
+ `-C, --directory=DIRECTORY`：Poetry 命令的工作目录（默认为当前工作目录）。
+ `-v|vv|vvv, --verbose`：增加消息的详细程度：1 表示正常输出，2 表示更详细的输出，3 表示调试输出。



## 可用命令:


+ `about`：显示 Poetry 的相关信息。
+ `add`：向 pyproject.toml 文件中添加新的依赖项。
+ `build`：构建包，默认情况下会构建 tarball 和 wheel 包。
+ `check`：验证 pyproject.toml 文件的内容以及它与 poetry.lock 文件的一致性。
+ `config`：管理配置设置。
+ `export`：将锁定文件导出为其他格式。
+ `help`：显示命令的帮助信息。
+ `init`：在当前目录中创建基本的 pyproject.toml 文件。
+ `install`：安装项目依赖项。
+ `list`：列出命令。
+ `lock`：锁定项目依赖项。
+ `new`：在 `<path>` 中创建新的 Python 项目。
+ `publish`：将包发布到远程仓库。
+ `remove`：从项目依赖项中删除包。
+ `run`：在适当的环境中运行命令。
+ `search`：在远程仓库中搜索包。
+ `shell`：在虚拟环境中启动 shell。
+ `show`：显示包的信息。
+ `update`：根据 pyproject.toml 文件更新依赖项。
+ `version`：显示项目版本或在提供有效的版本规则时将其升



## 缓存


+ `cache clear`：清除 Poetry 缓存 (根据名称)。
+ `cache list`：列出 Poetry 缓存。



## 调试


+ `debug info`：显示调试信息。
+ `debug resolve`：调试依赖项解析。



## 环境


+ `env info`：显示当前环境的信息。
+ `env list`：列出与当前项目关联的所有虚拟环境。
+ `env remove`：删除与项目关联的虚拟环境。
+ `env use`：激活或创建当前项目的虚拟环境。



## 自身


+ `self remove`：从 Poetry 的运行时环境中删除额外的包。
+ `self show`：显示 Poetry 的运行时环境中的包。
+ `self show plugins`：显示当前安装的插件信息。
+ `self update`：将 Poetry 更新到最新版本。



## 源


+ `source add`：为项目添加源配置。
+ `source remove`：删除为项目配置的源。
+ `source show`：显示为项目配置的源信息。



## 有关 Poetry 命令的更多信息，请参阅官方文档。
