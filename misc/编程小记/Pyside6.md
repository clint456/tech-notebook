:::info
💡  根据 [遗忘曲线](https://baike.baidu.com/item/%E9%81%97%E5%BF%98%E6%9B%B2%E7%BA%BF/7278665?fr=aladdin)：如果没有记录和回顾，6天后便会忘记75%的内容

      读书笔记正是帮助你记录和回顾的工具，不必拘泥于形式，其核心是：记录、翻看、思考

:::

| **书名** | **Create GUI Applications with Python & Qt6**<br/>The hands-on guide to making apps with Python |
| --- | --- |
| **作者** | Martin Fitzpatrick |
| **状态** | <font style="background:#F6E1AC;color:#664900">阅读中</font>  |
| **简介** | <font style="color:rgb(0, 0, 0);">如果您想使用 Python 创建 GUI 应用程序，则很难知道在哪里开始。有很多新概念你需要理解才能实现工作。但是，就像任何编码问题一样，第一步是学习解决问题以正确的方式解决问题。在这本书中我借鉴了GUI的基本原理，使用 PySide6 进行开发以创建您自己的、功能齐全的桌面应用程序。</font> |


---

## 格式声明：
> ✉️：信息
>

> 💡：提示
>

> ‼️： 警告
>

---

## 简介
### GUI的简史
<font style="color:rgb(0, 0, 0);">图形用户界面有着悠久而悠久的历史，可以追溯到远至20世纪60年代。斯坦福大学的 NLS（在线系统）推出了鼠标和Windows 概念于 1968 年首次公开展示。随后Xerox PARC Smalltalk 系统 GUI 1973，这是最现代的基础通用GUI。</font>

<font style="color:rgb(0, 0, 0);">这些早期的系统已经具有许多我们认为理所当然的功能现代桌面 GUI，包括窗口、菜单、单选按钮、复选框和图标。这些功能的组合为我们提供了早期使用的缩写词、界面类型：</font>**<font style="color:rgb(0, 0, 0);">WIMP</font>**<font style="color:rgb(0, 0, 0);">（窗口、图标、菜单、定点设备 - 鼠标）。</font>

<font style="color:rgb(0, 0, 0);">1979 年，第一个具有 GUI 的商业系统发布 - PERQ工作站。这刺激了许多其他 GUI 的努力，其中值得注意的是Apple Lisa (1983)，添加了菜单栏和窗口的概念控件以及 Atari (GEM) 和 Amiga 的其他系统。在 UNIX 上，Window 系统于 1984 年出现，第一个用于 PC 的 Windows 版本是1985年发布。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711441001444-cb6838f3-8cf6-4760-9fed-2480c3a5ec47.png)

<font style="color:rgb(0, 0, 0);">早期的 GUI 并没有像你想象的那样立即流行，因为缺乏兼容的启动时的软件和昂贵的硬件要求——特别是对于家庭用户。然而，缓慢而稳定地，GUI 范式成为了计算机交互的首选方式，WIMP也确立成了名誉上标准。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711441442613-76882aac-123a-4d6a-a69d-aee215f0a67c.png)

---

### 关于Qt
<font style="color:rgb(0, 0, 0);">Qt 是一个免费的开源小部件工具包，用于创建跨平台 GUI应用程序，允许应用程序针对 Windows 的多个平台，macOS、Linux 和 Android 具有单一代码库。但 Qt 不仅仅是一个小部件工具包和内置支持多媒体、数据库、矢量的功能图形和MVC接口，将其视为应用程序更准确发展框架Qt 由 Eirik Chambe-Eng 和 Haavard Nord 于 1991 年创立，创立了第一家 Qt 公司 Trolltech 于 1994 年成立。Qt 目前由 The Qt Company 开发并持续定期更新，添加功能并扩展移动端和跨平台支持。</font>

---

### Qt和PySide6
<font style="color:rgb(0, 0, 0);">PySide6，也称为 Qt for Python，是 Qt 工具包的 Python 绑定，目前由 Qt 公司开发。当您使用以下方式编写应用程序时PySide6 你真正在做的是用 Qt 编写应用程序。 PySide6库实际上是 C++ Qt 库的包装器，这使得可以在Python中使用。</font>

