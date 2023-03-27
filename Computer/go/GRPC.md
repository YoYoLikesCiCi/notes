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
接口规范分为三个部分:
- 服务的名字
- 服务要实现的详细方法列表
- 注册该类型服务的函数

```go
//接口，api 定义部分
//服务的名字
const HelloServiceName = "path/to/pkg.HelloService"
//详细方法
type HelloServiceInterface = interface {
    Hello(request string, reply *string) error 
}
//注册该类型服务的函数  
func RegisterHelloService(svc HelloServiceInterface) error{
    return rpc.RegisterName(HelloServiceName, svc)
}


//对客户端的简单包装
type HelloServiceClient struct {
	*rpc.Client
}

var _ HelloServiceInterface = (*HelloServiceClient)(nil)

func DialHelloService(network, address string) (*HelloServiceClient, error) {
	c, err := rpc.Dial(network, address)
	if err != nil {
		return nil, err
	}
	return &HelloServiceClient{Client: c}, nil
}

func (p *HelloServiceClient) Hello(request string, reply *string) error {
	return p.Client.Call(HelloServiceName+".Hello", request, reply)
}
```

```go
//old client code 
err = client.Call("HelloService.Hello", "From Client ", &reply)
//new client code 
err = client.Call(HelloServiceName + ".Hello", "From Client ", &reply)
```

```go
//客户端结构定义, HelloServiceClient


func main() {
	client, err := Clients.DialHelloService("tcp", "localhost:1234")

	if err != nil {
		log.Fatal("dialing", err)
	}

	var reply string
	err = client.Hello("hello", &reply)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(reply)
}

```


```go
//服务端代码
func main() {
    api.RegisterHelloService(new(HelloService))	

	listener, err := net.Listen("tcp", ":1234")

	if err != nil {
		log.Fatal("ListenTCP error", err)
	}

	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Fatal("Accept error", err)
		}
		go rpc.ServeConn(conn)
	}

}
```

## 4.1.3 跨语言的RPC
```go
// client
func main() {
	conn, err := net.Dial("tcp", "localhost:1234")
	if err != nil {
		log.Fatal("net.dial: ", err)
	}
	client := rpc.NewClientWithCodec(jsonrpc.NewClientCodec(conn))
	var reply string
	err = client.Call("HelloService.Hello", "From Client ", &reply)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(reply)
}
```

在命令行开启一个监听服务查看客户端发送的数据格式：
nc -l 1234
结果：
{"method":"HelloService.Hello","params":["From Client "],"id":0}

```go
//serve
func main() {
	api.RegisterHelloService(new(Services.HelloService))
	listener, err := net.Listen("tcp", ":1234")
	if err != nil {
		log.Fatal("ListenTCP error", err)
	}
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Fatal("Accept error", err)
		}
		go rpc.ServeCodec(jsonrpc.NewServerCodec(conn))
	}
}
```

直接向假设了rpc服务的tcp服务器发送json数据模拟rpc方法调用
echo -e '{"method":"HelloService.Hello","params":["hello"],"id":1}' | nc localhost 1234
结果：
{"id":1,"result":"hellohello","error":null}

## 4.1.4 rpc on http
```go

func main() {
	rpc.RegisterName("HelloService", new(Services.HelloService))

	http.HandleFunc("/jsonrpc", func(w http.ResponseWriter, r *http.Request) {
		//构造一个io.readwritecloser 类型的conn通道，然后基于conn构建针对服务器端的json编码解码器  
		var conn io.ReadWriteCloser = struct {
			io.Writer
			io.ReadCloser
		}{
			ReadCloser: r.Body,
			Writer:     w,
		}
		rpc.ServeRequest(jsonrpc.NewServerCodec(conn))
	})
	http.ListenAndServe(":1234", nil)
}
```

模拟rpc调用：
curl localhost:1234/jsonrpc -X POST --data '{"method":"HelloService.Hello","params":["hello"],"id":0}'
结果：
{"id":0,"result":"hellohello","error":null}


# 4.2 Protobuf
```proto
syntax = "proto3"; //从用proto3的语法

package main;
option go_package = "./;proto";

message String{
  string value = 1;  //该成员编码时用编号1代替名字

}

service HelloService{
  rpc Hello (String) returns (String);
}
```

```shell
protoc --go_out=. hello.proto  
//需要grpc的情况下：
protoc --go_out=plugins=grpc:. hello.proto
```

生成的go代码：
```go

// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             v3.21.7
// source: hello.proto

package proto

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// HelloServiceClient is the client API for HelloService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type HelloServiceClient interface {
	Hello(ctx context.Context, in *String, opts ...grpc.CallOption) (*String, error)
}

type helloServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewHelloServiceClient(cc grpc.ClientConnInterface) HelloServiceClient {
	return &helloServiceClient{cc}
}

func (c *helloServiceClient) Hello(ctx context.Context, in *String, opts ...grpc.CallOption) (*String, error) {
	out := new(String)
	err := c.cc.Invoke(ctx, "/main.HelloService/Hello", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// HelloServiceServer is the server API for HelloService service.
// All implementations must embed UnimplementedHelloServiceServer
// for forward compatibility
type HelloServiceServer interface {
	Hello(context.Context, *String) (*String, error)
	mustEmbedUnimplementedHelloServiceServer()
}

// UnimplementedHelloServiceServer must be embedded to have forward compatible implementations.
type UnimplementedHelloServiceServer struct {
}

func (UnimplementedHelloServiceServer) Hello(context.Context, *String) (*String, error) {
	return nil, status.Errorf(codes.Unimplemented, "method Hello not implemented")
}
func (UnimplementedHelloServiceServer) mustEmbedUnimplementedHelloServiceServer() {}

// UnsafeHelloServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to HelloServiceServer will
// result in compilation errors.
type UnsafeHelloServiceServer interface {
	mustEmbedUnimplementedHelloServiceServer()
}

func RegisterHelloServiceServer(s grpc.ServiceRegistrar, srv HelloServiceServer) {
	s.RegisterService(&HelloService_ServiceDesc, srv)
}

func _HelloService_Hello_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(String)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(HelloServiceServer).Hello(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/main.HelloService/Hello",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(HelloServiceServer).Hello(ctx, req.(*String))
	}
	return interceptor(ctx, in, info, handler)
}

// HelloService_ServiceDesc is the grpc.ServiceDesc for HelloService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var HelloService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "main.HelloService",
	HandlerType: (*HelloServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "Hello",
			Handler:    _HelloService_Hello_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "hello.proto",
}

```

重新实现helloService服务：
```go
import "gRpcTest/proto"

type HelloService struct{}

func (p *HelloService) Hello(request proto.String, reply *proto.String) error {
	reply.Value = "hello:" + request.GetValue()
	return nil
}

```

## 4.2.2 定制代码生成插件

