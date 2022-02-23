---
title: 黑群晖安装QB
date: 2021-06-25 18:29:06
tags: 
- NAS
- 下载
categories: 
- 重剑无锋
---

1. 打开docker， 输入qbittorrent， 找到 linuxserver/qbittorrent
2. 下载
3. 创建qb文件夹，改everyone权限，内建两个新子文件夹，config和downloads
4. docker映像设置中添加卷来映射文件夹
5. 改端口，第三个tcp是webui端口，其他的也要改，默认的6881被大多数站点屏蔽。
6. 配置环境变量
![](http://picbed.yoyolikescici.cn/uPic/20210625185122.png)
7. 下一步。确认，运行。
8. 登录qb界面，默认账户admin，默认密码 adminadmin
9. 修改qb的连接中的监听端口为修改过的端口


意外情况：QB无法打开，提示错误：/usr/bin/qbittorrent-nox: error while loading shared libraries: libQt5Core.so.5: cannot open shared object file: No such file or directory
解决方法：
1. ssh 到 群晖，然后
docker exec -it qbittorrent4.3.3 /bin/sh
qbittorrent4.3.3 是我容器名，参照自已的改

2. apt update
3. apt install binutils
4. strip --remove-section=.note.ABI-tag /usr/lib/x86\_64-linux-gnu/libQt5Core.so.5
5. 重启容器


参考文献：
http://www.360doc.com/content/19/0601/19/27498460_839666036.shtml
https://post.smzdm.com/p/a7do76vd/
https://github.com/linuxserver/docker-qbittorrent/issues/103