---
title: MacOS_VIM+LaTeX
date: 2021-06-12 15:20:06
tags: 
- 计算机学习笔记
- VIM
- 利其器
categories: 
- 重剑无锋
- 环境配置
---

1. 下载MacTex
http://tug.org/mactex/

2. 下载skim
https://sourceforge.net/projects/skim-app/files/latest/download

3. 在VIM中安装插件
```
Plug 'lervag/vimtex'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```
在 Neovim 中执行 `:CocInstall coc-vimtex` 即可。 自动补全
4. 基础配置
```
let g:tex\_flavor = 'latex'
let g:vimtex\_quickfix\_mode = 0


#自动同步
let g:vimtex_view_general_viewer
\ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" This adds a callback hook that updates Skim after compilation
let g:vimtex_compiler_callback_hooks = ['UpdateSkim']

function! UpdateSkim(status)
if !a:status | return | endif

let l:out = b:vimtex.out()
let l:tex = expand('%:p')
let l:cmd = [g:vimtex_view_general_viewer, '-r']

if !empty(system('pgrep Skim'))
call extend(l:cmd, ['-g'])
endif

if has('nvim')
call jobstart(l:cmd + [line('.'), l:out, l:tex])
elseif has('job')
call job_start(l:cmd + [line('.'), l:out, l:tex])
else
call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
endif
endfunction
```

这样配置后，我们就可以通过 vimtex 默认的 `\lv` 快捷键（在按住 `\` 的时候，连续点击 `l` 和 `v`）来正向同步当前 Neovim 光标位置到 PDF 预览位置，也可以通过「`Ctrl` \+ 点击 PDF 预览相应位置」来反向同步 Neovim 光标位置了。

5. 快捷键说明
 -   `\ll`：使用默认编译器（latexmk）开始监听 `.tex` 文件的变化，编译 LaTeX 项目并打开 PDF 预览界面；
-   `\lk` 或第二次 `\ll`：停止编译器监听文件变动，停止编译；
-   `\lv`：正向从 Neovim 光标位置同步 PDF 显示区域；
-   `\lc`：清理编译生成的中间文件；

-   快速跳转至下一个或上一个 section 章节：`[[`、`]]`、`][`、`[]`；
-   删除包含当前内容的环境标签：`dse` (Delete surrounding environment)；
-   更换包含当前内容的环境标签：`cse` (Change surrounding environment)；
-   更换有 `*` 和无 `*` 的环境标签（比如将 `equation*` 更换为 `equation`、将 `figure*` 更换为 `figure` 等）`tse` (Toggle starred environment)：
-   ……


```
中文模板

\\documentclass\[12pt\]{article}

\\usepackage{CJK}

\\usepackage{geometry}

\\geometry{a4paper,left=1cm,right=1cm,top=1cm,bottom=1cm}

\\begin{CJK}{UTF8}{gkai}

%设定新的字体快捷命令

\\title{题目}

\\author{作者}

\\begin{document}

\\maketitle

\\section{小标题}

\\subsection{小小标题}

内容

参考文献~\\cite{lecun2015deep}

\\bibliographystyle{plain}

\\bibliography{refer}

\\end{CJK}

\\end{document}
```


参考文献：
https://sspai.com/post/64080
https://zhuanlan.zhihu.com/p/35498361
https://github.com/limberc/MacTeX-zh-support-template/blob/master/main.tex