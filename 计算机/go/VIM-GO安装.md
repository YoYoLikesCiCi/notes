---
title: VimGo 安装
date: 2022年1月5日 18:35:38
tags: 
- 环境安装
- VIM
- GO
categories: 
- 重剑无锋
- 环境配置
---

由于众所周知的原因, “go get” & ":GoInstallBinaries" 无法正常使用,经过多方查询.找到当下能用的方法


1. set proxy
- 通过 `export GO111MODULE=on` 开启 MODULE
- export GOPROXY=https://goproxy.io
七牛也出了个国内代理 [goproxy.cn](https://github.com/goproxy/goproxy.cn) 方便国内用户更快的访问不能访问的包

2. 在VIM下运行 GoInstallBinaries

3. 弹出来的错误列表中挨个复制,并使用 go install 安装.


参考资料: 
https://shockerli.net/post/go-get-golang-org-x-solution/