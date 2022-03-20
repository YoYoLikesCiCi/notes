# MacBook已锁定应用程序如何卸载


  
之前下载了一个软件，最近发现是被锁定的，而且无法解锁，就无法卸载它。我找了许多方法，都失败了，最后找到以下方法成功删除了软件，给大家分享一下我的经验。

先打开“终端”，输入命令 /bin/ls -dleO@ （记得加个空格），把你要卸载的锁定应用程序直接拖到终端，点回车，出现以下（例）

/bin/ls -dleO@ /[App](https://www.isolves.com/sj/rj/)lications/CrashPlan.app

drwxrwxr-x@ 3 testing admin schg 102 May 29 11:32 /Applications/CrashPlan.app

com.apple.metadata:com_apple_backup_excludeItem 17

如果有“schg”就代表可以进行下一步了  
在终端输入命令 sudo /usr/bin/chflags -R noschg （别忘空格），再把应用程序拖到终端，出现以下（例）

sudo /usr/bin/chflags -R noschg /Applications/CrashPlan.app

Pass[word](https://www.isolves.com/e/tags/?tagname=word): <enter your account's password; it will not echo, but the [mac](https://www.isolves.com/it/rj/czxt/mac/) is seeing it; then press the return key>

这时你就直接输入你的账户的管理员密码，终端不显示字符，但其实已经读取了，输好密码后直接点回车就解锁了，接着就可以卸载了。



参考文献:
https://m.isolves.com/it/rj/czxt/mac/2021-09-14/44054.html