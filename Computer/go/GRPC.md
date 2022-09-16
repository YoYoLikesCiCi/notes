远程过程调用(Remote Procedure Call)

> 在 gRPC 里客户端应用可以像调用本地对象一样直接调用另一台不同的机器上服务端应用的方法，使得您能够更容易地创建分布式应用和服务。与许多 RPC 系统类似，gRPC 也是基于以下理念：定义一个服务，指定其能够被远程调用的方法（包含参数和返回类型）。在服务端实现这个接口，并运行一个 gRPC 服务器来处理客户端调用。在客户端拥有一个存根能够像服务端一样的方法。

![](http://www.grpc.io/img/grpc_concept_diagram_00.png)
# 入门
##  hello world
```go
type HelloService sturct{}

func (p *HelloService) Hello(request string, reply *string) error{
    *replay = "hello:" + request
    return nil
}
```****

- Go语言的RPC规则:
   - 方法只能有两个可序列化的参数，其 中第二个参数是指针类型，并且返回一个error类型，同时必须是公开的方法。

接着将HelloService类型的对象注册成为一个RPC服务:
```go
func main(){
    rpc.RegisterName("HelloService", new(HelloService))

    listener, err := net.Listen("tcp", ":1234")
    if err != nil{
        log.Fatal("ListenTCP error", err)
    } 

    conn, err := listener.Accept()
    if err != nil{
        log.Fatal("Accept error:", err )
    }

    rpc.ServeConn(conn)
}
```

rpc.Register函数调用会将对象类型中所有满足RPC规则的对象方法注册为 RPC函数，所有注册的方法会放在“HelloService”服务空间之下。然后我们建立一个唯一的TCP链接，并且通过rpc.ServeConn函数在该TCP链接上为对方提供RPC服务.


客户端请求代码:
```go
package main

import (
	"fmt"
	"log"
	"net/rpc"
)

func main() {
	client, err := rpc.Dial("tcp", "localhost:1234")

	if err != nil {
		log.Fatal("dialing: ", err)
	}

	var reply string
	err = client.Call("HelloService.Hello", "From Client ", &reply)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(reply)

}

```
首先是通过rpc.Dial拨号RPC服务，然后通过client.Call调用具体的RPC方法。在调 用client.Call时，第一个参数是用点号链接的RPC服务名字和方法名字，第二和第 三个参数分别我们定义RPC方法的两个参数



## gRPC概念
<mark>定义一个服务,指定其可以被远程调用的方法及其参数和返回类型.</mark>


## gRPC允许定义四类服务方法
- 单项
- 服务流式RPC
- 客户流式RPC
- 双向流式RPCMarkdown Preview Enhanced


## 1.2 更安全的RPC接口
接口规范氛围三个部分:
- 服务的名字
- 服务要实现的详细方法列表
- 注册该类型服务的函数

```go
const HelloServiceName = "path/to/pkg.HelloService"

type HelloServiceInterface = interface {
    Hello(request string, reply *string) error 
}

func RegisterHelloService(svc HelloServiceInterface) error{
    return rpc.RegisterName(HelloServiceName, svc)
}
```

```go
//old client code 
err = client.Call("HelloService.Hello", "From Client ", &reply)
//new client code 
err = client.Call(HelloServiceName + ".Hello", "From Client ", &reply)
```