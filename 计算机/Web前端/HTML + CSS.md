## head
### 可在头部 插入的元素标签：
title,
style, 
meta,
link, 
script(用于加载脚本文件，比如js),
noscript,
base(基本的链接地址)
#### <meta>
<meta name="keywords"  content="HTML,CSS,XML,XHTML, JavaScript">
<meta name="author" content="Sq">
<meta http-equiv="refresh" content="30">

## CSS
1. 内联样式 
  ```
  <p style="color:blue;margin-left:20px;">这是一个段落。</p>
  ```
  
2. 内部样式 ： 单个文件需要特别的样式时
  ```
  <style type="text/css">
  body {background-color:yellow;}
  p {color:blue;}
  </style>
  ```
  
3. 外部样式表 ： 样式需要被应用到很多页面的时候。
```html
<link rel="stylesheet" type="text/css" href="mystyle.css">
```


