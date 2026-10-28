![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711034722602-7717b088-e1da-4f0e-ba13-f8ae65b5420e.png)

## 前言:
欢迎来到Learn Vim !

这是VsCode中的一款插件 `Learn Vim`,作者：[Jaime González García](https://www.linkedin.com/in/jaimegonzalezgarcia)。

开发这款软件的初衷就是`Boost Your Coding Fu With VSCode and Vim`

大致意思就是将VCode和Vim结合那么将会是天下无敌！！！

在VsCode的插件中心搜索`Learn VIM`，Vim练习生，让我们开始吧。

[视频教程](https://youtu.be/zQ6Ua-8pM9g)

---

## 本书内容：
+ <font style="color:rgba(0, 0, 0, 0.8);">What is Vim? And Why Use Vim in VSCode?</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">How to Install Vim in VSCode?</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Basic Surviving Skills in Vim</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Moving Blazingly Fast with Core Vim Motions</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Editing at The Speed of Thought With Vim Operators and Motions</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Vim’s Secret Language</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Inserting Text a la Vim</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Selecting Text in Visual Mode</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Copy and Pasting Taking Advantage of Registers</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Surrounding Things with Vim Surround</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Moving Even Faster with the Sneak and EasyMotion Plugins</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Creating Custom Shortcuts to Make You More Effective</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Supercharging Multiple Cursors With Vim</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Creating Reusable Editing Units With Macros</font>
+ <font style="color:rgba(0, 0, 0, 0.8);">Integrating VSCode with Neovim For Maximum Awesomeness</font>

---

## 什么是Vim?
Vim是Vi (pro plus ultra)版本，虽然都是图形化文本交互软件，但是Vim在Vi的基础上增加了更强大功能，以至于Vim的作者都没有想到Vim将会传播到全世界的开发者，并且在现在许多的IDE如软件上都受到了Vim的影响，就如VsCode。

---

## 在VsCode上使用Vim：
> 你不禁回反驳到有了VsCode为还用得着用Vim玛？
>

答案是:

`Vim将会给你一种完全不同且更加丝滑的coding感觉`

### vim的几个优点：
+ 更快
+ 更精准的定位
+ 解锁一种全新的coding方式
+ 只有大脑和电脑的coding
+ emmm，足够炫酷 🤣
+ 不用再用鼠标了



### 祖师爷名言：
> <font style="color:rgba(0, 0, 0, 0.8);">Vim is for </font>**<font style="color:rgba(0, 0, 0, 0.8);">programmers who want to raise their game</font>**<font style="color:rgba(0, 0, 0, 0.8);">. In the hands of an expert, </font>**<font style="color:rgba(0, 0, 0, 0.8);">Vim shreds text at the speed of thought</font>**<font style="color:rgba(0, 0, 0, 0.8);">.</font>
>



---

# Vim-Note:
## 第一关：存活


+  `i` -> inert模式 
+  `x` -> 删除当前光标所在位置的一个字 
+  `:wq` -> 存盘+退出(:w 存盘 <文件名> :q 退出) 
+  `dd` -> 删除当前行，并把当前行存到剪切板里 
+  `p` -> 粘贴剪切板  
(请删除)fadajgkajgkj 

## 第二关：感觉良好
### 1.各种插入模式
```plain
print("a -> 在当前光标后插入")
print("o -> 在当前行后插入新行")
print("O -> 在当前行前插入新行")
print("cw -> 替换从光标所在位置后的一个单词")
```

### 2.简单的移动光标
```plain
print("0 -> 到行头")
print("^ -> 当本行第一个不是blank[空格、tab、换行、回车等]字符的位置")
print("$ -> 到行尾")
print("g_ -> 到本行最后一个不是blank字符的位置")
print("G -> 跳到文件末尾")
print("/<要搜索的字符串> -> [如果匹配到多个，按n键到下一个，按N键到上一个]")
```

### 3.拷贝/粘贴
```plain
print("p -> 粘贴")
print("yy -> 拷贝当前行于剪切板")
```

### 4.undo/redo
```plain
print("u -> undo")
print("<ctrl+r> -> redo")
```

### 5.打开/保存/改变文件


```plain
print("e <path/to/file>  -> 打开一个文件")
print(":W -> 存盘 ")
print("saveas <path/to/file> -> 另存为<path/to/file>")
print(":x,zz或:wq ->保存并退出 （:x 表示仅在需要时保存 ;zz 不需要输入冒号和回车")
print("q! -> 退出不保存; :qa! ->强行退出所有正在编辑的文件，就算别的文件有更改")
print(":bn 和:bp -> 你可以同时打开很多文件，使用这两个命令来切换下一个或上一个文件")
```



## 第三关： 更好，更快，更强！
**一些和Vi兼容的命令**

### 1.更好
**(以下的[N]代表在normal模式下键入数字N)**

1.  `.（小数点)` -> 可以重复上一次的命令 
2.  `[N]<command>` ->重复某个命令N次. 

**normal模式下**，输入： `[5]{重复}[ESC]` ,将会得到下面的结果:重复重复重复重复重复重复重复重复重复重复

3.  `2dd` -> 删除2行 
4.  `3p` -> 粘贴剪切板3次（可以试一下） 
5.  3p -> 粘贴剪切板3次 
6.  3p -> 粘贴剪切板3次 
7.  3p -> 粘贴剪切板3次 
8.  `3.` -> 重复上个命令3次 



### 2.更强
1.  `[N]G` -> 跳到第N行 \ 也可以使用 :N 
2.  `gg`-> 到第1行 
3.  `G` ->到最后一行 
4.  按单词移动(这里的单词定义为：由字母，数字和下划线组成) 

> 1. `w` -> 到下一个单词的开头
> 2. `e` -> 到下一个单词的结尾
> 3. `b` -> 到上一个单词的开头
>

（如果希望单词是blank（空格）为分隔符,那么就使用大写的`W`，`E`，`B`）



**光标移动方法的精髓**

1. `%` -> 括号匹配移动,需要光标在对应的括号上`( [ {`都可。
2. `*` 和 `#` -> 匹配光标当前所在单词，移动光标下一个（或上一个）的匹配单词**(_ -> 下一个 ， # -> 上一个)_

(可以自己试着使用一下)

```markdown
例如: x = (name_1,version_3); # this is a comment.
例如: x = (name_1,version_3); # this is a comment.
例如: x = (name_1,version_3); # this is a comment.
例如: x = (name_1,version_3); # this is a comment.
例如: x = (name_1,version_3); # this is a comment.
```



### 3.更快
你一定要记住光标的移动，因为很多命令都可以和这些移动的命令联动。很多命令都可以像这项来操作：`<start position><command><end position>`

1. 例如 `0y$` 意味着
+ `0` -> 先到行头
+ `y` -> 拷贝开始的位置
+ `$` -> 拷贝结束到本行的最后一个字符

`x = (name_1,version_3); # this is a comment.``x = (name_1,version_3); # this is a comment.`这样就实现了单行的拷贝,当然你也可以使用 yy 拷贝本行



2. 例如 `ye`: 从当前位置拷贝到本单词的最后一个字符

`x = (name_1,version_3); # this is a comment.`



3. 例如`y2/name_copy` : 拷贝两name_cpoy 之间的字符串

(其他会进行拷贝的命令)

+ `d` (删除)
+ `v` (可视化模式)
+ `gU` (变大写)
+ `gu` (变小写）

例如: abdagfadjghkjav



## 第四关. Vim的超能力
通过以上学习，你已经可以很舒适的体验Vim了。下面就是一些VIM的犇的功能了

### 4.1 在当前行上移动光标 0 ^ $ f F t T , ;
+  `0` -> 到行头 
+  `^` -> 到本行的第一个非blank字符 
+  `$` -> 到行尾 
+  `g_` -> 到本行最后一个不是blank字符的位置 
+  `fa` -> 到下一个为a的字符处， 你也可以 fs 到下一个为s的字符 
+  `t,` -> 到逗号前的第一个字符。逗号可以变成其他字符 
+  `3fa` -> 在当前行查找第三个出现的a 
+  `F` 和 `T` -> 和f和t一样， 只不过是相反方向。 
+  `dt"` -> 删除所有内容，直到遇到双引号 

```plain
 练习： x =  (name_1, version_3); # this is a comment.
```

 

### 4.2 区域选择`<action>a<object>i<object>`
+  `action` -> 可以是任何的命令， 如`d（删除）`，`y（拷贝）`， `v（可视模式选择）` 
+  `object` -> 可能是 `w（一个以空格为分隔符的单词）` 

```plain
              `s（一个句子）`
              `p（一个段落）`
      也可能是：一个特别的字符
               `" ' ) ] }`
```

  
例如：使用`v<action>`命令来选中一个字符串中的指定内容 

```plain
              ------------------ v2a)
               ~~~~~~~~~~~~~~~~  v2i)
              (map (+). ("foo"))
                          ---    vi"
                         +++++   va" or vi)
                        ======== va)
```

 



### 4.3 块操作 `<ctrl-v>` [ 在windows下，要使用`<ctrl-q>`;因为`<ctrl-q>`是拷贝剪切板]
**典型操作：** `0 <C-v> <C-d> I-- [ESC]`

+  `^` -> 到行头 
+  `<C-v>` -> 开始块操作 
+  `<`C-d>`-> 向下移动 (也可以用`hjkl`来移动光标,或者使用`%N[向下移动N行]`,等等移动光标的操作) 
+  `I-- [ESC]`-> I是插入"--" 
+  `[ESC]` -> 使前面命令生效 

```markdown
--Screen size
--type Size = (Int,Int)
--type Point = (Int,Int)
--type TimePoint = (Int,Int,Int)
--screenSize = (25,79)
--type Drawer = Size -> Int -> [Float]
--fabs x | x < 0 = -x 
```

### 4.4 自动提示 `<ctrl-n>`和`<ctrl-p>`
**该功能将会自动提示上文出现过的单词**

```plain
type Size
screensize
```



### 4.5 宏录制: qa 操作序列 q,@a,@@
+  `qa` 把你的操作记录子寄存器a中 
+  于是`@a`就会repaly被录制的宏 
+  `@@` 是一个快捷键用replay最新录制的宏

### 4.6 可视化操作`v`,`v`,`<ctrl-v>[windows : <ctrl-p>]`
`v` 角色可视模式`v` 逐行可视模式`ctrl-v` 逐块可视模

### 4.7 分屏: `:split` 和 `:vsplit`
`:split` → **创建分屏** (`:vsplit`创建垂直分屏)

`<C-w><dir>` : dir就是方向，可以是 hjkl 或是 ←↓↑→ 中的一个，其用来切换分屏。

`<C-w>_` (或 `<C-w>|`) :最大化尺寸 / (`<C-w>|`垂直分屏)

`<C-w>+` (或 `<C-w>-`) : 增加尺寸



