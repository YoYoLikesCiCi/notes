# Markdown目录树、锚（anchor）和页内跳转_七宗劫的专栏-CSDN博客

[https://blog.csdn.net/tearsky253/article/details/78968221](https://blog.csdn.net/tearsky253/article/details/78968221)

# 前言

在使用Markdown写文档时，如果文档内容很多，我们很可能需要给文档生成目录树和使用页内跳转。本文提供了实现这些功能的方法，并且已经在有道云笔记中测试通过。

# Markdown目录树

想要给文档生成目录树，只需要在文档中增加`[TOC]`，目录树就会根据文档中的h1~h6标题自动生成了。

> 注：[TOC]需要独占一行才能生效。比如：  ……  [TOC]  ……
> 

# 页内跳转链接

Markdown会自动给每一个h1~h6标题生成一个锚，其id就是标题内容。目录树中的每一项都是一个跳转链接，点击后就会跳转到其对应的锚点（即标题所在位置）。你可以点击本文档开始处的目录树尝试一下。

如果需要在目录树之外还要增加跳转到某个标题的链接，则有两种办法可以做到： 
 1. 使用Markdown的语法来增加跳转链接：“[名称](#id)”。 
 2. 使用HTML语法来增加跳转链接：“<a href=”#id”>名称

其中的“名称”可以随便填写，“id”需要填写跳转到的标题的内容。例如如果想要增加一个到本文档“前言”标题的跳转链接，则需要这么写：

[使用Markdown语法增加的跳转到“前言”的链接](#前言) 
 效果： [使用Markdown语法增加的跳转到“前言”的链接](https://blog.csdn.net/tearsky253/article/details/78968221)

或者这么写：

<a href=”#前言”>使用HTML语法增加的跳转到“前言”的链接 效果： [使用HTML语法增加的跳转到“前言”的链接](https://blog.csdn.net/tearsky253/article/details/78968221)

# 自定义锚

假设我们想跳转到文档中的一个不是标题的位置（比如一张图表），则需要在该位置自定义一个锚。

我们使用HTML语法来定义一个锚。可选的HTML标签很多，比如<span>、<a>等等。本文使用<span>示例。

假设文档中有一个作息时间表，在文档的其他地方需要增加跳转到此表位置的链接，那么我们可以在此表的附近增加一行：

<span id=”表1”>名称

> 注：id为必填项；“名称”可以随便填写，也可以不填。另外，可以给span增加其他属性，比如颜色等等。
> 

效果： 
 作息时间表

然后可以在文档其他位置增加一个跳转到它的链接了：