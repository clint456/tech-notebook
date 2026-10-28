# [XWiki Syntax Guide  XWiki](http://hy-123:8083/xwiki/bin/view/XWiki/XWikiSyntax?xpage=print)
# 概况
XWiki 语法2.1是在Xwiki2.0语法的基础上改进而来，包括一些新特性:

+ 同质化链接和图像语法，提高了图像的清晰度、语法一致性和扩展性。
+ 添加了显示图标、通过Data URL方案嵌入图像，使用[UNC（统一命名约定）](https://baike.baidu.com/item/%E7%BB%9F%E4%B8%80%E5%91%BD%E5%90%8D%E7%BA%A6%E5%AE%9A/20858127)访问文件或相应链接。

XWiki 2.1更正了用户输入的一些错误或不明的语法：

|  描述  |  示例  |  修改 |
| --- | --- | --- |
| 未闭合的文本 | ** bold** | **bold** |
| 两个独立元素，需要由新行分开 | | table cell |<br/>*list item *  | |table cell|<br/><br/>* list item * |
| 忽略文档开头新行 | <font style="color:rgb(51, 51, 51);"><new line at beginning of document></font>   <font style="color:rgb(51, 51, 51);">paragraph  段</font> | <font style="color:rgb(51, 51, 51);">paragraph </font> |
| 非封闭标题语法 | <font style="color:rgb(51, 51, 51);">=== heading</font> | <font style="color:rgb(51, 51, 51);">=== heading === </font> |




# 编辑
## 1、段落
> 段落是由2个或多个新行分割的文本元素
>

|  特征  |  语法  |  结果  |
| --- | --- | --- |
| 简单段落 | <font style="color:rgb(51, 51, 51);">This is a paragraph</font> | <font style="color:rgb(51, 51, 51);">This is a paragraph</font> |
| 多行段落 | <font style="color:rgb(51, 51, 51);">Paragraph on</font><br/><font style="color:rgb(51, 51, 51);">multiple lines</font> | <font style="color:rgb(51, 51, 51);">Paragraph on</font><br/><font style="color:rgb(51, 51, 51);">multiple lines</font> |
| 两段 | <font style="color:rgb(51, 51, 51);">Paragraph one</font><br/><font style="color:rgb(51, 51, 51);"></font><br/><font style="color:rgb(51, 51, 51);">Paragraph two</font> | <font style="color:rgb(51, 51, 51);">Paragraph one</font><br/><font style="color:rgb(51, 51, 51);"></font><br/><font style="color:rgb(51, 51, 51);">Paragraph two</font> |
| 参数化段落 | <font style="color:rgb(51, 51, 51);">(% style="text-align:center;color:blue" %)   </font><font style="color:rgb(51, 51, 51);">Centered and blue paragraph</font> | <font style="color:rgb(0, 0, 255);">Centered and blue paragraph</font><br/><font style="color:rgb(0, 0, 255);">居中和蓝色段落</font> |


## 2、标题
|  特征  |  语法  |  结果  |
| --- | --- | --- |
| 标准标题 | ```plain = level 1 =  == level 2 == === level 3 === ==== level 4 ==== ===== level 5 ===== ====== level 6 ====== ```  | # <font style="color:rgb(51, 51, 51);">level 1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">1 级</font><br/><font style="color:rgb(51, 51, 51);"></font><br/>## <font style="color:rgb(51, 51, 51);">level 2</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">2 级</font><br/>### <font style="color:rgb(51, 51, 51);">level 3</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">3 级</font><br/>#### <font style="color:rgb(51, 51, 51);">level 4</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">4 级</font><br/>##### <font style="color:rgb(51, 51, 51);">level 5</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">5 级</font><br/>###### <font style="color:rgb(51, 51, 51);">level 6  6 级</font> |
| 参数化标题 | <font style="color:rgb(51, 51, 51);">(% style="color:blue" %) </font><br/><font style="color:rgb(51, 51, 51);">= heading = </font> | # <font style="color:blue;">heading  标题</font> |
| XWiki语法标题 | === Heading with **bold******=== | ### Heading with **bold**<br/>### <font style="color:rgb(51, 51, 51);">以</font>**<font style="color:rgb(51, 51, 51);">粗</font>**<font style="color:rgb(51, 51, 51);">体显示标题</font> |


## 3、文本格式
> 新功能
>
> + 语法符号后允许有空格
> + 当语法中只有一个符号时，请使用双精度符号
> + 能够跨域多行
>

| 特征 | 语法 | 结果 |
| --- | --- | --- |
| 加粗 | **bold** | **bold** |
| 下划线 | _underline_ | <u>underline</u> |
| 斜体字 | //italic// | _italic_ |
| 删除线 | --strike-- | ~~stike~~ |
| 等宽字符 | monospace | <font style="color:rgb(51, 51, 51);">monospace</font> |
| 上标 | some ^^superscript^^ | <font style="color:rgb(51, 51, 51);">some </font><sup><font style="color:rgb(51, 51, 51);">superscript</font></sup> |
| 下标 | some,,subscript | <font style="color:rgb(51, 51, 51);">some </font><sub><font style="color:rgb(51, 51, 51);">subscript</font></sub> |


## 4、水平线
> 四个或更多的破折号
>

|  特征  |  语法  |  结果  |
| --- | --- | --- |
| 简单水平线 | ---- | |
| 参数化水平线 | {% style="color:blue"%}<br/>---- | |


## 5、列表
|  特征  |  语法  |  结果  |
| --- | --- | --- |
| 项目符号列表 | ```plain * item 1 ** item 2 *** item 3 * item 4 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>    - <font style="color:rgb(51, 51, 51);">item 2 </font><br/>        * <font style="color:rgb(51, 51, 51);">item 3 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 4 </font> |
| <font style="color:rgb(51, 51, 51);">Numbered list  编号列表</font> | ```plain 1. item 1 11. item 2 111. item 3 1. item 4 ```  | 1. <font style="color:rgb(51, 51, 51);">item 1 </font><br/>    1. <font style="color:rgb(51, 51, 51);">item 2 </font><br/>        1. <font style="color:rgb(51, 51, 51);">item 3 </font><br/>2. <font style="color:rgb(51, 51, 51);">item 4 </font> |
| <font style="color:rgb(51, 51, 51);">Mixed list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">混合列表</font> | ```plain 1. item 1 1*. item 2 1*. item 3 1. item 4 ```  | 1. <font style="color:rgb(51, 51, 51);">item 1 </font><br/>    - <font style="color:rgb(51, 51, 51);">item 2 </font><br/>    - <font style="color:rgb(51, 51, 51);">item 3 </font><br/>2. <font style="color:rgb(51, 51, 51);">item 4 </font> |
| <font style="color:rgb(51, 51, 51);">Square list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">Square 列表</font> | ```plain (% style="list-style-type: square" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Disc list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">光盘列表</font> | ```plain (% style="list-style-type: disc" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2  </font> |
| <font style="color:rgb(51, 51, 51);">Lowercase Alphabetical list</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">小写字母列表</font> | ```plain (% style="list-style-type: lower-alpha" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1  </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Uppercase Alphabetical list</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">大写字母列表</font> | ```plain (% style="list-style-type: upper-alpha" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2  </font> |
| <font style="color:rgb(51, 51, 51);">Lowercase Roman list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">小写罗马列表</font> | ```plain (% style="list-style-type: lower-roman" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1  </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Uppercase Roman list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">大写罗马列表</font> | ```plain (% style="list-style-type: upper-roman" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Lowercase Greek list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">小写希腊语列表</font> | ```plain (% style="list-style-type: lower-greek" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Uppercase Greek list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">大写希腊语列表</font> | ```plain (% style="list-style-type: upper-greek" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Hiragana list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">平假名列表</font> | ```plain (% style="list-style-type: hiragana" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Hiragana Iroah list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">平假名 Iroah 列表</font> | ```plain (% style="list-style-type: hiragana-iroha" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font><br/>    - <font style="color:rgb(51, 51, 51);">item 1  </font> |
| <font style="color:rgb(51, 51, 51);">Katakana list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">片假名列表</font> | ```plain (% style="list-style-type: katakana" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 2  </font> |
| <font style="color:rgb(51, 51, 51);">Katakana Iroha list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">片假名 Iroha 列表</font> | ```plain (% style="list-style-type: katakana-iroha" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Armenian list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">亚美尼亚语名单</font> | ```plain (% style="list-style-type: armenian" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Hebrew list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">希伯来语列表</font> | ```plain (% style="list-style-type: hebrew" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">Georgian list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">格鲁吉亚名单</font> | ```plain (% style="list-style-type: georgian" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2 </font> |
| <font style="color:rgb(51, 51, 51);">CJK ideographic list</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">中日韩表意文字列表</font> | ```plain (% style="list-style-type: cjk-ideographic" %) * item 1 * item 2 ```  | + <font style="color:rgb(51, 51, 51);">item 1 </font><br/>+ <font style="color:rgb(51, 51, 51);">item 2  </font> |


6、定义列表 

|  特征  |  语法  |  结果 |
| --- | --- | --- |
| 标准定义 | :term<br/>:definition | term 术语<br/>definition 定义 |
| 嵌套定义 | :term 1<br/>:definition 1<br/>:term 2 <br/>:definition 2 |  |
| 参数化定义  | {% style="color.bule"%}<br/>:term<br/>:definition |  |


## 7、新换行符/换行符
> 新行是回车，换行符是出现在文本中的任意位置的强制换行符
>

|  特征  |  语法  |  结果  |
| --- | --- | --- |
| Line break  | Line\\New line  | line<br/>New line |
| New line | Line<br/>New line | Line<br/>New Line |


## 8、链接
|  特征  |  语法  |  结果  |
| --- | --- | --- |
| 链接到当前Space中的页面 | [[WebHome]] | WebHome |
| 使用标签链接 | [[label>>WebHome]]<br/><font style="background-color:#FBDE28;">链接标签内支持XWiki语法</font> | label |
| 在标签中使用XWiki语法链接 | [[**bold label**>>WebHome]] | bold label |
| 链接到具有指定Space的页面 | [[Main.WebHome]] | WebHome |
| 链接到子wiki | [[subwiki:Main.WebHome]] | WebHome |
| 在新窗口中打开的链接 | [[label>>WebHomw||rel="_blank"]] | label |
| 直接在文本中链接到URL | <font style="color:rgb(51, 51, 51);">This is a URL: http://xwiki.org</font> | <font style="color:rgb(51, 51, 51);">This is a URL: http://xwiki.org</font> |
| 链接到URL | <font style="color:rgb(51, 51, 51);">[[http://xwiki.org]]</font> | <font style="color:rgb(51, 51, 51);"></font> |
| 链接到待有标签的URL | <font style="color:rgb(51, 51, 51);">[[XWiki>>http://xwiki.org]]   </font><font style="color:rgb(51, 51, 51);">[[Sviki%3A%3AHTTP：//sbiki.org]]</font> | <font style="color:rgb(51, 51, 51);">XWiki</font> |
| 连接到电子邮件地址 | <font style="color:rgb(51, 51, 51);">[[john@smith.net>>mailto:john@smith.net]]</font> | [<font style="color:rgb(0, 136, 204);">john@smith.net</font>](mailto:john@smith.net) |
| 图片链接 | [[imge:Space2.Page2@img.png>>Space1.Page1]] |  |
| <font style="color:rgb(51, 51, 51);">使用图像参数的 Image Link</font> | <font style="color:rgb(51, 51, 51);">[[[[image:Space2.Page2@img.png||width="26" height="26"]]>>Space1.Page1]]</font> |  |
| <font style="color:rgb(51, 51, 51);">链接到当前页面上的附件</font> | <font style="color:rgb(51, 51, 51);">[[text>>attach:img.png]]</font> | text |
| <font style="color:rgb(51, 51, 51);">连接到其他页面中的附件</font> | [[text>>attach:Space.Page@img.png]] | text |
| <font style="color:rgb(51, 51, 51);">连接到页面中的锚点</font> | [[label>>Space.Page||anchor="anchor" | label |
| <font style="color:rgb(51, 51, 51);">链接到页面中的标题</font> | [[label>>XWiki.XWikiSyntax||anchor="HMyheading"]] | label |
| <font style="color:rgb(51, 51, 51);">链接到当前页面中的锚点</font> | [[label>>||anchor="anchor"]] | label |


> 添加标题时，将创建一个名为“H”的锚点，后紧跟包含字母字符的标题。
>
> 例如，对于名为“My heading”的标题，生成的锚点将为“HMyheading”
>

### XWiki语法2.1链接规范
> ( )中的部分是必须的，[ ]中的部分是可选的
>

链接的完整格式为[label>>](resource)[||参数]

+ label ：【可选字符串】在呈现时将作为链接名称显示给用户。【可能包含XWiki语法】如果为指定标签，将生产默认标签。生产模式可以更改。
+ resource：【必须】
    - URL：
    - Wiki page name：
    - InterWiki page name：
    - Attachment：
    - Email address：
    - Relative path：
    - UNC（Windows Explorer）
+ parameters：【可选参数列表】传递给链接的，以空格分隔
    - queryString
    - anchor
    - rel

## 9、表
> 允许轻松创建表格格式的内容
>

|  特征  |  语法  |  结果  |
| --- | --- | --- |
| 标准表 | |=Title 1|  = Title2<br/>|World 1| World 2<br/><br/>or<br/>!=Title 1 !=Title2<br/>!!World 1!!World 2 | ![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1740994813068-5fdcadc7-a356-4a9f-96f5-17c03dc59d46.png) |
| 参数化列表 | ```plain (% style="background-color:red;align=center" %) |=Title 1|=(% style="background-color:yellow" %)Title 2 |Word 1|Word 2 ```  | ![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1740994835206-7c89a600-a580-46e2-b3c6-d9b30ced96c1.png) |
| 可筛选的可排序表 | ```plain {{velocity}} $xwiki.ssfx.use("js/xwiki/table/table.css") $xwiki.jsfx.use("js/xwiki/table/tablefilterNsort.js", true) {{/velocity}}  (% class="grid sortable filterable doOddEven" id="tableid" %) (% class="sortHeader" %)|=Title 1|=Title 2 |Cell 11|Cell 12 |Cell 21|Cell 22 ```  | ![](https://cdn.nlark.com/yuque/0/2025/png/33522184/1740994860411-99d1b878-a02e-4d04-ae15-22b0f169a120.png) |


## 10、图像
| <font style="color:rgb(51, 51, 51);">Feature</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">特征</font> | <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> | <font style="color:rgb(51, 51, 51);">Result</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">结果</font> |
| --- | --- | --- |
| <font style="color:rgb(51, 51, 51);">Image from attachment on current page</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">图片来自当前页面上的附件</font> | <font style="color:rgb(51, 51, 51);">image:img.png</font> |  |
| <font style="color:rgb(51, 51, 51);">Image from attachment on another page</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">来自另一个页面上的附件的图像</font> | <font style="color:rgb(51, 51, 51);">image:Space.Page@img.png</font> |  |
| <font style="color:rgb(51, 51, 51);">Image with parameters</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">带参数的图片</font> | <font style="color:rgb(51, 51, 51);">[[image:img.png||width="25" height="25"]]</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">[[image:img.png||width=“25” height=“25”]]</font> |  |
| <font style="color:rgb(51, 51, 51);">Images located at URL</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">位于 URL 的图片</font> | <font style="color:rgb(51, 51, 51);">image:http://some/url/img.png</font> |  |
| <font style="color:rgb(51, 51, 51);">Prepackaged Icons</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">预打包的图标</font> | <font style="color:rgb(51, 51, 51);">image:icon:accept</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">image：icon：接受</font> |  |


### XWiki语法2.1图像规范<font style="color:rgb(49, 112, 143);">  
</font><font style="color:rgb(49, 112, 143);">（ ） 中的部分是必需的，而 { } 中的部分是可选的。</font>
<font style="color:rgb(51, 51, 51);">图像的完整格式为 </font>**<font style="color:rgb(51, 51, 51);">image： （参考）</font>**<font style="color:rgb(51, 51, 51);"> 或 </font>**<font style="color:rgb(51, 51, 51);">[[image： （参考） {||参数}]]</font>**

+ image：【必须字符串】
+ reference：对图像的引用，以以下格式展示
    - URL
    - Attachment：**<font style="color:rgb(51, 51, 51);">格式的附件引用 {{{wikiName:} space.} page@} (imageName)</font>**
    - Icon：**<font style="color:rgb(51, 51, 51);">（icon：） （iconName）</font>**<font style="color:rgb(51, 51, 51);"> 中的</font>**<font style="color:rgb(51, 51, 51);">图标</font>**<font style="color:rgb(51, 51, 51);">引用。示例：</font>**<font style="color:rgb(51, 51, 51);">icon：accept</font>**
    - **<font style="color:rgb(51, 51, 51);">Data：（data：） （content）</font>**<font style="color:rgb(51, 51, 51);"> 中的数据 </font>**<font style="color:rgb(51, 51, 51);">URI</font>**<font style="color:rgb(51, 51, 51);">。示例： </font>**<font style="color:rgb(51, 51, 51);">data：image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==</font>**
+ parameters：传递给映像的【可选】参数列表

# 高级
## 11、Verbatim
> <font style="color:rgb(51, 51, 51);">允许输入不会被格式化的内容（换句话说，将不考虑 XWiki 语法）</font>
>

| <font style="color:rgb(51, 51, 51);"> 特征 </font> | <font style="color:rgb(51, 51, 51);"> 语法 </font> | <font style="color:rgb(51, 51, 51);"> 结果 </font> |
| --- | --- | --- |
| <font style="color:rgb(51, 51, 51);">Verbatim inline  逐字内联</font> | <font style="color:rgb(51, 51, 51);">Some verbatim {{{**[[not rendered]]**}}} content</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">一些逐字 {{{**[[未呈现]]**}}} 内容</font> | <font style="color:rgb(51, 51, 51);">Some verbatim</font><font style="color:rgb(51, 51, 51);"> </font><font style="color:rgb(51, 51, 51);">**[[not rendered]]**</font><font style="color:rgb(51, 51, 51);"> </font><font style="color:rgb(51, 51, 51);">content</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">一些逐字</font><font style="color:rgb(51, 51, 51);"> </font><font style="color:rgb(51, 51, 51);">**[[未呈现]]**</font><font style="color:rgb(51, 51, 51);"> </font><font style="color:rgb(51, 51, 51);">内容</font> |
| <font style="color:rgb(51, 51, 51);">Verbatim block</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">逐字块</font> | ```plain {{{ multi line **verbatim** content }}} ```  | ```plain multi line **verbatim** content ```  |


## <font style="color:rgb(51, 51, 51);">12、Quotations</font>
> 允许引用一些文本
>

| <font style="color:rgb(51, 51, 51);">Feature</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">特征</font> | <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> | <font style="color:rgb(51, 51, 51);">Result</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">结果</font> |
| --- | --- | --- |
| <font style="color:rgb(51, 51, 51);">Simple quote</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">简单报价</font> | ```plain > john said this I said ok ```  | <font style="color:rgb(51, 51, 51);">john said this</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">约翰这样说</font> |
| <font style="color:rgb(51, 51, 51);">Nested quotes</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">嵌套引号</font> | ```plain > john said this >> marie answered that I said ok ```  | <font style="color:rgb(51, 51, 51);">john said this</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">约翰这样说</font><br/><font style="color:rgb(51, 51, 51);">marie answered that</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">玛丽回答说</font> |


## 13、组
> <font style="color:rgb(51, 51, 51);">组可用于将另一个内联文档直接插入到当前文档中。例如，这允许在列表项或表格单元格内插入复杂元素。组由以下语法元素分隔：（（（...）））。一个 Group 可以包含另一个 Group，并且没有叠加限制。</font>
>

| <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> | <font style="color:rgb(51, 51, 51);">Result</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">结果</font> | |
| --- | --- | --- |
| ```plain |=Header 1|=Header 2|=Header 3 |Cell One|((( = Embedded document =  Some embedded paragraph.  * list item one * list item two   ** sub-item 1   ** sub-item 2 ))) | Cell Three  Next paragraph in the top-level document ```  | <font style="color:rgb(51, 51, 51);">Next paragraph in the top-level document</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">顶级文档中的下一段</font> | |
| <font style="color:rgb(51, 51, 51);">Header 1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">标头 1</font> | <font style="color:rgb(51, 51, 51);">Header 2</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">标头 2</font> | <font style="color:rgb(51, 51, 51);">Header 3</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">标头 3</font> |
| <font style="color:rgb(51, 51, 51);">Cell One</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">Cell 1 （第一单元）</font> | # Embedded document  嵌入式文档<br/><font style="color:rgb(51, 51, 51);">Some embedded paragraph.</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">一些嵌入的段落。</font><br/>+ <font style="color:rgb(51, 51, 51);">list item one</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">列表项 1</font><br/>+ <font style="color:rgb(51, 51, 51);">list item two</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">列表项 2</font><br/>    - <font style="color:rgb(51, 51, 51);">sub-item 1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">子项目 1</font><br/>    - <font style="color:rgb(51, 51, 51);">sub-item 2</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">子项目 2</font> | <font style="color:rgb(51, 51, 51);"> Cell Three</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">Cell 3 （第三单元）</font> |




## 14、Escape
> 允许转义XWiki语法
>

| <font style="color:rgb(51, 51, 51);">Feature</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">特征</font> | <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> | <font style="color:rgb(51, 51, 51);">Result</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">结果</font> |
| --- | --- | --- |
| <font style="color:rgb(51, 51, 51);">Escape a character</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">转义字符</font> | <font style="color:rgb(51, 51, 51);">This is not a ~[~[link~]~]</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">这不是 ~[~[link~]~]</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(49, 112, 143);background-color:rgb(217, 237, 247);">To enter a ~ character use a double escape: ~~</font><font style="color:rgb(49, 112, 143);background-color:rgb(217, 237, 247);">   </font><font style="color:rgb(49, 112, 143);background-color:rgb(217, 237, 247);">要输入 ~ 字符，请使用双转义符：~~</font> | <font style="color:rgb(51, 51, 51);">This is not a [[link]]</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">这不是 [[link]]</font> |
| <font style="color:rgb(51, 51, 51);">Escape longer text</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">转义较长的文本</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">(also see "Verbatim")</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">（另见“逐字”）</font> | <font style="color:rgb(51, 51, 51);">{{{</font><font style="color:rgb(51, 51, 51);"> some **longer** text //without// formatting</font><font style="color:rgb(51, 51, 51);">}}}</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">{{{</font><font style="color:rgb(51, 51, 51);"> 一些 **较长** 的文本 //没有 // 格式}}</font><font style="color:rgb(51, 51, 51);">}</font> | <font style="color:rgb(51, 51, 51);"> some **longer** text //without// formatting</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">一些 **较长** 的文本 //没有 // 格式</font> |


## <font style="color:rgb(51, 51, 51);">15、参数</font>
<font style="color:rgb(51, 51, 51);">使用 XWiki Syntax 2.1，可以将参数传递给不同的语法元素以及文本块。例如，这用于设置它们的样式。您可以设置所需的任何参数键/值对。XHTML 渲染器会将这些参数作为 XHTML 属性传递给不同语法元素的基础 XHTML 表示。</font>

| <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> | <font style="color:rgb(51, 51, 51);">Generated XHTML</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">生成的 XHTML</font> |
| --- | --- |
| ```plain (% class="myClass" style="myStyle" id="myId" %) = heading = ```  | <font style="color:rgb(51, 51, 51);"><h1 class="myClass" style="myStyle" id="myId">heading</h1></font> |


# <font style="color:rgb(51, 51, 51);">编程</font>
## <font style="color:rgb(51, 51, 51);">16、Macros  宏</font>
<font style="color:rgb(51, 51, 51);">XWiki 语法 2.1 中只有一种宏，它由语法调用： {{macroname param1=“value1” ...paramN=“valueN”}}...{{/macroname}} 中。对于没有内容的宏，有一个简短的表示法： {{macroname param1=“value1” ...paramN=“valueN”/}}</font>

| <font style="color:rgb(51, 51, 51);">Feature</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">特征</font> | <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> | <font style="color:rgb(51, 51, 51);">Result</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">结果</font> |
| --- | --- | --- |
| <font style="color:rgb(51, 51, 51);">Rendering Macro with a content</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">渲染包含内容的宏</font> | ```plain {{code language="java"}} System.out.println("Hello World!"); {{/code} ```  | <font style="color:rgb(51, 51, 51);background-color:rgb(245, 245, 245);">System</font><font style="color:rgb(102, 102, 102);background-color:rgb(245, 245, 245);">.</font><font style="color:rgb(125, 144, 41);background-color:rgb(245, 245, 245);">out</font><font style="color:rgb(102, 102, 102);background-color:rgb(245, 245, 245);">.</font><font style="color:rgb(125, 144, 41);background-color:rgb(245, 245, 245);">println</font><font style="color:rgb(102, 102, 102);background-color:rgb(245, 245, 245);">(</font><font style="color:rgb(186, 33, 33);background-color:rgb(245, 245, 245);">"Hello World!"</font><font style="color:rgb(102, 102, 102);background-color:rgb(245, 245, 245);">);</font> |
| <font style="color:rgb(51, 51, 51);">Rendering Macro without content</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">渲染无内容的宏</font> | <font style="color:rgb(51, 51, 51);">{{include reference="Space.Page"/}}</font> | <font style="color:rgb(51, 51, 51);">The referenced page is included in the current page</font><font style="color:rgb(51, 51, 51);">   </font><font style="color:rgb(51, 51, 51);">引用的页面包含在当前页面中</font> |


> <font style="color:rgb(49, 112, 143);background-color:rgb(217, 237, 247);">Radeox 宏不能在 XWiki 语法 2.1 中使用。因此，它们已被重写为 Rendering 宏。</font>
>

## <font style="color:rgb(51, 51, 51);">17、HTML</font>
| <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> | <font style="color:rgb(51, 51, 51);">Result</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">结果</font> |
| --- | --- |
| <font style="color:rgb(51, 51, 51);">{{html}}<b>bold</b>{{/html}} </font> | **<font style="color:rgb(51, 51, 51);">bold</font>****<font style="color:rgb(51, 51, 51);">  </font>****<font style="color:rgb(51, 51, 51);">大胆</font>** |


> <font style="color:rgb(49, 112, 143);background-color:rgb(217, 237, 247);">在 XWiki 语法 2.1 中，默认情况下，HTML 宏不理解 XWiki 语法（包括其他宏，因为它也是 XWiki 语法）。要启用它，请使用 {{html wiki=“true”}} 。</font>
>

## <font style="color:#000000;background-color:rgba(255, 255, 255, 0);">18、脚本</font>
> <font style="color:rgb(49, 112, 143);background-color:rgb(217, 237, 247);">在 XWiki Syntax 1.0 中，可以直接在页面的任何地方输入 Velocity 脚本。这会导致问题，例如，当用户非自愿地输入 Velocity 内容时。对于不需要 Velocity 内容的页面来说，它也对性能要求很高。还有其他一些技术限制。因此，在 XWiki Syntax 2.1 中，必须使用 velocity 宏输入 Velocity 脚本。输入 Groovy 脚本也是如此。</font>
>

<font style="color:rgb(49, 112, 143);background-color:rgb(217, 237, 247);"></font>

| <font style="color:rgb(51, 51, 51);">Feature</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">特征</font> | <font style="color:rgb(51, 51, 51);">XWiki Syntax 2.1</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">XWiki 语法 2.1</font> |
| --- | --- |
| <font style="color:rgb(51, 51, 51);">Velocity script</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">Velocity 脚本</font> | ```plain {{velocity}} #set ($var = "whatever") {{/velocity}} ```  |
| <font style="color:rgb(51, 51, 51);">Groovy script</font><font style="color:rgb(51, 51, 51);">  </font><font style="color:rgb(51, 51, 51);">Groovy 脚本</font> | ```plain {{groovy}} def var = "whatever" {{/groovy}} ```  |


