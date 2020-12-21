鸟哥的Linux

# 第一二章 计算机概论

|           | RPM 软件管理                               | DPKG 软件管理             | 其他未 分类 |
| --------- | ------------------------------------------ | ------------------------- | ----------- |
| 商业公 司 | RHEL （Red Hat 公司） SuSE （Micro Focus） | Ubuntu （Canonical Ltd.） |             |
| 社群单 位 | Fedora CentOS OpenSuSE                     | Debian B2D                | Gentoo      |



# 第三章 主机规划于磁盘分区

## 1. 各硬件设备在linux中的文件名

在Linux系统中，每个设备都被当成一个文件来对待

举例来说， SATA接口的硬盘的文件名称即为/dev/sd[a-d]，其中， 括号内的字母为a-d当中的任意一个， 亦即有/dev/sda, /dev/sdb, /dev/sdc, 及 /dev/sdd这四个文件的意思。

 

| 设备                 | 设备在Linux内的文件名                                        |
| -------------------- | ------------------------------------------------------------ |
| SCSI/SATA/USB硬 盘机 | /dev/sd[a-p]                                                 |
| USB闪存盘            | /dev/sd[a-p] （与SATA相同）                                  |
| VirtI/O界面          | /dev/vd[a-p] （用于虚拟机内）                                |
| 软盘机               | /dev/fd[0-7]                                                 |
| 打印机               | /dev/lp[0-2] （25针打印机） /dev/usb/lp[0-15] （USB 接口）   |
| 鼠标                 | /dev/input/mouse[0-15] （通用） /dev/psaux （PS/2界面） /dev/mouse  （当前鼠标） |
| CDROM/DVDROM         | /dev/scd[0-1] （通用） /dev/sr[0-1] （通用，CentOS 较常见） /dev/cdrom （当前  CDROM） |
| 磁带机               | /dev/ht0 （IDE 界面） /dev/st0 （SATA/SCSI界面） /dev/tape （当前磁带） |
| IDE硬盘机            | /dev/hd[a-d] （旧式系统才有）                                |



## 2. 磁盘分区-mbr&gpt

