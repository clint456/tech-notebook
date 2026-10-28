### 更改默认启动的终端
```bash
# 1.搜索alacritty 当前所在位置
whereis alacritty

# 2.将alacrity 添加到x-terminal-emulator 组中
sudo update-alternatives --install /usr/bin/alacritty x-terminal-emulator <alacritty当前所在位置>

# 3.选择启动，这里选择启动的序号即可
sudo update-alternatives --config x-terminal-emulator
```

> ‼️我在第3步的时候，发现并没实现`ctrl alt T` 启动我新设置的终端，并且原来的也打不开了，真的很想mmp……
>
> 然后为找到了如下方案：
>

[当你搞砸了默认的x-termianl-emulator该怎么办……](https://askubuntu.com/questions/790868/how-to-re-create-the-x-terminal-emulator-alternative)

```bash
# 很直接，重新装一个就完事了
sudo apt-get install --reinstall gnome-terminal
```

> 这里还有一个很神奇的点在于，正当我觉得可能alacritty只能手动打开的时候，居然`ctrl alt t`打开的就是`alacritty`, 大家可以试一试。
>

---

### 设置
#### alacritty会去扫描这几个地方，我们可以新建配置文在这些地方：
> + <font style="color:rgb(34, 34, 34);background-color:rgb(235, 241, 245);">$HOME/.config/alacritty/alacritty.toml</font>
> + <font style="color:rgb(34, 34, 34);background-color:rgb(235, 241, 245);">$HOME/.alacritty.toml</font>
>

任选其一

---

#### 字体设置
我这里使用的字体是`0xProto Nerd Font Mono`

> [Nerd Fonts - Iconic font aggregator, glyphs/icons collection, & fonts patcher](https://www.nerdfonts.com/)
>
> + 自行下载
>

在`alacritty.toml`文件中添加

```bash
  # font setting
[font]
size = 15.0

[font.bold]
family = "0xProto Nerd Font Mono"
style = "Bold"

[font.italic]
family = "0xProto Nerd Font Mono"
style = "Italic"

[font.normal]
family = "0xProto Nerd Font Mono"
style = "Regular"
```

就可以看到效果啦

---

#### [颜色设置](https://github.com/alacritty/alacritty-theme)
##### installation
```bash
# We use Alacritty's default Linux config directory as our storage location here.
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```

##### 在配置文件中添加
```bash
import = [
    "~/.config/alacritty/themes/themes/{theme}.toml"
]
```

