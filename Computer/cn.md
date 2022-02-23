---
title: 计算机网络 
date: 2021年12月15日 03:39:19
tags: 
- 读书笔记
- 计算机网络
- 黑皮书
categories: 
- 九阴真经
---

# 计算机和因特网
## 1.1什么是因特网
### 构成描述
#### 端系统通过通信链路和分组交换机连接到一起
<++>
### 服务描述

## 1.3 网络核心
### 1.3.1 分组交换
交换机两类: router & link-layer-switch
#### 1.3.1.1 存储转发传输(store-and-forward transmission)
交换机能够开始向输出链路传输该分组的第一个比特之前
#### 1.3.1.1排队时延和分组丢失
##### 排队时延(queuing delay)
##### 分组丢失(丢包packet loss)
#### 1.3.1.3 转发表和路由选择协议
### 1.3.2 电路交换
预留资源,而分组交换网络中资源不预留.  
#### 频分复用&时分复用
### 1.3.3 网络的网络
#### 存在点、多宿、对等(可产生IXP)

## 1.4 分组交换中的时延、丢包和吞吐量
### 处理时延、排队时延、传输时延、传播时延
### 1.4.2 排队时延与丢包
### 1.4.3 端到端时延
#### 1.4.4 计算机网络中的吞吐量
接入网带宽、核心网带宽、发送端,接收端带宽差异

## 1.5 协议层次及其服务模型
#### 1.5.1.1 协议分层
1. 应用层 -报文message
2. 运输层 -报文段segment
3. 网络层 -数据报datagram
4. 链路层 -帧frame
5. 物理层 

#### 1.5.1.2 OSI模型
- 表示层:使通信的应用程序能够解释交换数据的含义.包含数据压缩和数据加密(它们是自解释的)以及数据描述.
- 会话层:提供了数据交换的定界和同步功能.

### 1.5.2 封装


# 2. 应用层

### 2.1.3 可供应用程序使用的运输服务
1. 可靠数据传输
2. 吞吐量
3. 定时
4. 安全性

### 2.1.4 因特网提供的运输服务
#### TCP服务
##### 面向连接的服务
在应用层数据报文开始流动之前,TCP让客户和服务器互相交换运输层控制信息. 
##### 可靠的数据传送服务
通信进程能够依靠TCP,无差错、按适当顺序交付所有发送的数据.
#### UDP服务
### 2.1.5 应用层协议
- 交换的报文类型
- 各种报文类型的愈发
- 字段的语义
- 确定一个进程何时以及如何发送报文,对报文进行响应的规则

## Web和HTTP
### 2.2.2 持续和非持续连接的HTTP
### 2.2.3 HTTP报文格式
#### HTTP请求报文
```
GET /somedir/page1.html HTTP/1.1
Host: www.someschool.edu
Connection: close
User-agent: Mozilla/5.0
Accept-language: fr 
```
第一行:请求行(request line)
后继:首部行(header line)

##### 请求行
三个字段
1. 方法字段:
> GET、POST、HEAD、PUT、DELETE
2. URL字段:
3. HTTP版本字段

首部行后还有实体,post方法使用


#### HTTP响应报文
```
HTTP/1.1 200 OK
Date: Tue, 18 Aug 2015 15:44:04 GET
Server: Apache/2.2.3 (CentOS)
Last-Modified: Tue, 18 Aug 2015 15:11:03 GMT
Content-Length: 6821
Content-Type: text/html
```
状态行、首部行、实体体

##### 状态行
1. 协议版本字段
2. 状态码
> 200
>
> 301 moved permanently: 请求的对象已经被永久转移,新的URL定义在响应报文的location:首部行中,客户软件将自动获取新的URL.  
>
> 400 Bad Request: 一个通用差错代码,表示该请求不能被服务器理解
> 
> 404 Not Found: 被请求的文档不在服务器上
> 
> 505 HTTP Version Not Supported: 服务器不支持请求报文使用的HTTP协议版本.
3. 响应状态信息



### 2.2.4 用户与服务器的交换:cookie
四个组件:
1. HTTP响应报文中一个cookie首部行
2. HTTP请求报文中一个cookie首部行
3. 用户端系统中保留一个cookie文件
4. web站点的一个后端数据库.

### 2.2.5 Web缓存
CDN

### 2.2.6 条件GET方法
If-Modified-Since


## 2.3 电子邮件
用户代理  
邮件服务器  
简单邮件传输协议SMTP(Simple Mail Transfer Protocol)  

### 2.3.1 SMTP
在用SMTP传送邮件之前,需要将二进制多媒体数据编码为ASCII码,并且在使用SMTP传输后要求将相应的ASCII码邮件解码还原为多媒体数据.  
#### 三个区别(和HTTP)

### 2.3.3 报文格式
```
From : alice@crepes.fr
To: bob@hamburger.edu
Subject: Searching for the meaning of life.


``````
### 2.3.4 邮件访问协议
smtp只能推,不能拉,拉要通过pop3、http或者imap

#### 1.POP3 Post Office Protocol-Version 3
#### 2. IMAP Internet Mail Access Protocol 
imap 更复杂,功能更多,可以在服务器上分文件夹



## 2.4 DNS
定义:
1.一个由分层的DNS服务器实现的分布式数据库.
2.一个使得主机能够查询分布式数据库的应用层协议. 
prot 53

服务:
1. 主机名到IP地址的转换
2. 主机别名
3. 邮件服务器别名
4. 负载分配

### 2.4.2 DNS工作机理概述
集中式设计缺点:
- 单点故障
- 通信容量
- 远距离的集中式数据库
- 维护

#### 1. 分布式、层次数据库
- 根DNS服务器
- 顶级域(Top-Level Domain) TLD
- 权威DNS服务器

本地DNS服务器   
DNS缓存

### 2.4.3 DNS记录和报文
- A (主机名-IP)
- NS (域,域对应权威服务器主机名)
- CNAME  (别名对应规范主机名)
- MX (邮件服务器的规范主机名)

## 2.5 P2P文件分发
最稀缺优先  
疏通  

##  2.6 视频流和内容分发网(CDN)
### 2.6.2 HTTP和DASH
DASH(Dynamic Adaptive Streaming over HTTP)

### 2.6.3 内容分发网
2. 集群选择策略: 
- 地理上最为临近
- 实时测量(延迟和丢包)


## 2.7 套接字编程
### 2.7.1 UDP套接字编程
client 
```python

from socket import *
serverName = '127.0.0.1'
serverPort = 12000
clientSocket = socket(AF_INET, SOCK_DGRAM)
message = input('Input lowercase sentence:')
clientSocket.sendto(message.encode(),(serverName,serverPort))
modifiedMessage, serverAddress = clientSocket.recvfrom(2048)
print(modifiedMessage.decode())
clientSocket.close()
```

server:
```python
from socket import *
serverPort = 12000
# AF_INET指定ipv4,第二个参数指定UDP套接字.
serverSocket = socket(AF_INET, SOCK_DGRAM)
# 客户端没有底下这行代码,由操作系统完成.
serverSocket.bind(('', serverPort))
print("the server is ready to receive")
while True:
    message, clientAddress = serverSocket.recvfrom(2048)
    modifiedMessage = message.decode().upper()
    print(modifiedMessage)
    print(clientAddress)
    serverSocket.sendto(modifiedMessage.encode(), clientAddress)
```