<font style="color:rgb(0, 0, 0);">因为这是 C++ 库的 Python 接口，所以使用的命名约定PySide6 中不遵守 PEP8 标准。例如，函数和变量使用</font>`<font style="color:rgb(0, 0, 0);">mixedCase</font>`<font style="color:rgb(0, 0, 0);">而不是</font>`<font style="color:rgb(0, 0, 0);">snake_case </font>`<font style="color:rgb(0, 0, 0);">命名。无论你坚持在您自己的应用程序中达到这个标准完全取决于您自己，最好还是学习一下</font>[<font style="color:rgb(0, 0, 0);">PEP8标准</font>](https://peps.python.org/pep-0008/)<font style="color:rgb(0, 0, 0);">，让代码更加pythonic.</font>

<font style="color:rgb(0, 0, 0);">最后，虽然有 PySide6 特定文档可用，但您经常会发现自己正在阅读 Qt 文档本身，因为它更完整。如果你需要有关将 Qt C++ 代码转换为 Python 的建议，</font><font style="color:rgb(0, 0, 0);">请查看[]()</font>

---

**更多资源**

[**Python GUI学院**](https://www.pythonguis.com/)

[**本书源码**](http://www.pythonguis.com/d/pyside6-source.zip)****

---

## PySide6的基本功能
<font style="color:rgb(0, 0, 0);">是时候迈出使用 PySide6 创建 GUI 应用程序的第一步了！</font>

<font style="color:rgb(0, 0, 0);">在本章中，您将了解 PySide6 的基础知识：我们将开发一个简单的窗口应用程序，这是任何应用程序的基础。我们将添加小部件，使用</font>`<font style="color:rgb(0, 0, 0);">layout</font>`<font style="color:rgb(0, 0, 0);">来排列它们，将这些小部件连接到函数，允许您触发应用程序行为。</font>

### <font style="color:rgb(0, 0, 0);">1.第一个应用程序</font>
### 2.信号与槽 (Signal | Slot) 
---

### 3.组件（Widgets）
---

### 4.布局 (Layouts)
---

### 5.交互、工具栏、菜单栏(Action、Toolbars & Menus)
---

### 6.对话框(dialogs)
---

### 7.窗口(Windows)
---

### 8.事件(Events)
---

## Qt Designer
### 1.安装
---

### 2.使用
---

### 3.资源系统
---

## 主题化
### 1.风格(styles) 
---

### 2.调色板
---

### 3.图标
---

### 4.QSS（Qt Style Sheets)
---

## 视图架构模型
### 1.<font style="color:rgb(0, 0, 0);">视图模型架构——视图模型视图模型控制器</font>
---

### 2.一个简单的试图模型
---

### 3. ModelViews 中的表格数据，使用 numpy 和 pandas
---

### 4.<font style="color:rgb(0, 0, 0);">使用Qt模型查询SQL数据库</font>
---

 

---

## 自定义小组件
<font style="color:rgb(0, 0, 0);">正如我们所见，Qt 内置了多种小部件，您可以使用它们构建您的应用程序。即便如此，有时这些简单的小部件并不足够了——也许你需要一些自定义类型的输入，或者想要可视化</font>

<font style="color:rgb(0, 0, 0);">以独特的方式获取数据。在 Qt 中，您可以自由创建自己的小部件，无论是从头开始或者组合现有的小组件。</font>

<font style="color:rgb(0, 0, 0);">在本章中，我们将了解如何使用位图图形和自定义信号来创建你自己的小组件。</font>

---

### 1.Qt中的位图(Bitmap Graphic)
<font style="color:rgb(0, 0, 0);">在 PySide6 中创建自定义小部件的第一步是了解位图（基于像素的）图形操作。所有标准小部件都会自行绘制作为形成小部件形状的矩形“画布”上的位图。</font>

<font style="color:rgb(0, 0, 0);">如果想知道这是如何工作的，我们可以自行绘制自己喜欢的自定义小组件。</font>

> ✉️：**位图——**<font style="color:rgb(0, 0, 0);">像素的矩形网格，其中每个像素（及其颜色）是由多个“位”表示。它们与矢量图形不同，其中图像存储为一系列线条（或矢量）绘图形状，用于来形成图像。如果您在屏幕上查看矢量图形，它们是被光栅化 - 转换为位图图像 - 显示为像素到屏幕上。</font>
>

##### <font style="color:rgb(0, 0, 0);">1.QPainter</font>
> Qt的位图绘制操作是通过QPainter类处理，这是一个接口类，可以用于在各种表面上绘图。如QPixmap，在本章为门敬爱嗯学习在Qpixmap上利用Qpainter绘图。
>

---

###### 绘制空白页面和直线
```python
import sys
from PySide6.QtCore import Qt
from PySide6.QtGui import QPixmap
from PySide6.QtWidgets import QApplication,QLabel,QMainWindow

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        # initUI
        self.label = QLabel()
        self.canvas = QPixmap(400,300) # init a canvas
        self.canvas.fill(Qt.GlobalColor.white) # set color

        self.setCentralWidget(self.label)

    def draw_something(self):
        pass


app = QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()


```

```python
import sys
from PySide6.QtCore import Qt
from PySide6.QtGui import QPixmap,QPainter,QPen,QColor
from PySide6.QtWidgets import QApplication,QLabel,QMainWindow

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        
        # initUI
        self.label = QLabel()
        self.canvas = QPixmap(400,300) # init a canvas
        self.canvas.fill(Qt.GlobalColor.white) # set color
        self.label.setPixmap(self.canvas) 
        self.setCentralWidget(self.label)
        self.draw_something()
        
    def draw_something(self):
        painter= QPainter(self.canvas) # pen down
        painter.drawLine(10,10,300,200) 
        # draw line from (10,10) to (300,200)
        painter.end() # pen up
        self.label.setPixmap(self.canvas)

app = QApplication(sys.argv)
window = MainWindow()
window.show()
app.exec()
```

---

###### 绘画方法汇总 
QPainter有大量绘制形状和线条的重载方法。

| Method | Description |
| --- | --- |
| drawLine(line) | 绘制一个QLine实例 |
| drawLine(line) | 绘画一个QlineF实例 |
| drawLine(x1,y1,x2,y2) | 绘制点到点的直线（均为整数） |
| drawLine(p1,p2) | p1,p2均为QPoint类型 |
| drawLine(p1,p1) | p1,p2均为QPointF类型 |


> QPoint 和 QPointF类型的区别为，一个是整型、一个是浮点型）
>

**其他的绘制方法有：**

> **drawArc(弧线) ,drawChord（弦), drawConvexPolygon(凸多边形）, drawEllipse（椭圆）,drawLine, drawPath, drawPie（饼）, drawPoint,drawPolygon(多边形), drawPolyline(交叉线）, drawRect（矩形）, drawRects and drawRoundedRect(圆角矩形）.**
>

---

###### 画点——drawPoint()
设置画笔的大小和颜色

```python
def draw_something(self):
    painter= QPainter(self.canvas) # pen down
    pen = QPen()
    # 设置画笔的大小和颜色
    pen.setWidth(40)
    pen.setColor(QColor('red'))
    painter.setPen(pen)

    painter.drawPoint(200,150)
    painter.end() # pen up
    self.label.setPixmap(self.canvas) # 



```

---

加上一些逻辑控制画图

```python
    def draw_something(self):
        painter = QPainter(self.canvas)
        pen = QPen()
        pen.setWidth(3)
        painter.setPen(pen)
        
        for n in range(10000):
            painter.drawPoint(
                200 + randint(-100,100),
                150 + randint(-100,100) ,
            )
        painter.end()
        self.label.setPixmap(self.canvas)

```

![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711959162397-7d4e3db2-23b6-4728-ad2a-c20f06cf148e.png)

控制笔的颜色

```python
    def draw_something(self):
        colors = [
            "#FFD141",
            "#376F9F",
            "#0D1F2D",
            "#E9EBEF",
            "#EB5160",
        ]
        painter = QPainter(self.canvas)
        pen = QPen()
        pen.setWidth(3)
        painter.setPen(pen)
        
        for n in range(10000):
            pen.setColor(QColor(choice(colors)))
            painter.setPen(pen)
            
            painter.drawPoint(
                200 + randint(-100,100),
                150 + randint(-100,100) ,
            )
        painter.end()
        self.label.setPixmap(self.canvas)
```

![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711959562712-ba14b8fd-545a-47fb-b3f7-ed813fed76da.png)



> ‼️在QPainter上只能有一个处于活动状态的QPen
>

---

###### 画线——drawLine()
一开始我们只是画了一个线，但是没有设置线条的外观，现在我们来做这件事。

```python
import sys
from PySide6.QtCore import Qt,QPoint
from PySide6.QtGui import QPixmap,QPainter,QPen,QColor
from PySide6.QtWidgets import QApplication,QLabel,QMainWindow
from qt_material import apply_stylesheet

from random import choice, randint

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        
        # initUI
        self.label = QLabel()
        self.canvas = QPixmap(640,480) # init a canvas
        self.canvas.fill(Qt.GlobalColor.white) # set color
        self.label.setPixmap(self.canvas)  # 将画布添加到label上
        self.setCentralWidget(self.label) # 设置居中模式
        self.draw_something() 
        
    def draw_something(self):
        painter = QPainter(self.canvas) # 设置canvas为画板
        pen = QPen() # 创建画笔
        pen.setWidth(15) # 设置笔的粗度
        pen.setColor(QColor("blue")) # 设置笔的颜色
        painter.setPen(pen) # 添加画笔到画板上
        
        painter.drawLine(QPoint(100,100),QPoint(300,200)) # 画线
        painter.end() # 结束绘画
        self.label.setPixmap(self.canvas) # 将绘画结果打印到QPixmap上
        
if __name__ == "__main__":
    app = QApplication(sys.argv)
    #apply_stylesheet(app,theme='dark_blue.xml')
    window = MainWindow()
    window.show()
    app.exec()

```

---

###### 画矩形、圆角矩形、椭圆——drawRect,drawRect and drawRoundRect、drawEllipse
> 这些都是画矩形的方法，都是由QPoint和QRect组成
>

```python
 def draw_something(self):
        painter = QPainter(self.canvas) # 设置canvas为画板
        pen = QPen() # 创建画笔
        pen.setWidth(3) # 设置笔的粗度
        pen.setColor(QColor("#EB5160")) # 设置笔的颜色
        painter.setPen(pen) # 添加画笔到画板上
        
        painter.drawRect(50,20,100,100)     
        painter.drawRect(40,40,100,100)  
        painter.drawRect(30,30,100,100)  
        painter.drawRect(20,50,100,100)     
        
        painter.end() # 结束绘画
        self.label.setPixmap(self.canvas) # 将绘画结果打印到QPixmap上
```

![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711963487721-709275d0-7c10-4dfb-bb8f-325eb266eb03.png)

---

![](https://cdn.nlark.com/yuque/0/2024/png/33522184/1711963950336-715fb385-c172-4d64-b02d-3c6d4759cbd3.png)

```python
 def draw_something(self):
        painter = QPainter(self.canvas) # 设置canvas为画板
        
        pen = QPen() # 创建画笔
        pen.setWidth(3) # 设置笔的粗度
        pen.setColor(QColor("#EB5160")) # 设置笔的颜色
        painter.setPen(pen) # 添加画笔到画板上
        
        brush = QBrush() # 创建刷子
        brush.setColor((QColor("#FFD141")))
        brush.setStyle(Qt.BrushStyle.Dense1Pattern) # 设置刷子样式
        
        painter.setPen(pen)
        painter.setBrush(brush) # 添加画笔到画板上
        
        painter.drawRects([
            QtCore.QRect(50,20,100,100),
            QtCore.QRect(40,20,100,100),
            QtCore.QRect(30,20,100,100),
            QtCore.QRect(20,20,100,100)]
        )
        
        painter.end() # 结束绘画
        self.label.setPixmap(self.canvas) # 将绘画结果打印到QPixmap上
```

> 💡 Qt.Brush默认样式为NoBrush，所以必须设置一个才会有显示填充
>

```python
def draw_something(self):
    painter = QPainter(self.canvas)
    pen = QPen()
    pen.setWidth(3)
    pen.setColor(QColor("#376F9F"))
    painter.setPen(pen)
    painter.drawRoundedRect(40, 40, 100, 100, 10, 10)
    painter.drawRoundedRect(80, 80, 100, 100, 10, 50)
    painter.drawRoundedRect(120, 120, 100, 100, 50, 10)
    painter.drawRoundedRect(160, 160, 100, 100, 50, 50)
    painter.end()
    self.label.setPixmap(self.canvas)
```

**绘制椭等等，就不一一详述了，可以参考代码中的提示。**

---

###### 画文本——Text
> 文本绘制工具drawText()
>

```python
    def draw_something(self):
        painter = QPainter(self.canvas)
        # 画笔的大小不会影响字体大小，但是必须定义，不然不能改变字体的颜色三
        pen = QPen()
        pen.setWidth(3) 
        pen.setColor(QColor("green"))
        painter.setPen(pen)

        font = QFont()
        font.setFamily("Times") # 设置字体样式
        font.setBold(True) 
        font.setPointSize(20) # 设置字体大小
        painter.setFont(font)
        
        painter.drawText(100,100,"PySide6哈哈哈")
        painter.end()
        self.label.setPixmap(self.canvas)
```









---

### 2.创建自定义小组件
---

### 3.在QtDesiner中使用自定义小组件
---

## 并发执行(COncurrent Execution)
> **A computer shall not waste your time or require you to do more work than is strictly necessary.**
>
> — Jef Raskin, Second Law of User Interface Design
>

<font style="color:rgb(0, 0, 0);">通过在 QApplication 对象上调用</font>`<font style="color:rgb(0, 0, 0);"> .exec()</font>`<font style="color:rgb(0, 0, 0);"> 启动的事件循环在与 Python 代码相同的线程。运行此事件循环的线程 -通常称为 </font>**<font style="color:rgb(0, 0, 0);">GUI 线程 </font>**<font style="color:rgb(0, 0, 0);">— </font><font style="color:rgb(0, 0, 0);">也处理所有窗口与主机系统的通信</font><font style="color:rgb(0, 0, 0);">。</font>

<font style="color:rgb(0, 0, 0);">默认情况下，事件循环触发的任何执行也将同步运行在这个线程内。实际上，这意味着任何时候您的 PySide6 应用程序花费在代码、窗口通信和 GUI 交互都会被冻结(fronzen)。</font>

<font style="color:rgb(0, 0, 0);">如果您正在做的事情很简单，并且可以</font><font style="color:rgb(0, 0, 0);">快速将控制权返回GUI 循环</font><font style="color:rgb(0, 0, 0);">，那么这用户感觉不到冻结。但是，如果您需要执行更长时间 - 运行任务，例如打开/写入大文件、下载一些数据，或者渲染一些复杂的图像，都会出现问题。致您的用户该应用程序似乎没有响应。因为你的应用程序不再是与操作系统通信时，操作系统会认为它已经崩溃了——在 macOS 上你会看到死亡的旋转之轮，窗户上的窗户将变暗。这不太好看。</font>

<font style="color:rgb(0, 0, 0);">解决方案很简单——</font>**<font style="color:rgb(0, 0, 0);">让您的工作脱离 GUI 线程</font>**<font style="color:rgb(0, 0, 0);">。 PySide6提供了简单的接口可以实现这个。</font>

---

### 1.线程和进程简介
<font style="color:rgb(0, 0, 0);">下面是 PySide6 的最小存根应用程序，它允许我们演示问题并稍后修复它。您可以将其复制并粘贴到</font><font style="color:rgb(0, 0, 0);">新文件，并使用适当的文件名（例如 concurrent.py ）保存它。</font>

```python
import sys
import time

from PySide6.QtCore import QTimer
from PySide6.QtWidgets import (QApplication, QLabel, QMainWindow, QPushButton,
                               QVBoxLayout, QWidget)


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.counter = 0

        layout = QVBoxLayout()

        self.l = QLabel("Start")
        b = QPushButton("DANGER!")
        b.pressed.connect(self.oh_no)

        layout.addWidget(self.l)
        layout.addWidget(b)

        w = QWidget()
        w.setLayout(layout)
        self.setCentralWidget(w)
        self.show()

        self.timer = QTimer()
        self.timer.setInterval(1000)
        self.timer.timeout.connect(self.recurring_timer)
        self.timer.start()

    def oh_no(self):
        """耗时操作"""
        time.sleep(5)

    def recurring_timer(self):
        """循环每秒执行一次"""
        self.counter += 1
        self.l.setText("Counter: %d" % self.counter)


app = QApplication(sys.argv)
window = MainWindow()
app.exec()
```

<font style="color:rgb(0, 0, 0);">你会注意到，每次你按下按钮，计数器停止滴答作响，</font>

<font style="color:rgb(0, 0, 0);">您的应用程序将完全冻结。在Windows上，您可能会看到苍白，表明它没有响应，而在macOS上，您可能会看到旋转死亡之轮。</font>

<font style="color:rgb(0, 0, 0);">看起来像冻结接口的东西实际上是由Qt事件循环引起的，阻止处理（和响应）窗口事件。你点击了窗口仍然由主机操作系统注册并发送到您的应用程序，但因为它在你的代码块</font>`<font style="color:rgb(0, 0, 0);">（time.sleep）</font>`<font style="color:rgb(0, 0, 0);">中，它不能接受或响应他们您的应用程序没有响应，操作系统将其解释为冻结或挂起。</font>

#### <font style="color:rgb(0, 0, 0);">错误的做法</font>
<font style="color:rgb(0, 0, 0);">最简单的做法就是在代码中设置接受事件，这允许Qt继续相应主机操作系统，您的程序将继续保持反应灵敏。即使用</font>`<font style="color:rgb(0, 0, 0);">QApplication</font>`<font style="color:rgb(0, 0, 0);">类，</font>**<font style="color:rgb(0, 0, 0);">在耗时操作前，</font>**<font style="color:rgb(0, 0, 0);">简单的添加一行</font>`<font style="color:rgb(0, 0, 0);">QApplication.processEvents()</font>`

```python
def oh_no(self):
    for n in range(5):
        QApplication.processEvents()
        time.sleep()
```

<font style="color:rgb(0, 0, 0);">这是可行的，但是这是不好的，有几个原因：</font>

+ <font style="color:rgb(0, 0, 0);">首先，当你把控制权交还给Qt时，你的代码就不再运行了。这意味着无论你想做什么长期运行的事情都需要更长的时间。</font>
+ <font style="color:rgb(0, 0, 0);">其次，在主事件循环之外处理事件会导致应用程序到分支处理代码（例如，用于触发的插槽或事件），而在您的循环.如果你的代码依赖于/响应于外部状态，这可能会导致未知错误。</font>

```python
import sys
import time

from PySide6.QtCore import QTimer
from PySide6.QtWidgets import (QApplication, QLabel, QMainWindow, QPushButton,
                               QVBoxLayout, QWidget)


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.counter = 0

        layout = QVBoxLayout()

        self.l = QLabel("Start")
        b = QPushButton("DANGER!")
        b.pressed.connect(self.oh_no)

        c = QPushButton("?")
        c.pressed.connect(self.change_message)

        layout.addWidget(self.l)
        layout.addWidget(b)
        layout.addWidget(c)

        w = QWidget()
        w.setLayout(layout)
        self.setCentralWidget(w)
        self.show()

    def change_message(self):
        self.message = "OH NO"

    def oh_no(self):
        """耗时操作"""
        self.message = "Pressed"

        for _ in range(100):
            time.sleep(0.1)
            self.l.setText(self.message)
            QApplication.processEvents()


app = QApplication(sys.argv)
window = MainWindow()
app.exec()
```

可以看到消息的变化，状态正从循环外部改变。

> ‼️<font style="color:rgb(0, 0, 0);">但是，如果您有多个长时间运行的进程，在您的应用程序中，每个都调用QApplication.processEvents（）来保持,您的应用程序可能很快变得不可预测。</font>
>

---

#### 线程和进程


## 思维导图
> 用思维导图，结构化记录本书的核心观点。
>

![画板](https://cdn.nlark.com/yuque/0/2024/jpeg/33522184/1711436928989-3e49bfd1-70bb-4d22-a6cf-bcb05aec6cd9.jpeg)

## 书摘


## 相关资料
> <font style="color:#8C8C8C;">可通过“⌘+K”插入引用链接，或使用“本地文件”引入源文件。</font>
>