![image-20200514003823423](http://picbed.yoyolikescici.cn/uPic/image-20200514003823423.png)



###  MBR（Master Boot Record）

早期的 Linux 系统为了相容于 Windows 的磁盘，因此使用的是支持 Windows 的 MBR（Master Boot Record, 主要开机纪录区） 的方式来处理开机管理程序与分区表！而开 机管理程序纪录区与分区表则通通放在磁盘的第一个扇区， 这个扇区通常是 512Bytes 的大 小 （旧的磁盘扇区都是 512Bytes 喔！），所以说，第一个扇区 512Bytes 会有这两个数据： 

- 主要开机记录区（Master Boot Record, MBR）：可以安装开机管理程序的地方，有446 Byte
- 分区表（partition table）：记录整颗硬盘分区的状态，有64 Bytes

由于分区表所在区块仅有64 Bytes容量，因此最多仅能有四组记录区，每组记录区记录了该区 段的启始与结束的柱面号码。

![image-20200514004707958](http://picbed.yoyolikescici.cn/uPic/image-20200514004707958.png)





由于分区表就只有64 Bytes而已，最多只能容纳四笔分区的记录， 这四个分区的记录被称为主要（Primary）或延伸（Extended）分 区。

MBR 主要分区、延伸分区与逻辑分区的特性我们作个简单的定义啰：

 

主要分区与延伸分区最多可以有四笔（硬盘的限制） 延伸分区最多只能有一个（操作系统的限制）

逻辑分区是由延伸分区持续切割出来的分区；

能够被格式化后，作为数据存取的分区为主要分区与逻辑分区。延伸分区无法格式化；

逻辑分区的数量依操作系统而不同，在Linux系统中SATA硬盘已经可以突破63个以上的分区限制；

#### 延伸分区

![image-20200514005226702](http://picbed.yoyolikescici.cn/uPic/image-20200514005226702.png)

![image-20200514011030714](http://picbed.yoyolikescici.cn/uPic/image-20200514011030714.png)



#### 开机流程不主要启劢记录区(MBR)

在计算器概论里面我们有谈到那个可爱癿 BIOS 不 CMOS 两个东西， CMOS 是记录各项硬件参数丏嵌 入在主板上面癿储存器，BIOS 则是一个写入到主板上癿一个韧体(再次说明， 韧体就是写入到硬件上 癿一个软件程序)。这个 BIOS 就是在开机癿时候，计算机系统会主劢执行癿第一个程序了！

1. BIOS：开机主劢执行癿韧体，会讣识第一个可开机癿装置；
2. MBR：第一个可开机装置癿第一个扂区内癿主要启劢记录区块，内吨开机管理程序；
3. 开机管理程序(boot loader)：一支可读叏核心档案来执行癿软件；
4. 核心档案：开始操作系统癿功能...



这个 boot loader 癿主要仸务有底下这些项目：

- 提供选单：用户可以选择丌同癿开机项目，这也是多重引导癿重要功能！ 
- 载入核心档案：直接挃向可开机癿程序区段来开始操作系统； 
- 转交其他 loader：将开机管理功能转交给其他 loader 负责。





### GPT（GUID partition table）

因为过去一个扇区大小就是 512Bytes 而已，不过目前已经有 4K 的扇区设计出现！为了相容于所有的磁盘，因此在扇区的定义上面， 大多会使用所谓的逻辑区块位址（Logical Block Address, LBA）来处理。GPT 将磁盘所有区块以此 LBA（默认为 512Bytes 喔！） 来规划， 而第一个 LBA 称为 LBA0 （从 0 开始编号）。



与 MBR 仅使用第一个 512Bytes 区块来纪录不同， GPT 使用了 34 个 LBA 区块来纪录分区信息！同时与过去 MBR 仅有一的区块，被 干掉就死光光的情况不同， GPT 除了前面 34 个 LBA 之外，整个磁盘的最后 33 个 LBA 也拿来作为另一个备份！这样或许会比较安全些吧！ 详细的结构有点像下面的模样：

![image-20200514012313432](http://picbed.yoyolikescici.cn/uPic/image-20200514012313432.png)



- LBA0 （MBR 相容区块）

    与 MBR 模式相似的，这个相容区块也分为两个部份，一个就是跟之前 446 Bytes 相似的区块，储存了第一阶段的开机管理程序！ 而在原本的分区表的纪录区内，这个相容模式仅放入一个特殊标志的分区，用来表示此磁盘为 GPT 格式之意。而不懂 GPT 分区表的磁 盘管理程序， 就不会认识这颗磁盘，除非用户有特别要求要处理这颗磁盘，否则该管理软件不能修改此分区信息，进一步保护了此磁盘 喔！

- LBA1 （GPT 表头纪录）

    这个部份纪录了分区表本身的位置与大小，同时纪录了备份用的 GPT 分区 （就是前面谈到的在最后 34 个 LBA 区块） 放置的位 置， 同时放置了分区表的检验机制码 （CRC32），操作系统可以根据这个检验码来判断 GPT 是否正确。若有错误，还可以通过这个纪 录区来取得备份的 GPT（磁盘最后的那个备份区块） 来恢复 GPT 的正常运行！

- LBA2-33 （实际纪录分区信息处）

    从 LBA2 区块开始，每个 LBA 都可以纪录 4 笔分区纪录，所以在默认的情况下，总共可以有 4*32 = 128 笔分区纪录喔！因为每 个 LBA 有 512Bytes，因此每笔纪录用到 128 Bytes 的空间，除了每笔纪录所需要的识别码与相关的纪录之外，GPT 在每笔纪录中分别 提供了 64bits 来记载开始/结束的扇区号码，因此，GPT 分区表对於单一分区来说， 他的最大容量限制就会在“ 2 64 * 512Bytes = 2 63 * 1KBytes = 2 33 *TB = 8 ZB ”，要注意 1ZB = 2 30 TB 啦！ 你说有没有够大了？



### UEFI BIOS 搭配 GPT 开机的流程

| 比较项目               | 传统 BIOS                                                    | UEFI               |
| ---------------------- | ------------------------------------------------------------ | ------------------ |
| 使用程序语言           | 组合语言                                                     | C 语言             |
| 硬件资源控制           | 使用中断 （IRQ） 管理 不可变的内存存取 不可变得输入/输出存取 | 使用驱动程序与协定 |
| 处理器运行环境         | 16 位                                                        | CPU 保护模式       |
| 扩充方式               | 通过 IRQ 链接                                                | 直接载入驱动程序   |
| 第三方厂商支持         | 较差                                                         | 较佳且可支持多平台 |
| 图形化能力             | 较差                                                         | 较佳               |
| 内置简化操作系统前环境 | 不支持                                                       | 支持               |



# 第四章 首次登录与线上求助

## 1. 首次登录系统

### 启动xwindow： `startx`

### 重新启动xwindows：ctrl+alt+backspace

### 切换tty： ctrl + alt + f2～f6

## 2. 下达指令

`command  [-option]  parameter1  parameter2  ...`

- 语系的支持：`locale`



### 基础指令的操作

- date
- cal
- bc（简易计算器）

## 3. man page & info page

#### man page

![image-20200516163749352](http://picbed.yoyolikescici.cn/uPic/image-20200516163749352.png)

![image-20200516164923569](http://picbed.yoyolikescici.cn/uPic/image-20200516164923569.png)

| 按键        | 进行工作                                                     |
| ----------- | ------------------------------------------------------------ |
| 空白键      | 向下翻一页                                                   |
| [Page Down] | 向下翻一页                                                   |
| [Page Up]   | 向上翻一页                                                   |
| [Home]      | 去到第一页                                                   |
| [End]       | 去到最后一页                                                 |
| /string     | 向“下”搜寻 string 这个字串，如果要搜寻 vbird 的话，就输入 /vbird |
| ?string     | 向“上”搜寻 string 这个字串                                   |
| n, N        | 利用 / 或 ? 来搜寻字串时，可以用 n 来继续下一个搜寻 （不论是 / 或 ?） ，可以利用 N 来进行“反向”搜寻。举例来说，我 以 /vbird 搜寻 vbird 字串， 那么可以 n 继续往下查询，用 N 往上查询。若以 ?vbird 向上查询 vbird 字串， 那我可以用 n 继续“向上”查询，用 N 反向查询。 |
| q           | 结束这次的 man page                                          |



#### info page



## 4. 超简单文本编辑器：nano

![image-20200516165340944](http://picbed.yoyolikescici.cn/uPic/image-20200516165340944.png)

![image-20200516165320731](http://picbed.yoyolikescici.cn/uPic/image-20200516165320731.png)

## 5. 关机

- 将数据同步写入硬盘中的指令： sync 
- 惯用的关机指令： shutdown 
- 重新开机，关机： reboot, halt, poweroff，  init 0

![image-20200516165623183](http://picbed.yoyolikescici.cn/uPic/image-20200516165623183.png)





# 第五章 Linux的文件权限与目录配置

## 1. 使用者与群组

- 文件拥有者
- 群组
- others



## 2. 文件权限

![image-20200516171253726](http://picbed.yoyolikescici.cn/uPic/image-20200516171253726.png)

#### 1.第一栏代表这个文件的类型与权限（permission）：

- 第一个字符代表这个文件是“目录、文件或链接文件等等”：
    - 当为[ d ]则是目录，例如上表文件名为“.config”的那一行；
    - 当为[ - ]则是文件，例如上表文件名为“initial-setup-ks.cfg”那一行；
    - 若是[ l ]则表示为链接文件（link file）；
    - 若是[ b ]则表示为设备文件里面的可供储存的周边设备（可随机存取设备）；
    - 若是[ c ]则表示为设备文件里面的序列埠设备，例如键盘、鼠标（一次性读取设 备）。
-  接下来的字符中，以三个为一组，且均为“rwx” 的三个参数的组合。其中，[ r ]代表可读 （read）、[ w ]代表可写（write）、[ x ]代表可执行（execute）。 要注意的是，这三个 权限的位置不会改变，如果没有权限，就会出现减号[ - ]而已。
- 第一组为“文件拥有者可具备的权限”，以“initial-setup-ks.cfg”那个文件为例， 该文件 的拥有者可以读写，但不可执行； 第二组为“加入此群组之帐号的权限”； 第三组为“非本人且没有加入本群组之其他帐号的权限”。



2. 第二栏表示有多少文件名链接到此节点（i-node）：

3. 第三栏表示这个文件（或目录）的 “拥有者帐号 ”

4. 第四栏表示这个文件的所属群组

5. 第五栏为这个文件的容量大小，默认单位为Bytes；

6. 第六栏为这个文件的创建日期或者是最近的修改日期：

7. 第七栏为这个文件的文件名



### 3. 改变文件属性和权限



#### chgrp ：改变文件所属群组

[root@study ~]# chgrp users initial-setup-ks.cfg

#### chown ：改变文件拥有者

chown bin initial-setup-ks.cfg

#### chmod ：改变文件的权限, SUID, SGID, SBIT

- 数字类型改变文件权限

    r:4 w:2 x:1

    chmod 754 filename”

- 符号类型改变文件权限

    chmod u=rwx,go=rx .bashrc

    

### 目录与文件之权限意义

- 至于最后一个w这个权限呢？当你对一个文件具有w权限时，你可以具有写入/编辑/新增/修改文件的内容的权限， 但并不具备有删除该 文件本身的权限！对于文件的rwx来说， 主要都是针对“文件的内容”而言，与文件文件名的存在与否没有关系喔！因为文件记录的是实际的数据 嘛！

- 目录的x代表的是使用者能 否进入该目录成为工作目录的用途！ 所谓的工作目录（work directory）就是你目前所在的目录啦！举例来说，当你登陆Linux时， 你所在 的主文件夹就是你当下的工作目录。而变换目录的指令是“cd”（change directory）啰！

    

| 元件 | 内容         | 叠代物件   | r            | w            | x                       |
| ---- | ------------ | ---------- | ------------ | ------------ | ----------------------- |
| 文件 | 详细数据data | 文件数据夹 | 读到文件内容 | 修改文件内容 | 执行文件内容            |
| 目录 | 文件名       | 可分类抽屉 | 读到文件名   | 修改文件名   | 进入该目录的权限（key） |



### 4. linux文件种类和扩展名

- 正规文件（regular file）
    - 纯文本文件（ASCII）
    - 二进制档（binary）
    - 数据格式文件（data）
- 目录（directory）
- 链接文件（link），类似于windows 快捷方式
- 数据接口文件（sockets）
- 数据输送档（FIFO，pipe）





## 3. Linux 目录配置

### 1. FHS-Filesystem Hierarchy Standard

|                      | 可分享的（shareable）        | 不可分享的（unshareable） |
| -------------------- | ---------------------------- | ------------------------- |
| 不变的（static）     | /usr （软件放置处）          | /etc （配置文件）         |
|                      | /opt （第三方协力软件）      | /boot （开机与核心档）    |
| 可变动的（variable） | /var/mail （使用者邮件信箱） | /var/run （程序相关）     |
|                      | /var/spool/news （新闻群组） | /var/lock （程序相关）    |



- / （root, 根目录）：与开机系统有关；
- /usr （unix software resource）：与软件安装/执行有关；
- /var （variable）：与系统运行过程有关。

#### 1. /

| 目录 | 应放置文件内容                                               |
| ---- | ------------------------------------------------------------ |
|      | 第一部份：FHS 要求必须要存在的目录                           |
| /bin | 系统有很多放置可执行文件的目录，但/bin比较特殊。因为/bin放置的是在单人维护模式下还能够被操作的指令。 在/bin下面 的指令可以被root与一般帐号所使用，主要有：cat, chmod, chown, date, mv, mkdir, cp, bash等等常用的指令。 |
| /boot                            | 这个目录主要在放置开机会使用到的文件，包括Linux核心文件以及开机菜单与开机所需配置文件等等。 Linux kernel常用的 文件名为：vmlinuz，如果使用的是grub2这个开机管理程序， 则还会存在/boot/grub2/这个目录喔！ |
| /dev                             | 在Linux系统上，任何设备与周边设备都是以文件的型态存在于这个目录当中的。 你只要通过存取这个目录下面的某个文 件，就等于存取某个设备啰～ 比要重要的文件有/dev/null, /dev/zero, /dev/tty, /dev/loop*, /dev/sd*等等 |
| /etc                             | 系统主要的配置文件几乎都放置在这个目录内，例如人员的帐号密码档、 各种服务的启始档等等。一般来说，这个目录下 的各文件属性是可以让一般使用者查阅的， 但是只有root有权力修改。FHS建议不要放置可可执行文件（binary）在这个目 录中喔。比较重要的文件有： /etc/modprobe.d/, /etc/passwd, /etc/fstab, /etc/issue 等等。另外 FHS 还规范几个重要的目录 最好要存在 /etc/ 目录下喔：/etc/opt（必要）：这个目录在放置第三方协力软件 /opt 的相关配置文件 /etc/X11/（建议）：与 X Window 有关的各种配置文件都在这里，尤其是 xorg.conf 这个 X Server 的配置文件。 /etc/sgml/（建议）：与 SGML 格式有关的各项配置文件/etc/xml/（建议）：与 XML 格式有关的各项配置文件 |
| /lib                             | 系统的函数库非常的多，而/lib放置的则是在开机时会用到的函数库， 以及在/bin或/sbin下面的指令会调用的函数库而已。 什么是函数库呢？你可以将他想成是“外挂”，某些指令必须要有这些“外挂”才能够顺利完成程序的执行之意。 另外 FSH 还要 求下面的目录必须要存在：/lib/modules/：这个目录主要放置可抽换式的核心相关模块（驱动程序）喔！ |
| /media                           | media是“媒体”的英文，顾名思义，这个/media下面放置的就是可移除的设备啦！ 包括软盘、光盘、DVD等等设备都暂时挂 载于此。常见的文件名有：/media/floppy, /media/cdrom等等。 |
| /mnt                             | 如果你想要暂时挂载某些额外的设备，一般建议你可以放置到这个目录中。 在古早时候，这个目录的用途与/media相同 啦！只是有了/media之后，这个目录就用来暂时挂载用了。 |
| /opt                             | 这个是给第三方协力软件放置的目录。什么是第三方协力软件啊？ 举例来说，KDE这个桌面管理系统是一个独立的计划， 不过他可以安装到Linux系统中，因此KDE的软件就建议放置到此目录下了。 另外，如果你想要自行安装额外的软件（非原 本的distribution提供的），那么也能够将你的软件安装到这里来。 不过，以前的Linux系统中，我们还是习惯放置 在/usr/local目录下呢！ |
| /run                             | 早期的 FHS 规定系统开机后所产生的各项信息应该要放置到 /var/run 目录下，新版的 FHS 则规范到 /run 下面。 由于 /run 可 以使用内存来仿真，因此性能上会好很多！ |
| /sbin                            | Linux有非常多指令是用来设置系统环境的，这些指令只有root才能够利用来“设置”系统，其他使用者最多只能用来“查询”而 已。 放在/sbin下面的为开机过程中所需要的，里面包括了开机、修复、还原系统所需要的指令。 至于某些服务器软件程 序，一般则放置到/usr/sbin/当中。至于本机自行安装的软件所产生的系统可执行文件（system binary）， 则放置 到/usr/local/sbin/当中了。常见的指令包括：fdisk, fsck, ifconfig, mkfs等等。 |
| /srv                             | srv可以视为“service”的缩写，是一些网络服务启动之后，这些服务所需要取用的数据目录。 常见的服务例如WWW, FTP等 等。举例来说，WWW服务器需要的网页数据就可以放置在/srv/www/里面。 不过，系统的服务数据如果尚未要提供给网际 网络任何人浏览的话，默认还是建议放置到 /var/lib 下面即可。 |
| /tmp                             | 这是让一般使用者或者是正在执行的程序暂时放置文件的地方。 这个目录是任何人都能够存取的，所以你需要定期的清理 一下。当然，重要数据不可放置在此目录啊！ 因为FHS甚至建议在开机时，应该要将/tmp下的数据都删除唷！ |
| /usr                             | 第二层 FHS 设置，后续介绍                                    |
| /var                             | 第二曾 FHS 设置，主要为放置变动性的数据，后续介绍            |
|  | 第二部份：FHS 建议可以存在的目录 |
| /home                            | 这是系统默认的使用者主文件夹（home directory）。在你新增一个一般使用者帐号时， 默认的使用者主文件夹都会规范到 这里来。比较重要的是，主文件夹有两种代号喔：~：代表目前这个使用者的主文件夹 ~dmtsai ：则代表 dmtsai 的主文件夹！ |
| /lib<qual>                       | 用来存放与 /lib 不同的格式的二进制函数库，例如支持 64 位的 /lib64 函数库等 |
| /root                            | 系统管理员（root）的主文件夹。之所以放在这里，是因为如果进入单人维护模式而仅挂载根目录时， 该目录就能够拥有 root的主文件夹，所以我们会希望root的主文件夹与根目录放置在同一个分区中。 |



| 目录        | 应放置文件内容                                               |
| ----------- | ------------------------------------------------------------ |
| /lost+found | 这个目录是使用标准的ext2/ext3/ext4文件系统格式才会产生的一个目录，目的在于当文件系统发生错误时， 将一些遗失的 片段放置到这个目录下。不过如果使用的是 xfs 文件系统的话，就不会存在这个目录了！ |
| /proc | 这个目录本身是一个“虚拟文件系统（virtual filesystem）”喔！他放置的数据都是在内存当中， 例如系统核心、行程信息 （process）、周边设备的状态及网络状态等等。因为这个目录下的数据都是在内存当中， 所以本身不占任何硬盘空间啊！ 比较重要的文件例如：/proc/cpuinfo, /proc/dma, /proc/interrupts, /proc/ioports, /proc/net/* 等等。 |
| /sys  | 这个目录其实跟/proc非常类似，也是一个虚拟的文件系统，主要也是记录核心与系统硬件信息较相关的信息。 包括目前已 载入的核心模块与核心侦测到的硬件设备信息等等。这个目录同样不占硬盘容量喔！ |



#### 2. /usr

很多读者都会误会/usr为user的缩写，其实usr是Unix Software Resource的缩写， 也就是“Unix操作系统软件资源”所放置的目录，而不是 使用者的数据啦！这点要注意。 FHS建议所有软件开发者，应该将他们的数据合理的分别放置到这个目录下的次目录，而不要自行创建该软件 自己独立的目录。

| 目录            | 应放置文件内容                                               |
| --------------- | ------------------------------------------------------------ |
|                 | 第一部份：FHS 要求必须要存在的目录                           |
| /usr/bin/       | 所有一般用户能够使用的指令都放在这里！目前新的 CentOS 7 已经将全部的使用者指令放置于此，而使用链接文件的方 式将 /bin 链接至此！ 也就是说， /usr/bin 与 /bin 是一模一样了！另外，FHS 要求在此目录下不应该有子目录！ |
| /usr/lib/       | 基本上，与 /lib 功能相同，所以 /lib 就是链接到此目录中的！   |
| /usr/local/     | 系统管理员在本机自行安装自己下载的软件（非distribution默认提供者），建议安装到此目录， 这样会比较便于管理。举 例来说，你的distribution提供的软件较旧，你想安装较新的软件但又不想移除旧版， 此时你可以将新版软件安装 于/usr/local/目录下，可与原先的旧版软件有分别啦！ 你可以自行到/usr/local去看看，该目录下也是具有bin, etc, include, lib...的次目录喔！ |
| /usr/sbin/      | 非系统正常运行所需要的系统指令。最常见的就是某些网络服务器软件的服务指令（daemon）啰！不过基本功能与 /sbin 也差不多， 因此目前 /sbin 就是链接到此目录中的。 |
| /usr/share/     | 主要放置只读架构的数据文件，当然也包括共享文件。在这个目录下放置的数据几乎是不分硬件架构均可读取的数据， 因为几乎都是文字文件嘛！在此目录下常见的还有这些次目录：/usr/share/man：线上说明文档 /usr/share/doc：软件杂项的文件说明 /usr/share/zoneinfo：与时区有关的时区文件 |
|                 | 第二部份：FHS 建议可以存在的目录                             |
| /usr/games/     | 与游戏比较相关的数据放置处                                   |
| /usr/include/   | c/c++等程序语言的文件开始（header）与包含档（include）放置处，当我们以tarball方式 （*.tar.gz 的方式安装软件）安装某些数据时，会使用到里头的许多包含档喔！ |
| /usr/libexec/   | 某些不被一般使用者惯用的可执行文件或脚本（script）等等，都会放置在此目录中。例如大部分的 X 窗口下面的操作指 令， 很多都是放在此目录下的。 |
| /usr/lib<qual>/ | 与 /lib<qual>/功能相同，因此目前 /lib<qual> 就是链接到此目录中 |
| /usr/src/       | 一般源代码建议放置到这里，src有source的意思。至于核心源代码则建议放置到/usr/src/linux/目录下。 |



#### 3. /var

如果/usr是安装时会占用较大硬盘容量的目录，那么/var就是在系统运行后才会渐渐占用硬盘容量的目录。 因为/var目录主要针对常态性 变动的文件，包括高速缓存（cache）、登录文件（log file）以及某些软件运行所产生的文件， 包括程序文件（lock file, run file），或者例如 MySQL数据库的文件等等。常见的次目录有：

|             | 第一部份：FHS 要求必须要存在的目录                           |
| ----------- | ------------------------------------------------------------ |
| /var/cache/ | 应用程序本身运行过程中会产生的一些暂存盘；                   |
| /var/lib/   | 程序本身执行的过程中，需要使用到的数据文件放置的目录。在此目录下各自的软件应该要有各自的目录。 举例来 说，MySQL的数据库放置到/var/lib/mysql/而rpm的数据库则放到/var/lib/rpm去！ |
| /var/lock/  | 某些设备或者是文件资源一次只能被一个应用程序所使用，如果同时有两个程序使用该设备时， 就可能产生一些错误的状 况，因此就得要将该设备上锁（lock），以确保该设备只会给单一软件所使用。 举例来说，烧录机正在烧录一块光盘，你想 一下，会不会有两个人同时在使用一个烧录机烧片？ 如果两个人同时烧录，那片子写入的是谁的数据？所以当第一个人在 烧录时该烧录机就会被上锁， 第二个人就得要该设备被解除锁定（就是前一个人用完了）才能够继续使用啰。目前此目录 也已经挪到 /run/lock 中！ |
| /var/log/   | 重要到不行！这是登录文件放置的目录！里面比较重要的文件如/var/log/messages, /var/log/wtmp（记录登陆者的信息） 等。 |
| /var/mail/  | 放置个人电子邮件信箱的目录，不过这个目录也被放置到/var/spool/mail/目录中！ 通常这两个目录是互为链接文件啦！ |
| /var/run/   | 某些程序或者是服务启动后，会将他们的PID放置在这个目录下喔！至于PID的意义我们会在后续章节提到的。 与 /run 相 同，这个目录链接到 /run 去了！ |
| /var/spool/ | 这个目录通常放置一些伫列数据，所谓的“伫列”就是排队等待其他程序使用的数据啦！ 这些数据被使用后通常都会被删除。 举例来说，系统收到新信会放置到/var/spool/mail/中， 但使用者收下该信件后该封信原则上就会被删除。信件如果暂时寄不 出去会被放到/var/spool/mqueue/中， 等到被送出后就被删除。如果是工作调度数据（crontab），就会被放置 到/var/spool/cron/目录中！ |





### 2. directory tree

`ls -l /`

![image-20200516193522693](http://picbed.yoyolikescici.cn/uPic/image-20200516193522693.png)



### 3.  abusolute and relative

例题：

网络文件常常提到类似“./run.sh”之类的数据，这个指令的意义为何？

答：

由于指令的执行需要变量（bash章节才会提到）的支持，若你的可执行文件放置在本目录，并且本目录并非正规的可执行文件 目录（/bin, /usr/bin等为正规），此时要执行指令就得要严格指定该可执行文件。“./”代表“本目录”的意思，所以“./run.sh”代表“执 行本目录下， 名为run.sh的文件”啰！



### 4. CentOS 的观察

`uname -r`

Kenral varsion

`uname -m`

OS version

`lsb_release -a`

必须先安装 `yum install redhat-lsb`





# 第六章 Linux文件与目录管理

## 1. 目录与路径

![image-20200516195021196](http://picbed.yoyolikescici.cn/uPic/image-20200516195021196.png)

- cd：变换目录 

- pwd：显示目前的目录 

    ![image-20200516195741477](http://picbed.yoyolikescici.cn/uPic/image-20200516195741477.png)

- mkdir：创建一个新的目录 

    ![image-20200516210654298](http://picbed.yoyolikescici.cn/uPic/image-20200516210654298.png)

- rmdir：删除一个空的目录



### 环境变量

echo $PATH

![image-20200516214103014](http://picbed.yoyolikescici.cn/uPic/image-20200516214103014.png)





## 2. 文件和目录管理

### 1. ls

![image-20200516214755198](http://picbed.yoyolikescici.cn/uPic/image-20200516214755198.png)



### 2. cp

![image-20200516220150489](http://picbed.yoyolikescici.cn/uPic/image-20200516220150489.png)



### 3. rm

![image-20200516220754768](http://picbed.yoyolikescici.cn/uPic/image-20200516220754768.png)



### 4.mv

![image-20200516220822246](http://picbed.yoyolikescici.cn/uPic/image-20200516220822246.png)

### 5. basename   、    dirname



## 3. 文件内容查询

![image-20200516221003164](http://picbed.yoyolikescici.cn/uPic/image-20200516221003164.png)

### 1. cat

![image-20200516221040740](http://picbed.yoyolikescici.cn/uPic/image-20200516221040740.png)



### 2. tac

### 3. nl （添加行号打印）

![image-20200517131705002](http://picbed.yoyolikescici.cn/uPic/image-20200517131705002.png)



### 4. more

![image-20200517131908334](http://picbed.yoyolikescici.cn/uPic/image-20200517131908334.png)

![image-20200517131929450](http://picbed.yoyolikescici.cn/uPic/image-20200517131929450.png)

### 5. less

less 的用法比起 more 又更加的有弹性，怎么说呢？在 more 的时候，我们并没有办法向前面翻， 只能往后面看，但若使用了 less 时， 呵呵！就可以使用 [pageup] [pagedown] 等按键的功能来往前往后翻看文件，你瞧，是不是更容易使用来观看一个文件的内容了呢！

除此之外，在 less 里头可以拥有更多的“搜寻”功能喔！不止可以向下搜寻，也可以向上搜寻～ 实在是很不错用～基本上，可以输入的指令有：

![image-20200517132301640](http://picbed.yoyolikescici.cn/uPic/image-20200517132301640.png)

### 6. head

读取前面几行

![image-20200517132400822](http://picbed.yoyolikescici.cn/uPic/image-20200517132400822.png)



### 7. tail

![image-20200517132424627](http://picbed.yoyolikescici.cn/uPic/image-20200517132424627.png)



### 8. od （读非纯文本文件）

![image-20200517134249213](http://picbed.yoyolikescici.cn/uPic/image-20200517134249213.png)





### 9. Touch (修改文件时间或者创建新文件)

![image-20200517134542097](http://picbed.yoyolikescici.cn/uPic/image-20200517134542097.png)

![image-20200517140442741](http://picbed.yoyolikescici.cn/uPic/image-20200517140442741.png)

![image-20200517140634777](http://picbed.yoyolikescici.cn/uPic/image-20200517140634777.png)

![image-20200517140729884](http://picbed.yoyolikescici.cn/uPic/image-20200517140729884.png)



## 4. 隐藏权限

### 1. 文件默认权限  umask

要注意的是，umask 的分数指的是“该默认值需要减掉的权限！”因为 r、w、x 分别是 4、2、1 分，所以啰！也就是说，当要拿掉能写的 权限，就是输入 2 分，而如果要拿掉能读的权限，也就是 4 分，那么要拿掉读与写的权限，也就是 6 分，而要拿掉执行与写入的权限，也就是 3 分，这样了解吗？请问你， 5 分是什么？呵呵！ 就是读与执行的权限啦！

![image-20200517152317269](http://picbed.yoyolikescici.cn/uPic/image-20200517152317269.png)



### 2.隐藏属性

chattr

![image-20200517153114197](http://picbed.yoyolikescici.cn/uPic/image-20200517153114197.png)





- lsattr 

    ![image-20200517153209775](http://picbed.yoyolikescici.cn/uPic/image-20200517153209775.png)



### 3. 文件特殊权限， SUID，SGID，SBIT

- SUID
    - SUID 权限仅对二进制程序（binary program）有效；
    - 执行者对于该程序需要具有 x 的可执行权限； 
    - 本权限仅在执行该程序的过程中有效 （run-time）； 
    - 执行者将具有该程序拥有者 （owner） 的权限。



![image-20200517153642637](http://picbed.yoyolikescici.cn/uPic/image-20200517153642637.png)



- SGID

    ![image-20200517153723593](http://picbed.yoyolikescici.cn/uPic/image-20200517153723593.png)

![image-20200517175805048](http://picbed.yoyolikescici.cn/uPic/image-20200517175805048.png)



- SBIT

    ![image-20200517175858310](http://picbed.yoyolikescici.cn/uPic/image-20200517175858310.png)

SUID/SGID/SBIT权限设置 

前面介绍过 SUID 与 SGID 的功能，那么如何设置文件使成为具有 SUID 与 SGID 的权限呢？ 这就需要第五章的数字更改权限的方法 了！ 现在你应该已经知道数字体态更改权限的方式为“三个数字”的组合， 那么如果在这三个数字之前再加上一个数字的话，最前面的那个数字 就代表这几个权限了！

4 为 SUID 

2 为 SGID 

1 为 SBIT





### 4. 文件类型 file

![image-20200517180017385](http://picbed.yoyolikescici.cn/uPic/image-20200517180017385.png)



## 5. 指令和文件的搜索

### which

![image-20200517180535081](http://picbed.yoyolikescici.cn/uPic/image-20200517180535081.png)



### whereis

![image-20200517180653390](http://picbed.yoyolikescici.cn/uPic/image-20200517180653390.png)

### locate/updatedb

![image-20200517181111862](http://picbed.yoyolikescici.cn/uPic/image-20200517181111862.png)

但是，这个东西还是有使用上的限制呦！为什么呢？你会发现使用 locate 来寻找数据的时候特别的快， 这是因为 locate 寻找的数据是 由 已创建的数据库 /var/lib/mlocate/” 里面的数据所搜寻到的，所以不用直接在去硬盘当中存取数据，呵呵！当然是很快速啰！

就是因为他是经由数据库来搜寻的，而数据库的创建默认是在每天执行一次 （每个 distribution 都不同，CentOS 7.x 是每天更新数据库一次！），所以当你新创建起来的文件， 却还在数据库更新之前搜寻该文件，那么 locate 会告诉你“找不到！”呵呵！因 为必须要更新数据库呀！

那能否手动更新数据库哪？当然可以啊！更新 locate 数据库的方法非常简单，直接输入“ updatedb ”就可以了！ updatedb 指令会去读取 /etc/updatedb.conf 这个配置文件的设置，然后再去硬盘里面进行搜寻文件名的动作， 最后就更新整个数据库文件啰！因为 updatedb 会去搜寻 硬盘，所以当你执行 updatedb 时，可能会等待数分钟的时间喔！

![image-20200517181812738](http://picbed.yoyolikescici.cn/uPic/image-20200517181812738.png)





### find

![image-20200517181942140](http://picbed.yoyolikescici.cn/uPic/image-20200517181942140.png)

![image-20200517184018190](http://picbed.yoyolikescici.cn/uPic/image-20200517184018190.png)

![image-20200517184041129](http://picbed.yoyolikescici.cn/uPic/image-20200517184041129.png)

![image-20200517184101051](http://picbed.yoyolikescici.cn/uPic/image-20200517184101051.png)

![image-20200517184132471](http://picbed.yoyolikescici.cn/uPic/image-20200517184132471.png)





# 第七章 Linux磁盘与文件系统管理

## 1. 认识Linux文件系统

### 3. EXT2 文件系统

文件系统特性

- superblock：记录此 filesystem 的整体信息，包括inode/block的总量、使用量、剩余量， 以及文件系统的格式与相关信息等； 
- inode：记录文件的属性，一个文件占用一个inode，同时记录此文件的数据所在的 block 号码； 
- block：实际记录文件的内容，若文件太大时，会占用多个 block 。

| Block 大小         | 1KB  | 2KB   | 4KB  |
| ------------------ | ---- | ----- | ---- |
| 最大单一文件限制   | 16GB | 256GB | 2TB  |
| 最大文件系统总容量 | 2TB  | 8TB   | 16TB |



- 原则上，block 的大小与数量在格式化完就不能够再改变了（除非重新格式化）； 
- 每个 block 内最多只能够放置一个文件的数据； 
- 承上，如果文件大于 block 的大小，则一个文件会占用多个 block 数量； 
- 承上，若文件小于 block ，则该 block 的剩余容量就不能够再被使用了（磁盘空间会浪费）。



### innode table

再来讨论一下 inode 这个玩意儿吧！如前所述 inode 的内容在记录文件的属性以及该文件实际数据是放置在哪几号 block 内！ 基本 上，inode 记录的文件数据至少有下面这些： [4]

- 该文件的存取模式（read/write/excute）；
-  该文件的拥有者与群组（owner/group）；
- 该文件的容量； 
- 该文件创建或状态改变的时间（ctime）； 
- 最近一次的读取时间（atime）； 
- 最近修改的时间（mtime）；
-  定义文件特性的旗标（flag），如 SetUID...； 
- 该文件真正内容的指向 （pointer）；

innode 其他特色

- 每个 inode 大小均固定为 128 Bytes （新的 ext4 与 xfs 可设置到 256 Bytes）；
- 每个文件都仅会占用一个 inode 而已； 
- 承上，因此文件系统能够创建的文件数量与 inode 的数量有关；
-  系统读取文件时需要先找到 inode，并分析 inode 所记录的权限与使用者是否符合，若符合才能够开始实际读取 block 的内容。



#### 12直接、一间接、双间接、三间接

![image-20200517190800841](http://picbed.yoyolikescici.cn/uPic/image-20200517190800841.png)

这样子 inode 能够指定多少个 block 呢？我们以较小的 1K block 来说明好了，可以指定的情况如下： 12 个直接指向： 12*1K=12K

由于是直接指向，所以总共可记录 12 笔记录，因此总额大小为如上所示；

- 间接： 256*1K=256K 每笔 block 号码的记录会花去 4Bytes，因此 1K 的大小能够记录 256 笔记录，因此一个间接可以记录的文件大小如上；

- 双间接： 256*256*1K=256 2 K 第一层 block 会指定 256 个第二层，每个第二层可以指定 256 个号码，因此总额大小如上；

- 三间接： 256*256*256*1K=256 3 K 第一层 block 会指定 256 个第二层，每个第二层可以指定 256 个第三层，每个第三层可以指定 256 个号码，因此总额大小如上；

- 总额：将直接、间接、双间接、三间接加总，得到 12 + 256 + 256*256 + 256*256*256 （K） = 16GB



### Superblock

Superblock 是记录整个 filesystem 相关信息的地方， 没有 Superblock ，就没有这个 filesystem 了。他记录的信息主要有：

- block 与 inode 的总量； 
- 未使用与已使用的 inode / block 数量；
- block 与 inode 的大小 （block 为 1, 2, 4K，inode 为 128Bytes 或 256Bytes）； 
- filesystem 的挂载时间、最近一次写入数据的时间、最近一次检验磁盘 （fsck） 的时间等文件系统的相关信息；
- 一个 valid bit 数值，若此文件系统已被挂载，则 valid bit 为 0 ，若未被挂载，则 valid bit 为 1 。



### 4. 与目录树的关系

当我们在 Linux 下的文件系统创建一个目录时，文件系统会分配一个 inode 与至少一块 block 给该目录。

其中，inode 记录该目录的相关 权限与属性，并可记录分配到的那块 block 号码； 而 block 则是记录在这个目录下的文件名与该文件名占用的 inode 号码数据。也就是说目录 所占用的 block 内容在记录如下的信息：

![image-20200518085935647](http://picbed.yoyolikescici.cn/uPic/image-20200518085935647.png)



#### 目录树读区

ll -di /

![image-20200518090141536](http://picbed.yoyolikescici.cn/uPic/image-20200518090141536.png)



### 5. EXT2/EXT3/EXT4 文件的存取与日志式文件系统的功能

假设我们想要新增一个文件，此时文件系统的行为是：

1. 先确定使用者对于欲新增文件的目录是否具有 w 与 x 的权限，若有的话才能新增；
2. 根据 inode bitmap 找到没有使用的 inode 号码，并将新文件的权限/属性写入；
3. 根据 block bitmap 找到没有使用中的 block 号码，并将实际的数据写入 block 中，且更新 inode 的 block 指向数据；
4. 将刚刚写入的 inode 与 block 数据同步更新 inode bitmap 与 block bitmap，并更新 superblock 的内容。



#### 日志式文件系统 （ Journaling filesystem）

1. 预备：当系统要写入一个文件时，会先在日志记录区块中纪录某个文件准备要写入的信息；
2. 实际写入：开始写入文件的权限与数据；开始更新 metadata 的数据；
3. 结束：完成数据与 metadata 的更新后，在日志记录区块当中完成该文件的纪录。





### 6. linux 文件系统的运行

当系统载入一个文件到内存后，如果该文件没有被更动过，则在内存区段的文件数据会被设置为干净（clean）的。 但如果内存中的文 件数据被更改过了（例如你用 nano 去编辑过这个文件），此时该内存中的数据会被设置为脏的 （Dirty）。此时所有的动作都还在内存中执 行，并没有写入到磁盘中！ 系统会不定时的将内存中设置为“Dirty”的数据写回磁盘，以保持磁盘与内存数据的一致性。 你也可以利用第四章谈 到的 sync指令来手动强迫写入磁盘。

我们知道内存的速度要比磁盘快的多，因此如果能够将常用的文件放置到内存当中，这不就会增加系统性能吗？ 没错！是有这样的想 法！因此我们 Linux 系统上面文件系统与内存有非常大的关系喔：

系统会将常用的文件数据放置到内存的缓冲区，以加速文件系统的读/写； 承上，因此 Linux 的实体内存最后都会被用光！这是正常的情况！可加速系统性能； 你可以手动使用 sync 来强迫内存中设置为 Dirty 的文件回写到磁盘中； 若正常关机时，关机指令会主动调用 sync 来将内存的数据回写入磁盘内； 但若不正常关机（如跳电、死机或其他不明原因），由于数据尚未回写到磁盘内， 因此重新开机后可能会花很多时间在进行磁盘检验， 甚至可能导致文件系统的损毁（非磁盘损毁）。





### 7. 挂载点的意义

每个 filesystem 都有独立的 inode / block / superblock 等信息，这个文件系统要能够链接到目录树才能被我们使用。 将文件系统与目录 树结合的动作我们称为“挂载”。 关于挂载的一些特性我们在第二章稍微提过， 重点是：挂载点一定是目录，该目录为进入该文件系统的入口。 因此并不是你有任何文件系统都能使用，必须要“挂载”到目录树的某个目录后，才能够使用该文件系统的。



### 8. 其他 Linux 支持的文件系统与 VFS

- 传统文件系统：ext2 / minix / MS-DOS / FAT （用 vfat 模块） / iso9660 （光盘）等等； 
- 日志式文件系统： ext3 /ext4 / ReiserFS / Windows' NTFS / IBM's JFS / SGI's XFS / ZFS 
- 网络文件系统： NFS / SMBFS





### 9. XFS

xfs 文件系统在数据的分佈上，主要规划为三个部份，一个数据区 （data section）、一个文件系统活动登录区 （log section）以及一个 实时运行区 （realtime section）。 

#### 数据区 data section

（1）整个文件系统的 superblock、 

（2）剩余空间的管理机制、 

（3）inode的分配与追踪。此外，inode与 block 都是系统需要 用到时， 这才动态配置产生，所以格式化动作超级快！



#### 文件系统活动登录区 （log section）

在登录区这个区域主要被用来纪录文件系统的变化，其实有点像是日志区啦！文件的变化会在这里纪录下来，直到该变化完整的 写入到数据区后， 该笔纪录才会被终结。如果文件系统因为某些缘故 （例如最常见的停电） 而损毁时，系统会拿这个登录区块来进行 检验，看看系统挂掉之前， 文件系统正在运行些啥动作，借以快速的修复文件系统。



#### 实时运行区 （realtime section）

当有文件要被创建时，xfs 会在这个区段里面找一个到数个的 extent 区块，将文件放置在这个区块内，等到分配完毕后，再写入到 data section 的 inode 与 block 去！ 这个 extent 区块的大小得要在格式化的时候就先指定，最小值是 4K 最大可到 1G。一般非磁盘阵列 的磁盘默认为 64K 容量，而具有类似磁盘阵列的 stripe 情况下，则建议 extent 设置为与 stripe 一样大较佳。这个 extent 最好不要乱动， 因为可能会影响到实体磁盘的性能喔。



#### XFS文件系统的描述数据观察

![image-20200518100158921](http://picbed.yoyolikescici.cn/uPic/image-20200518100158921.png)

- 第 1 行里面的 isize 指的是 inode 的容量，每个有 256Bytes 这么大。至于 agcount 则是前面谈到的储存区群组 （allocation group） 的个 数，共有 4 个， agsize 则是指每个储存区群组具有 65536 个 block 。配合第 4 行的 block 设置为 4K，因此整个文件系统的容量应该就是 4*65536*4K 这么大！ 
- 第 2 行里面 sectsz 指的是逻辑扇区 （sector） 的容量设置为 512Bytes 这么大的意思。
- 第 4 行里面的 bsize 指的是 block 的容量，每个 block 为 4K 的意思，共有 262144 个 block 在这个文件系统内。 
- 第 5 行里面的 sunit 与 swidth 与磁盘阵列的 stripe 相关性较高。这部份我们下面格式化的时候会举一个例子来说明。 
- 第 7 行里面的 internal 指的是这个登录区的位置在文件系统内，而不是外部设备的意思。且占用了 4K * 2560 个 block，总共约 10M 的容 量。 
- 第 9 行里面的 realtime 区域，里面的 extent 容量为 4K。不过目前没有使用。





## 2. 文件系统的简单操作

### 1. 磁盘和目录的容量

#### df-列出文件系统的整体磁盘使用量；

![image-20200518100544028](http://picbed.yoyolikescici.cn/uPic/image-20200518100544028.png)

- Filesystem：代表该文件系统是在哪个 partition ，所以列出设备名称； 
- 1k-blocks：说明下面的数字单位是 1KB 呦！可利用 -h 或 -m 来改变容量；
- Used：顾名思义，就是使用掉的磁盘空间啦！ 
- Available：也就是剩下的磁盘空间大小； 
- Use%：就是磁盘的使用率啦！如果使用率高达 90% 以上时， 最好需要注意一下了，免得容量不足造成系统问题喔！（例如最容易被灌 爆的 /var/spool/mail 这个放置邮件的磁盘） Mounted on：就是磁盘挂载的目录所在啦！（挂载点啦！）



#### du

评估文件系统的磁盘使用量（常用在推估目录所占容量）

![image-20200518121453700](http://picbed.yoyolikescici.cn/uPic/image-20200518121453700.png)



### 2. 实体链接与符号链接

#### Hard Link （实体链接 , 硬式链接或实际链接）

hard link 只是在某个目录下新增一笔文件名链接到某 inode 号码的关连记录而已。

![image-20200518121757190](http://picbed.yoyolikescici.cn/uPic/image-20200518121757190.png)

两个限制

- 不能跨 Filesystem； 
- 不能 link 目录。



不能跨 Filesystem 还好理解，那不能 hard link 到目录又是怎么回事呢？这是因为如果使用 hard link 链接到目录时， 链接的数据需要连 同被链接目录下面的所有数据都创建链接，举例来说，如果你要将 /etc 使用实体链接创建一个 /etc_hd 的目录时，那么在 /etc_hd 下面的所有 文件名同时都与 /etc 下面的文件名要创建 hard link 的，而不是仅链接到 /etc_hd 与 /etc 而已。 并且，未来如果需要在 /etc_hd 下面创建新文件 时，连带的， /etc 下面的数据又得要创建一次 hard link ，因此造成环境相当大的复杂度。 所以啰，目前 hard link 对于目录暂时还是不支持的 啊！



#### Symbolic Link（符号链接，亦即是捷径）

Symbolic link 就是在创建一个独立的文件，而这个文件会让数据的读取指 向他 link 的那个文件的文件名！由于只是利用文件来做为指向的动作， 所以，当来源文件被删除之后，symbolic link 的文件会“开不了”， 会一 直说“无法打开某文件！”。实际上就是找不到原始“文件名”而已啦！



![image-20200518122039987](http://picbed.yoyolikescici.cn/uPic/image-20200518122039987.png)



![image-20200518122107527](http://picbed.yoyolikescici.cn/uPic/image-20200518122107527.png)

![image-20200518122207011](http://picbed.yoyolikescici.cn/uPic/image-20200518122207011.png)



#### 关于目录的link数量

或许您已经发现了，那就是，当我们以 hard link 进行“文件的链接”时，可以发现，在 ls -l 所显示的第二字段会增加一才对，那么请教， 如果创建目录时，他默认的 link 数量会是多少？ 让我们来想一想，一个“空目录”里面至少会存在些什么？呵呵！就是存在 . 与 .. 这两个目录 啊！ 那么，当我们创建一个新目录名称为 /tmp/testing 时，基本上会有三个东西，那就是：

- /tmp/testing 
- /tmp/testing/. 
- /tmp/testing/..

而其中 /tmp/testing 与 /tmp/testing/. 其实是一样的！都代表该目录啊～而 /tmp/testing/.. 则代表 /tmp 这个目录，所以说，当我们创建一个 新的目录时， “新的目录的 link 数为 2 ，而上层目录的 link 数则会增加 1 ” 不信的话，我们来作个测试看看：

![image-20200518122503226](http://picbed.yoyolikescici.cn/uPic/image-20200518122503226.png)





## 3. 磁盘的分区、格式化、检验与挂载

新增硬盘时:

1. 对磁盘进行分区，以创建可用的 partition ；

2. 对该 partition 进行格式化 （format），以创建系统可用的 filesystem；

3. 若想要仔细一点，则可对刚刚创建好的 filesystem 进行检验；

4. 在 Linux 系统上，需要创建挂载点 （亦即是目录），并将他挂载上来；



### lsblk

list block device

![image-20200518122708092](http://picbed.yoyolikescici.cn/uPic/image-20200518122708092.png)

![image-20200518123945080](http://picbed.yoyolikescici.cn/uPic/image-20200518123945080.png)

- NAME：就是设备的文件名啰！会省略 /dev 等前导目录！ 
- MAJ:MIN：其实核心认识的设备都是通过这两个代码来熟悉的！分别是主要：次要设备代码！ 
- RM：是否为可卸载设备 （removable device），如光盘、USB 磁盘等等 
- SIZE：当然就是容量啰！ 
- RO：是否为只读设备的意思 
- TYPE：是磁盘 （disk）、分区 （partition） 还是只读存储器 （rom） 等输出 
- MOUTPOINT：就是前一章谈到的挂载点！



#### -blkid

列出设备的 UUID 等参数

![image-20200518135600098](http://picbed.yoyolikescici.cn/uPic/image-20200518135600098.png)





#### parted

列出磁盘的分区表类型与分区信息

![image-20200518184840855](http://picbed.yoyolikescici.cn/uPic/image-20200518184840855.png)

![image-20200518184859966](http://picbed.yoyolikescici.cn/uPic/image-20200518184859966.png)





### 磁盘分区 gdisk/fdisk

“MBR 分区表请使用 fdisk 分区， GPT 分区表请使用 gdisk 分区！”

#### gdisk

![image-20200518185218857](http://picbed.yoyolikescici.cn/uPic/image-20200518185218857.png)

![image-20200518185423943](http://picbed.yoyolikescici.cn/uPic/image-20200518185423943.png)

- 新增分区

![image-20200518185454767](http://picbed.yoyolikescici.cn/uPic/image-20200518185454767.png)

![image-20200518185507238](http://picbed.yoyolikescici.cn/uPic/image-20200518185507238.png)

![image-20200518185521387](http://picbed.yoyolikescici.cn/uPic/image-20200518185521387.png)



##### partprobe  更新Linux 核心的分区表信息

![image-20200518185546896](http://picbed.yoyolikescici.cn/uPic/image-20200518185546896.png)



##### gdisk 删除分区

![image-20200518185621332](http://picbed.yoyolikescici.cn/uPic/image-20200518185621332.png)





### 3. 格式化

#### 1. xfs

mafs.xfs

![image-20200518190503768](http://picbed.yoyolikescici.cn/uPic/image-20200518190503768.png)

![image-20200518190534582](http://picbed.yoyolikescici.cn/uPic/image-20200518190534582.png)



#### ext4

![image-20200518190620820](http://picbed.yoyolikescici.cn/uPic/image-20200518190620820.png)

![image-20200518190848460](http://picbed.yoyolikescici.cn/uPic/image-20200518190848460.png)

### 4. 文件系统检验

#### 1. xfs_repair

![image-20200518190924312](http://picbed.yoyolikescici.cn/uPic/image-20200518190924312.png)

xfs_repair 可以检查/修复文件系统，不过，因为修复文件系统是个很庞大的任务！因此，修复时该文件系统不能被挂载！ 所以，检查与 修复 /dev/vda4 没啥问题，但是修复 /dev/centos/home 这个已经挂载的文件系统时，嘿嘿！就出现上述的问题了！ 没关系，若可以卸载，卸载 后再处理即可。

Linux 系统有个设备无法被卸载，那就是根目录啊！如果你的根目录有问题怎办？这时得要进入单人维护或救援模式，然后通过 -d 这个 选项来处理！ 加入 -d 这个选项后，系统会强制检验该设备，检验完毕后就会自动重新开机啰！不过，鸟哥完全不打算要进行这个指令的实 做... 永远都不希望实做这东西...





#### 2. fsck.ext4

![image-20200518191211243](http://picbed.yoyolikescici.cn/uPic/image-20200518191211243.png)





### 5. 文件系统挂载和卸载

- 单一文件系统不应该被重复挂载在不同的挂载点（目录）中； 
- 单一目录不应该重复挂载多个文件系统； 
- 要作为挂载点的目录，理论上应该都是空目录才是。



尤其是上述的后两点！如果你要用来挂载的目录里面并不是空的，那么挂载了文件系统之后，原目录下的东西就会暂时的消失。 举个例 子来说，假设你的 /home 原本与根目录 （/） 在同一个文件系统中，下面原本就有 /home/test 与 /home/vbird 两个目录。然后你想要加入新的 磁盘，并且直接挂载 /home 下面，那么当你挂载上新的分区时，**则 /home 目录显示的是新分区内的数据，至于原先的 test 与 vbird 这两个目录 就会暂时的被隐藏掉了！**注意喔！并不是被覆盖掉， 而是暂时的隐藏了起来，等到新分区被卸载之后，则 /home 原本的内容就会再次的跑出 来啦！



![image-20200518191626735](http://picbed.yoyolikescici.cn/uPic/image-20200518191626735.png)

基本上，CentOS 7 已经太聪明了，因此你不需要加上 -t 这个选项，系统会自动的分析最恰当的文件系统来尝试挂载你需要的设备！ 这 也是使用 blkid 就能够显示正确的文件系统的缘故！那 CentOS 是怎么找出文件系统类型的呢？ 由于文件系统几乎都有 superblock ，我们的 Linux 可以通过分析 superblock 搭配 Linux 自己的驱动程序去测试挂载， 如果成功的套和了，就立刻自动的使用该类型的文件系统挂载起来 啊！那么系统有没有指定哪些类型的 filesystem 才需要进行上述的挂载测试呢？ 主要是参考下面这两个文件：

/etc/filesystems：系统指定的测试挂载文件系统类型的优先顺序； 

/proc/filesystems：Linux系统已经载入的文件系统类型。

那我怎么知道我的 Linux 有没有相关文件系统类型的驱动程序呢？我们 Linux 支持的文件系统之驱动程序都写在如下的目录中：

`/lib/modules/$（uname -r）/kernel/fs/ `例如 ext4 的驱动程序就写在“/lib/modules/$（uname -r）/kernel/fs/ext4/”这个目录下啦！

另外，过去我们都习惯使用设备文件名然后直接用该文件名挂载， 不过近期以来鸟哥比较建议使用 UUID 来识别文件系统，会比设备名 称与标头名称还要更可靠！因为是独一无二的啊！



![image-20200518191809180](http://picbed.yoyolikescici.cn/uPic/image-20200518191809180.png)

![image-20200518192619852](http://picbed.yoyolikescici.cn/uPic/image-20200518192619852.png)



##### 重新挂载根目录

![image-20200518192750840](http://picbed.yoyolikescici.cn/uPic/image-20200518192750840.png)





##### 卸载设备

![image-20200518193017840](http://picbed.yoyolikescici.cn/uPic/image-20200518193017840.png)

![image-20200518193116352](http://picbed.yoyolikescici.cn/uPic/image-20200518193116352.png)



### 6. 磁盘、文件系统参数修订

#### mknod

ll /dev/vda*

！但是那个文件如何代表该设备呢？ 很简单！就是通过文件的 major 与 minor 数值来替代的

![image-20200518193347349](http://picbed.yoyolikescici.cn/uPic/image-20200518193347349.png)

![image-20200518193905513](http://picbed.yoyolikescici.cn/uPic/image-20200518193905513.png)



#### xfs_admin

![image-20200519091319525](http://picbed.yoyolikescici.cn/uPic/image-20200519091319525.png)



#### tune2fs

![image-20200519091340970](http://picbed.yoyolikescici.cn/uPic/image-20200519091340970.png)



## 4. 设置开机挂载

### /etc/fstab 及 /etc/mtab

系统挂载的一些限制

- 根目录 / 是必须挂载的﹐而且一定要先于其它 mount point 被挂载进来。 
- 其它 mount point 必须为已创建的目录﹐可任意指定﹐但一定要遵守必须的系统目录架构原则 （FHS）
- 所有 mount point 在同一时间之内﹐只能挂载一次。
-  所有 partition 在同一时间之内﹐只能挂载一次。 
- 如若进行卸载﹐您必须先将工作目录移到 mount point（及其子目录） 之外。

![image-20200519091901826](http://picbed.yoyolikescici.cn/uPic/image-20200519091901826.png)

![image-20200519091912597](http://picbed.yoyolikescici.cn/uPic/image-20200519091912597.png)



- 第一栏：磁盘设备文件名/UUID/LABEL name：

    ​	这个字段可以填写的数据主要有三个项目：

    ​	文件系统或磁盘的设备文件名，如 /dev/vda2 等 文件系统的 UUID 名称，如 UUID=xxx

    ​	文件系统的 LABEL 名称，例如 LABEL=xxx

    ​		因为每个文件系统都可以有上面三个项目，所以你喜欢哪个项目就填哪个项目！无所谓的！只是从鸟哥测试机的 /etc/fstab 里面看 到的，在挂载点 /boot 使用的已经是 UUID 了喔！那你会说不是还有多个写 /dev/mapper/xxx 的吗？怎么回事啊？ 因为那个是 LVM 啊！LVM 的文件名在你的系统中也算是独一无二的，这部份我们在后续章节再来谈。 不过，如果为了一致性，你还是可以将他改成 UUID 也没问题喔！（鸟哥还是比较建议使用 UUID 喔！） 要记得使用 blkid 或 xfs_admin 来查询 UUID 喔！

- 第二栏：挂载点 （mount point）：：

    ​	就是挂载点啊！挂载点是什么？一定是目录啊～要知道啊！忘记的话，请回本章稍早之前的数据瞧瞧喔！

- 第三栏：磁盘分区的文件系统：

    ​	在手动挂载时可以让系统自动测试挂载，但在这个文件当中我们必须要手动写入文件系统才行！ 包括 xfs, ext4, vfat, reiserfs, nfs 等等。

- 第四栏：文件系统参数：

    ​	记不记得我们在 mount 这个指令中谈到很多特殊的文件系统参数？ 还有我们使用过的“-o codepage=950”？这些特殊的参数就是 写入在这个字段啦！ 虽然之前在 mount 已经提过一次，这里我们利用表格的方式再汇整一下：

![image-20200519092025629](http://picbed.yoyolikescici.cn/uPic/image-20200519092025629.png)

- 第五栏：能否被 dump 备份指令作用： 

    ​		dump 是一个用来做为备份的指令，不过现在有太多的备份方案了，所以这个项目可以不要理会啦！直接输入 0 就好了！ 

- 第六栏：是否以 fsck 检验扇区：

    ​	早期开机的流程中，会有一段时间去检验本机的文件系统，看看文件系统是否完整 （clean）。 不过这个方式使用的主要是通过 fsck 去做的，我们现在用的 xfs 文件系统就没有办法适用，因为 xfs 会自己进行检验，不需要额外进行这个动作！所以直接填 0 就好了。

![image-20200520002652820](http://picbed.yoyolikescici.cn/uPic/image-20200520002652820.png)





### loop

#### 挂载iso

![image-20200520002804830](http://picbed.yoyolikescici.cn/uPic/image-20200520002804830.png)



#### 创建大型文件

- dd

![image-20200520002908190](http://picbed.yoyolikescici.cn/uPic/image-20200520002908190.png)



- 大型文件的格式化

    

![image-20200520002940190](http://picbed.yoyolikescici.cn/uPic/image-20200520002940190.png)



- 挂载

    ![image-20200520002952851](http://picbed.yoyolikescici.cn/uPic/image-20200520002952851.png)



## 5. 内存交换空间  swap

创建 swap 分区的方式也是非常的简单的！通过下面几个步骤就搞定啰：

1. 分区：先使用 gdisk 在你的磁盘中分区出一个分区给系统作为 swap 。由于 Linux 的 gdisk 默认会将分区的 ID 设置为 Linux 的文件系统， 所以你可能还得要设置一下 system ID 就是了。

2. 格式化：利用创建 swap 格式的“mkswap 设备文件名”就能够格式化该分区成为 swap 格式啰

3. 使用：最后将该 swap 设备启动，方法为：“swapon 设备文件名”。

4. 观察：最终通过 free 与 swapon -s 这个指令来观察一下内存的用量吧！

用时再查





## 6. 文件系统的特殊观察和操作

### parted 进行分区

![image-20200520004052846](http://picbed.yoyolikescici.cn/uPic/image-20200520004052846.png)





# 第八章 文件与文件系统的压缩、打包与备份

## 2. Linux 常见的压缩指令

![image-20200520004622516](http://picbed.yoyolikescici.cn/uPic/image-20200520004622516.png)

### 1. gzip ，    zcat/zmore/zless/zgrep

![image-20200520005030255](http://picbed.yoyolikescici.cn/uPic/image-20200520005030255.png)

![image-20200520005157809](http://picbed.yoyolikescici.cn/uPic/image-20200520005157809.png)





### 2. bzip2,    bzcat/bzmore/bzless/bzgrep

用来替代  gzip

![image-20200520005248557](http://picbed.yoyolikescici.cn/uPic/image-20200520005248557.png)



### 3. xz

![image-20200520005322623](http://picbed.yoyolikescici.cn/uPic/image-20200520005322623.png)





## 3. 打包：tar

### 1. tar

![image-20200520005420300](http://picbed.yoyolikescici.cn/uPic/image-20200520005420300.png)





- 压　缩：tar -jcv -f filename.tar.bz2 要被压缩的文件或目录名称

- 查　询：tar -jtv -f filename.tar.bz2 

- 解压缩：tar -jxv -f filename.tar.bz2 -C 欲解压缩的目录



实战例子

![image-20200520005812014](http://picbed.yoyolikescici.cn/uPic/image-20200520005812014.png)



### 查看打包内容

![image-20200520010718815](http://picbed.yoyolikescici.cn/uPic/image-20200520010718815.png)



### 解压

![image-20200520010745481](http://picbed.yoyolikescici.cn/uPic/image-20200520010745481.png)



### 解压特定文件

![image-20200520010834193](http://picbed.yoyolikescici.cn/uPic/image-20200520010834193.png)





### 选择性打包目录

![image-20200520010859420](http://picbed.yoyolikescici.cn/uPic/image-20200520010859420.png)



### 增量备份

![image-20200520010918127](http://picbed.yoyolikescici.cn/uPic/image-20200520010918127.png)

###  利用管线命令和数据流

![image-20200520011201938](../../Library/Application%20Support/typora-user-images/image-20200520011201938.png)





# 第九章 vim

![image-20200520011930932](http://picbed.yoyolikescici.cn/uPic/image-20200520011930932.png)



# 第十章 bash  Bourne Again SHell （简称 bash） 

![image-20200520012028542](http://picbed.yoyolikescici.cn/uPic/image-20200520012028542.png)

### 别名设置 alias

假如我需要知道这个目录下面的所有文件 （包含隐藏文件） 及所有的文件属性，那么我就必须要下达“ ls -al ”这样的指令串，唉！真麻 烦，有没有更快的取代方式？呵呵！就使用命令别名呀！例如鸟哥最喜欢直接以 lm 这个自订的命令来取代上面的命令，也就是说， lm 会等于 ls -al 这样的一个功能，嘿！那么要如何作呢？就使用 alias 即可！你可以在指令列输入 alias 就可以知道目前的命令别名有哪些了！也可以直 接下达命令来设置别名呦：

`alias lm='ls -al'  `



#### 查询命令是否为 Bash shell 的内置命令： type

![image-20200520012739983](http://picbed.yoyolikescici.cn/uPic/image-20200520012739983.png)

### 指令的编辑

![image-20200520013016971](http://picbed.yoyolikescici.cn/uPic/image-20200520013016971.png)



## 2. shell 变量功能

![image-20200520014108719](http://picbed.yoyolikescici.cn/uPic/image-20200520014108719.png)

![image-20200520014217986](http://picbed.yoyolikescici.cn/uPic/image-20200520014217986.png)



### 2. 变量的取用与设置： echo ，   变量设置规则， unset

说的口沫横飞的，也不知道“变量”与“变量代表的内容”有啥关系？ 那我们就将“变量”的“内容”拿出来给您瞧瞧好了。你可以利用 echo 这 个指令来取用变量， 但是，变量在被取用时，前面必须要加上钱字号“ $ ”才行，举例来说，要知道 PATH 的内容，该如何是好？



变量的设置规则

1. 变量与变量内容以一个等号“=”来链接，如下所示：

`myname=VBird`

2. 等号两边不能直接接空白字符，如下所示为错误： “myname = VBird”或“myname=VBird Tsai”

3. 变量名称只能是英文字母与数字，但是开头字符不能是数字，如下为错误：

`2myname=VBird`

4. 变量内容若有空白字符可使用双引号“"”或单引号“'”将变量内容结合起来，但 

    - 双引号内的特殊字符如 \$ 等，可以保有原本的特性，如下所示：
        -  `var="lang is $LANG"`则`echo $var`可得`lang is zh_TW.UTF-8`
    - 单引号内的特殊字符则仅为一般字符 （纯文本），如下所示：
        - `var='lang is $LANG'`则`echo $var`可得`lang is $LANG”`

5.  可用跳脱字符“ \ ”将特殊符号（如 [Enter], $, \, 空白字符, '等）变成一般字符，如：

    `myname=VBird\ Tsai`

6. 在一串指令的执行中，还需要借由其他额外的指令所提供的信息时，可以使用反单引号“`指令`”或 “\$（指令）”。特别注意，那个\` 是键盘 上方的数字键 1 左边那个按键，而不是单引号！ 例如想要取得核心版本的设置： `version=$（uname -r）`再`echo $version`可得`3.10.0-229.el7.x86_64`

7. **若该变量为扩增变量内容时，则可用 "\$变量名称" 或 ​\${变量} 累加内容，如下所示：** `PATH="$PATH":/home/bin`   或    `PATH=${PATH}:/home/bin`

8. 若该变量需要在其他子程序执行，则需要以 export 来使变量变成环境变量： `export PATH`

9. 通常大写字符为系统默认变量，自行设置变量可以使用小写字符，方便判断 （纯粹依照使用者兴趣与嗜好） ；

10. 取消变量的方法为使用 unset ：“unset 变量名称”例如取消 myname 的设置：

    `unset myname`





### 3. 环境变量的功能

#### env- 环境变量

![image-20200520020249648](http://picbed.yoyolikescici.cn/uPic/image-20200520020249648.png)



#### set - 所有变量，含环境变量和自定变量

![image-20200520020345168](http://picbed.yoyolikescici.cn/uPic/image-20200520020345168.png)



#### 上个指令的回传值

![image-20200520020635568](http://picbed.yoyolikescici.cn/uPic/image-20200520020635568.png)



#### export  自订变量转换成环境变量

![image-20200520020816884](http://picbed.yoyolikescici.cn/uPic/image-20200520020816884.png)



### 4. 影响显示结果的语系变量 locale

![image-20200520020848424](http://picbed.yoyolikescici.cn/uPic/image-20200520020848424.png)



### 5. 变量的有效范围



如果在跑程序的时候，有父程序与子 程序的不同程序关系时， 则“变量”可否被引用与 export 有关。被 export 后的变量，我们可以称他为“环境变量”！ 环境变量可以被子程序所引 用，但是其他的自订变量内容就不会存在于子程序中。

- 当启动一个 shell，操作系统会分配一记忆区块给 shell 使用，此内存内之变量可让子程序取用 
- 若在父程序利用 export 功能，可以让自订变量的内容写到上述的记忆区块当中（环境变量）； 
- 当载入另一个 shell 时 （亦即启动子程序，而离开原本的父程序了），子 shell 可以将父 shell 的环境变量所在的记忆区块导入自己的环境变 量区块当中。



### 6. 变量键盘读取、阵列与宣告：read, array, declare

####  1. read

[dmtsai@study ~]$ read [-pt] variable

选项与参数：

- -p ：后面可以接提示字符！

- -t ：后面可以接等待的“秒数！”这个比较有趣～不会一直等待使用者啦！

![image-20200526185910730](http://picbed.yoyolikescici.cn/uPic/image-20200526185910730.png)



#### declare / typeset

![image-20200526215119733](http://picbed.yoyolikescici.cn/uPic/image-20200526215119733.png)

由于在默认的情况下面， bash 对于变量有几个基本的定义：

- 变量类型默认为“字串”，所以若不指定变量类型，则 1+2 为一个“字串”而不是“计算式”。 所以上述第一个执行的结果才会出现那个情况 的； 
- bash 环境中的数值运算，默认最多仅能到达整数形态，所以 1/3 结果是 0；

![image-20200526215241679](http://picbed.yoyolikescici.cn/uPic/image-20200526215241679.png)



#### array

var[index]=content

![image-20200526215521285](http://picbed.yoyolikescici.cn/uPic/image-20200526215521285.png)



### 7. 与文件系统及程序的限制关系： ulimit

我们的 bash 是可以“限制使用者的某些系统资源”的，包括可以打开的文件数量， 可以使用的 CPU 时 间，可以使用的内存总量等等。

![image-20200526215917163](http://picbed.yoyolikescici.cn/uPic/image-20200526215917163.png)

想要复原 **ulimit 的设置最简单的方法就是登出再登陆，否则就是得要重新以 ulimit 设置才行**！ 不过，要注意的是，一般身份使用者如果以 ulimit 设置了 -f 的文件大小， 那么他“只能继续减小文件大小，不能增加文件大小喔！”另外，若想要管控使用者的 ulimit 限值， 可以参考第十三 章的 pam 的介绍。



### 8. 变量内容的删除、取代与替换

#### 1. 变量内容的删除与取代



| 变量设置方式                                      | 说明                                                         |
| ------------------------------------------------- | ------------------------------------------------------------ |
| \${变量#关键字} <br>​\${变量##关键字}              | 若变量内容**从头开始**的数据符合“关键字”，则将符合的**最短**数据删除 <br>若变量内容**从头开始**的数据符合“关键字”，则将符合的**最长**数据删除 |
| \${变量%关键字}<br>${变量%%关键字}                | 若变量内容**从尾向前**的数据符合“关键字”，则将符合的**最短**数据删除 <br>若变量内容从尾向前的数据符合“关键字”，则将符合的**最长**数据删除 |
| \${变量/旧字串/新字串} <br>${变量//旧字串/新字串} | 若变量内容符合“旧字串”则“第一个旧字串会被新字串取代” <br>若变量内容符合“旧字串”则“全部的旧字串会被新字串取代” |





![image-20200526220412372](http://picbed.yoyolikescici.cn/uPic/image-20200526220412372.png)

![image-20200526220502911](http://picbed.yoyolikescici.cn/uPic/image-20200526220502911.png)

![image-20200526223354246](http://picbed.yoyolikescici.cn/uPic/image-20200526223354246.png)

![image-20200526223341094](http://picbed.yoyolikescici.cn/uPic/image-20200526223341094.png)

#### 2. 变量的测试与内容替换

| 变量设置方式     | str 没有设置           | str 为空字串           | str 已设置非为空字串   |
| ---------------- | ---------------------- | ---------------------- | ---------------------- |
| var=${str-expr}  | var=expr               | var=                   | var=$str               |
| var=${str:-expr} | var=expr               | var=expr               | var=$str               |
| var=${str+expr}  | var=                   | var=expr               | var=expr               |
| var=${str:+expr} | var=                   | var=                   | var=expr               |
| var=${str=expr}  | str=expr <br>var=expr  | str 不变<br/> var=     | str 不变 <br/>var=$str |
| var=${str:=expr} | str=expr <br/>var=expr | str=expr <br/>var=expr | str 不变 <br/>var=$str |
| var=${str?expr}  | expr 输出至 stderr     | var=                   | var=$str               |
| var=${str:?expr} | expr 输出至 stderr     | expr 输出至 stderr     | var=$str               |





## 3. 命名别名与历史命令

### 1. 命令别名设置：alias， unalias

![image-20200526221644119](http://picbed.yoyolikescici.cn/uPic/image-20200526221644119.png)

### 2. 历史命令 history

![image-20200526223236241](http://picbed.yoyolikescici.cn/uPic/image-20200526223236241.png)

在正常的情况下，历史命令的读取与记录是这样的：

- 当我们以 bash 登陆 Linux 主机之后，系统会主动的由主文件夹的 ~/.bash_history 读取以前曾经下过的指令，那么 ~/.bash_history 会记录 几笔数据呢？这就与你 bash 的 HISTFILESIZE 这个变量设置值有关了！
- 假设我这次登陆主机后，共下达过 100 次指令，“等我登出时， 系统就会将 101~1100 这总共 1000 笔历史命令更新到 ~/.bash_history 当中。” 也就是说，历史命令在我登出时，会将最近的 HISTFILESIZE 笔记录到我的纪录档当中啦！
- 当然，也可以用 history -w 强制立刻写入的！那为何用“更新”两个字呢？ 因为 ~/.bash_history 记录的笔数永远都是 HISTFILESIZE 那么 多，旧的讯息会被主动的拿掉！ 仅保留最新的！

![image-20200526223754436](http://picbed.yoyolikescici.cn/uPic/image-20200526223754436.png)





## 4. Bash Shell 的操作环境

### 1. 路径与指令搜寻顺序

1. 以相对/绝对路径执行指令，例如“ /bin/ls ”或“ ./ls ”；
2. 由 alias 找到该指令来执行；
3. 由 bash 内置的 （builtin） 指令来执行；
4. 通过 $PATH 这个变量的顺序搜寻到的第一个指令来执行。





### 2. bash 的进站与欢迎讯息  ：  /etc/issue， /etc/motd

![image-20200526224254759](http://picbed.yoyolikescici.cn/uPic/image-20200526224254759.png)



### 3. bash的环境配置文件

#### 1. login 与 non-login shell

- login shell：取得 bash 时需要完整的登陆流程的，就称为 login shell。举例来说，你要由 tty1 ~ tty6 登陆，需要输入使用者的帐号与密码，此时取得的 bash 就称为“ login shell ”啰；
- non-login shell：取得 bash 接口的方法不需要重复登陆的举动，举例来说，（1）你以 X window 登陆 Linux 后， 再以 X 的图形化接口启动终端机，此时那个终端接口并没有需要再次的输入帐号与密码，那个 bash 的环境就称为 non-login shell了。（2）你在原本的 bash 环 境下再次下达 bash 这个指令，同样的也没有输入帐号密码， 那第二个 bash （子程序） 也是 non-login shell 。



一般来说，login shell 其实只会读取这两个配置文件：

1. **/etc/profile**：这是系统整体的设置，你最好不要修改这个文件；

2. **~/.bash_profile** 或 **~/.bash_login** 或 **~/.profile**：属于使用者个人设置，你要改自己的数据，就写入这里！

- /etc/profile  ( login shell 才会读 ）

    主要包含：

    - PATH：会依据 UID 决定 PATH 变量要不要含有 sbin 的系统指令目录； 
    - MAIL：依据帐号设置好使用者的 mailbox 到 /var/spool/mail/帐号名；
    - USER：根据使用者的帐号设置此一变量内容； 
    - HOSTNAME：依据主机的 
    - hostname 指令决定此一变量内容
    - HISTSIZE：历史命令记录笔数。CentOS 7.x 设置为 1000 ；
    - umask：包括 root 默认为 022 而一般用户为 002 等！



- ～/.bash_profile (login shell 才会读 )

    1. ~/.bash_profile

    2. ~/.bash_login

    3. ~/.profile

    其实 bash 的 login shell 设置只会读取上面三个文件的其中一个， 而读取的顺序则是依照上面的顺序。

- ~/.bashrc （non-login shell会读）

    ![image-20200526225434363](http://picbed.yoyolikescici.cn/uPic/image-20200526225434363.png)

#### 2. source 

能不能直接读取配置文件而不登出登陆呢？ 可以的！那就得要利用 source 这个指令 了！

![image-20200526225333349](http://picbed.yoyolikescici.cn/uPic/image-20200526225333349.png)





### 4. 终端机的环境设置： stty, set

![image-20200526225613781](http://picbed.yoyolikescici.cn/uPic/image-20200526225613781.png)

- intr : 送出一个 interrupt （中断） 的讯号给目前正在 run 的程序 （就是终止啰！）； 
- quit : 送出一个 quit 的讯号给目前正在 run 的程序； 
- erase : 向后删除字符，
-  kill : 删除在目前指令列上的所有文字； 
- eof : End of file 的意思，代表“结束输入”。 
- start : 在某个程序停止后，重新启动他的 output
- stop : 停止目前屏幕的输出； 
- susp : 送出一个 terminal stop 的讯号给正在 run 的程序。



![image-20200526225936763](http://picbed.yoyolikescici.cn/uPic/image-20200526225936763.png)

| 组合按键 | 执行结果                               |
| -------- | -------------------------------------- |
| Ctrl + C | 终止目前的命令                         |
| Ctrl + D | 输入结束 （EOF），例如邮件结束的时候； |
| Ctrl + M | 就是 Enter 啦！                        |
| Ctrl + S | 暂停屏幕的输出                         |
| Ctrl + Q | 恢复屏幕的输出                         |
| Ctrl + U | 在提示字符下，将整列命令删除           |
| Ctrl + Z | “暂停”目前的命令                       |





### 5. 万用字符与特殊符号

| 符号 | 意义                                                         |
| ---- | ------------------------------------------------------------ |
| *    | 代表“ 0 个到无穷多个”任意字符                                |
| ?    | 代表“一定有一个”任意字符                                     |
| []   | 同样代表“一定有一个在括号内”的字符（非任意字符）。例如 [abcd] 代表“一定有一个字符， 可能是 a, b, c, d 这四个任何一 个” |
| [-]  | 若有减号在中括号内时，代表“在编码顺序内的所有字符”。例如 [0-9] 代表 0 到 9 之间的所有数字，因为数字的语系编码是连 续的！ |
| [^ ] | 若中括号内的第一个字符为指数符号 （^） ，那表示“反向选择”，例如 [^abc] 代表 一定有一个字符，只要是非 a, b, c 的其他 字符就接受的意思。 |



![image-20200526230035104](http://picbed.yoyolikescici.cn/uPic/image-20200526230035104.png)

| 符号  | 内容                                                         |
| ----- | ------------------------------------------------------------ |
| #     | 注解符号：这个最常被使用在 script 当中，视为说明！在后的数据均不执行 |
| \     | 跳脱符号：将“特殊字符或万用字符”还原成一般字符               |
| \|    | 管线 （pipe）：分隔两个管线命令的界定（后两节介绍）；        |
| ;     | 连续指令下达分隔符号：连续性命令的界定 （注意！与管线命令并不相同） |
| ~     | 使用者的主文件夹                                             |
| $     | 取用变量前置字符：亦即是变量之前需要加的变量取代值           |
| &     | 工作控制 （job control）：将指令变成背景下工作               |
| !     | 逻辑运算意义上的“非” not 的意思！                            |
| /     | 目录符号：路径分隔的符号                                     |
| >, >> | 数据流重导向：输出导向，分别是“取代”与“累加”                 |
| <, << | 数据流重导向：输入导向 （这两个留待下节介绍）                |
| ''    | 单引号，不具有变量置换的功能 （$ 变为纯文本）                |
| ""    | 具有变量置换的功能！ （$ 可保留相关功能）                    |
| ``    | 两个“ ` ”中间为可以先执行的指令，亦可使用 $（ ）             |
| （）  | 在中间为子 shell 的起始与结束                                |
| {}    | 在中间为命令区块的组合！                                     |



## 5. 数据流重导向

### 1. what

![image-20200527004115011](http://picbed.yoyolikescici.cn/uPic/image-20200527004115011.png)



#### 1. STDOUT & STDERR

**标准输出指的是“指令执行所回传的正确的讯息”，而标准错误输出可理解为“ 指令执行失败后，所回传的错误讯息”。**

数据流重导向可以将 standard output （简称 stdout） 与 standard error output （简称 stderr） 分别传送到其他的 文件或设备去，而分别传送所用的特殊字符则如下所示：

1. 标准输入　　（stdin） ：代码为 0 ，使用 < 或 << ；

2. 标准输出　　（stdout）：代码为 1 ，使用 > 或 >> ；

3. 标准错误输出（stderr）：代码为 2 ，使用 2> 或 2>> ；

![image-20200527190406313](http://picbed.yoyolikescici.cn/uPic/image-20200527190406313.png)

1. 该文件 （本例中是 ~/rootfile） 若不存在，系统会自动的将他创建起来，但是

2. 当这个文件存在的时候，那么系统就会先将这个文件内容清空，然后再将数据写入！

3. 也就是若以 > 输出到一个已存在的文件中，那个文件就会被覆盖掉啰！





那如果我想要**将数据累加**而不想要将旧的数据删除，那该如何是好？利用两个大于的符号 （>>） 就好啦！以上面的范例来说，你应该 要改成“ ll / >> ~/rootfile ”即可。

![image-20200527191241669](http://picbed.yoyolikescici.cn/uPic/image-20200527191241669.png)





#### 2.  /dev/null 垃圾桶黑洞设备与特殊用法

所以要将**错误讯息忽略掉而不显示或储存**呢？ 这个时候黑洞设备 /dev/null 就很重要了！这个 /dev/null 可以吃掉任何导向这个设备的信息喔！将上述的范例修订一下：

![image-20200527203958513](http://picbed.yoyolikescici.cn/uPic/image-20200527203958513.png)

**将正确与错误数据通通写入同一个文件**

![image-20200527223006887](http://picbed.yoyolikescici.cn/uPic/image-20200527223006887.png)

上述表格第一行错误的原因是，由于两股数据同时写入一个文件，又没有使用特殊的语法， 此时两股数据可能会交叉写入该文件内，造 成次序的错乱。



#### 3.  standard input ： < & <<

将原本需要由键盘输入的数据，改由文件内 容来取代”

![image-20200527223154093](http://picbed.yoyolikescici.cn/uPic/image-20200527223154093.png)

![image-20200528021941728](http://picbed.yoyolikescici.cn/uPic/image-20200528021941728.png)

这东西非常的有帮助！尤其是用在类似 mail 这种指令的使用上。 理解 < 之后，再来则是怪可怕一把的 << 这个连续两个小于的符号了。 他代表的是“**结束的输入字符**”的意思！举例来讲：“我要用 cat 直接将输入的讯息输出到 catfile 中， 且当由键盘输入 eof 时，该次输入就结束”

![image-20200528022109754](http://picbed.yoyolikescici.cn/uPic/image-20200528022109754.png)



### 2. 命令执行的判断依据： ;  , && , ||

#### cmd;cmd

![image-20200528022320939](http://picbed.yoyolikescici.cn/uPic/image-20200528022320939.png)

#### $?(指令回传值)    与&&    或||

若前一个指令执行的结果为正确，在 Linux 下面会回传 一个 $? = 0 的值

| 指令下达情况   | 说明                                                         |
| -------------- | ------------------------------------------------------------ |
| cmd1 && cmd2   | 1. 若 cmd1 执行完毕且正确执行（\$?=0），则开始执行 cmd2。<br>2. 若 cmd1 执行完毕且为错误 （\$?≠0），则 cmd2 不执行。 |
| cmd1 \|\| cmd2 | 1. 若 cmd1 执行完毕且正确执行（\$?=0），则 cmd2 不执行。<br>2. 若 cmd1 执行完毕且为错误 （​\$?≠0），则开始执行 cmd2。 |

![image-20200528022624077](http://picbed.yoyolikescici.cn/uPic/image-20200528022624077.png)

![image-20200528022640956](http://picbed.yoyolikescici.cn/uPic/image-20200528022640956.png)



## 6. 管线命令

这个管线命令“ | ”仅能处理经由前面一个指令传来的正确信息，也就是 standard output 的信 息，对于 stdandard error 并没有直接处理的能力。

![image-20200528022805167](http://picbed.yoyolikescici.cn/uPic/image-20200528022805167.png)

- 管线命令仅会处理 standard output，对于 standard error output 会予以忽略 
- 管线命令必须要能够接受来自前一个指令的数据成为 standard input 继续处理才行。



### 1. cut， grep

#### cut

![image-20200528022924919](http://picbed.yoyolikescici.cn/uPic/image-20200528022924919.png)

cut 主要的用途在于将“同一行里面的数据进行分解！”最常使用在分析一些数据或文字数据的时候！ 这是因为有时候我们会以某些字符 当作分区的参数，然后来将数据加以切割，以取得我们所需要的数据。



#### grep

刚刚的 cut 是将一行讯息当中，取出某部分我们想要的，而 grep 则是分析一行讯息， 若当中有我们所需要的信息，就将该行拿出来

![image-20200528054458976](http://picbed.yoyolikescici.cn/uPic/image-20200528054458976.png)



### 2. 排序： sort, wc, uniq

#### sort

![image-20200528054802391](http://picbed.yoyolikescici.cn/uPic/image-20200528054802391.png)



#### uniq

如果我排序完成了，想要将重复的数据仅列出一个显示

![image-20200528054917405](http://picbed.yoyolikescici.cn/uPic/image-20200528054917405.png)



#### wc

如果我想要知道 /etc/man_db.conf 这个文件里面有多少字？多少行？多少字符的话， 可以怎么做呢？其实可以利用 wc 这个指令来达成 喔！他可以帮我们计算输出的讯息的整体数据！

![image-20200528054940972](http://picbed.yoyolikescici.cn/uPic/image-20200528054940972.png)



### 3. 双向重导向： tee

![image-20200528055100974](http://picbed.yoyolikescici.cn/uPic/image-20200528055100974.png)

tee 会同时将数据流分送到文件去与屏幕 （screen）；而输出到屏幕的，其实就是 stdout ，那就可以让下个指令继续处理喔！



![image-20200528055127335](http://picbed.yoyolikescici.cn/uPic/image-20200528055127335.png)



### 4. 字符转换命令： tr,col, join ,paste, expand

#### tr

tr 可以用来删除一段讯息当中的文字，或者是进行文字讯息的替换！

![image-20200528055222723](http://picbed.yoyolikescici.cn/uPic/image-20200528055222723.png)



#### col

![image-20200528055418211](http://picbed.yoyolikescici.cn/uPic/image-20200528055418211.png)

虽然 col 有他特殊的用途，不过，很多时候，他可以用来简单的处理将 [tab]

#### join

是在处理“两个文件当中，有 "相同数 据 的那一行，才将他加在一起”的意思。

![image-20200528055743755](http://picbed.yoyolikescici.cn/uPic/image-20200528055743755.png)



#### paste

将两行贴在一起，且中间以 [tab] 键隔 开 而已！简单的使用方法：

![image-20200528060912549](http://picbed.yoyolikescici.cn/uPic/image-20200528060912549.png)



#### expand

这玩意儿就是在将 [tab] 按键转成空白键啦～可以这样玩

![image-20200528060939279](http://picbed.yoyolikescici.cn/uPic/image-20200528060939279.png)



### 5. 分区命令：split

将一个大文件，依据文件大小或行数来 分区，就可以将大文件分区成为小文件了

![image-20200528061129572](http://picbed.yoyolikescici.cn/uPic/image-20200528061129572.png)



### 6. 参数代换： xargs

xargs 是在做什么的呢？就以字面上的意义来看， x 是加减乘除的乘号，args 则是 arguments （参数） 的意思，所以说，这个玩意儿就 是在产生某个指令的参数的意思！ xargs 可以读入 stdin 的数据，并且以空白字符或断行字符作为分辨，将 stdin 的数据分隔成为 arguments 。 因为是以空白字符作为分隔，所以，如果有一些文件名或者是其他意义的名词内含有空白字符的时候， xargs 可能就会误判了～他的用法其实 也还满简单的！就来看一看先！

![image-20200528061206325](http://picbed.yoyolikescici.cn/uPic/image-20200528061206325.png)





会使用 xargs 的原因是， 很多指令其实并不支持管线命令，因此我们可以通过 xargs 来提供该指令引用 standard input 之用！

![image-20200528061227440](http://picbed.yoyolikescici.cn/uPic/image-20200528061227440.png)



### 7. 关于  -    的用途

在管 线命令当中，常常会使用到前一个指令的 stdout 作为这次的 stdin ， 某些指令需要用到文件名称 （例如 tar） 来进行处理时，该 stdin 与 stdout 可以利用减号 "-" 来替代， 举例来说：

![image-20200528061258089](http://picbed.yoyolikescici.cn/uPic/image-20200528061258089.png)

上面这个例子是说：“我将 /home 里面的文件给他打包，但打包的数据不是纪录到文件，而是传送到 stdout； 经过管线后，将 tar -cvf /home 传送给后面的 tar -xvf - ”。后面的这个 - 则是取用前一个指令的 stdout， 因此，我们就不需要使用 filename 了！这是很常见的例子喔！注 意注意！

