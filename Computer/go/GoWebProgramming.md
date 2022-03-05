# Chapter1 go和Web应用
## 1.1 用go构建web应用
- 可扩展 scalable
- 模块化 modular
- 可维护 maintainable
- 高性能 high-performance


### 1.1.1 go和可扩展web应用
- 垂直扩展 : 提升单台设备CPU数量或者性能
- 水平扩展 : 增加计算机的数量 


## 1.2 Web应用的工作原理
定义: 对客户端发送的HTTP请求做出响应,并且通过HTTP响应将HTML回传至客户端  

## 1.5 HTTP请求
### 1.5.1 请求方法

1. get
> 命令服务器返回指定的资源
2. HEAD
> 只返回首部
3. post
> 命令服务器将报文主体中的数据传递给URI指定的资源
4. put
> 命令服务器将报文主体中的数据设置为URI指定的资源  
5. delete
> 命令服务器删除URI指定的资源
6. trace
> 命令服务器返回请求本身  
7. options 
> 命令服务器返回它支持的HTTP方法列表
8. connect
> 命令服务器与客户端建立一个网络连接. ssl隧道开启HTTPS
9. patch
> 命令服务器使用报文主体中的数据对URI指定的资源进行修改

### 1.5.5 请求首部
- Accept
- Accept-Charset
- Authorization
- Cookie
- Content-Length
- Content-Type
- Host
- Referrer
- User-Agent


## 1.6 HTTP response 
- 一个状态行
- 0或n哥响应首部
- 一个空行
- 一个可选的报文主体


|状态码类型 | 作用 |
| --  |--- |
|1xx | 情报状态码.  告诉客户端已经收到请求并进行处理|
| 2xx | 成功状态码. 收到请求并成功处理. | 
|3xx| 重定向状态码.  2之后还要完成一些其他工作, 多用于url重定向 | 
| 4xx | 客户端错误状态码 .|
|5xx | 服务器错误状态码| 

#### 1.6.2 响应首部  
| 首部字段| 作用 | 
|-|-|
|Allow | 告知客户端服务器支持哪些请求方法|
|Content-Length | 响应主体的子节长度 |
|Content-Type| 如果响应包含可选主体,  这个就是主体内容的类型|
|Date| 以GMT格式记录当前时间|
|Location | 重定向时使用,告知下一个URL|
|Server| 返回响应的服务器的域名|
|Set-Cookie| 在客户端里面设置一个cookie|
|WWW-Authenticate| 告知客户端在Authorization请求首部里提供哪种类型的身份验证信息| 


## 1.7 URI 
<方案名称>:<分层部分>[?<查询参数>][#<片段>]
- 只有“方案名称”和“分层部分”是必须的
- 如果分层部分以//开头,说明包含了可选的用户信息,这些信息以@结尾,后跟分层路径


示例:   
 http://sausheong:password @www.example.com/docs/file?name=sausheong&location=singapore#summary

- ? 和 # 在URL中有特殊含义, 需要特殊转换
- 每个URL是一个单独的字符串,所以URL里面不能包含空格. 

## 1.8 HTTP/2简介
- HTTP1.x 是纯文本方式表示的,HTTP/2是一种二进制协议  
- 支持完全多路复用  
- 允许服务器将响应push到client


## 1.9 Web 应用的组成部分
1. 通过HTTP协议,以HTTP请求报文的形式获取客户端输入;
2. 对HTTP请求报文进行处理,并执行必要的操作;  
3. 生成HTML,并以HTML响应报文的形式将其返回给客户端
- 分成处理器(handler) 和 模板引擎(template engine) 两个部分 

### 1.9.1 处理器
用mvc模式来说,处理器既是控制器,也是模型.    


## 1.10 hello go
```go

package main

import (
	"fmt"
	"net/http"
)

func handler(writer http.ResponseWriter, request *http.Request) {
	fmt.Fprintf(writer, "Hello World, %s", request.URL.Path[1:])
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
```
- handler
> handler这个名字通常表示指定事件被触发之后,负责对事件进行处理的回调函数.
> 从request结构中提取信息,创建一个HTTP响应,最后通过ResponseWriter接口将响应返回给客户端.  

# Chapter2 ChitChat 论坛
## 应用设计

```html
http://<servername>/<handlername>?<parameters>
http://chitchat/thread/read?id=123
```
- 处理器的名字按层级划分:
> 位于名字最开头的是被调用模块的名字,之后跟着的是被调用子模块的名字,位于最末尾的是子模块中负责处理请求的处理器.  
- 参数 以url查询的形式传递给处理器,而处理器则会根据这些参数对请求进行处理. 
- 当请求到达服务器时,多路复用器(multiplexer)会对请求进行检查,并将请求重定向至正确的处理器进行处理. 处理器处理完成后将所得数据传递给模版引擎,模版引擎根据数据生成将要返回给客户端的HTML.   

## 2.3  数据模型
- User
> 用户信息
- Session
> 用户当前的登陆绘画
- Thread
> 论坛里面的帖子,每个帖子记录了多个论坛用户之间的对话
- Post
> 用户在帖子里面添加的回复


## 2.4 请求的接收预处理
### 2.4.1 多路复用器
```go
package main

import (
	"net/http"
)

func main() {
	mux := http.NewServeMux()
	files := http.FileServer(http.Dir("/public"))
	mux.Handle("/static/", http.StripPrefix("/static/", files))

	mux.HandleFunc("/", index)

	server := &http.Server{
		Addr:    "0.0.0.0:8000",
		Handler: mux,
	}
	server.ListenAndServe()
}

}

```


- mux 是net/http默认的多路复用器
- handleFunc 将针对给定URL的请求转发给指定的处理器, index  
- 所有处理器接收一个ResponseWriter和一个指向Request结构的指针作参数, 并且所有请求参数都可以通过放访问Request得到,所以程序不需要向处理器显式的传入任何请求参数. 

### 2.4.2 服务静态文件    
  FileServer 创建了一个能为指定目录中的静态文件服务的处理器,并且将这个处理器传递给了多路复用器的Handle函数. 
- stripprefix 去除前缀  
http://localhost/static/css/bootstrap.min.css   ->    
\< application root\>/css/bootstrap.min.css  

### 2.4.3 创建处理器函数
```go

func index(w http.ResponseWriter, r *http.Request){
	files := []string{"templates/layout.html",
        "templates/navbar.html",
	    "templates/index.html,"}
	templates := templates.Must(templates.ParseFiles(files...))
	threads, err := data.Threads();
	if err == nil{
		templates.ExecuteTemplate(w, "layout", threads)
	}

```

index 函数负责生成HTML并写入ResponseWriter中.

### 2.4.4 使用cookie进行访问控制
```go
func authenticate(w http.ResponseWriter, r *http.Request){
    r.ParseForm()
	user, _ := data.UserByEmail(r.PostFormValue("email"))
	if user.Password == data.Encrypt(r.PostFormValue("password"){
	    session := user.CreateSession()
		cookie := http.Cookie{
		    Name: "_cookie",
			Value : session.Uuid,
			HttpOnly: true,
		}
		http.SetCookie(w, &cookie) //将cookie添加到响应的首部里
		http.Redirect(w, r, "/", 302)
		}else{
		http.Redirect(w, r, "/", 302)
		})
}

type Session struct{
    Id int
	Uuid string
	Email string
	UserID int
	CreatedAt time.Time
}
```
核实用户身份之后,程序创建一个Session结构,并通过cookie把uuid存储到浏览器里,Session存储到数据库中  


## 2.5 使用模版生成html响应
```html

{{define "layout"}}
...
...
...
{{end}}
```

## 2.7 连接数据库
```go
Var Db *sql.DB

func init(){
var err error
Db, err = sql.Open("postgres", "dbname=chitchat sslmode=disable")
if err != nil{
    log.Fatal(err)
}
return 
}
```

# Chapter3 接收请求
## 3.1 net/http标准库

## 3.2 构建服务器
### 3.2.1 go web 服务器

```go
package main 
import (
    "net/http"
)

// simple :
func main(){
http.ListenAndServe("", nil)
}

// with config
func main(){
server := http.Server{
    Addr : "127.0.0.1:8080",
	Handler : nil,
}
    server.ListenAndServe()
}

// type server 
type Server struct {
    Addr string
	Handler Handler
	ReadTimeout time.Duration
	WriteTimeout time.Duration 
	MaxHeaderBytes int
	TLSConfig *tls.Config 
	TLSNextProto map[string]func(*Server, *tls.COnn, Handler)
	ConnState func(net.Conn, ConnState)
	ErrorLog *log.Logger
}
```
### 3.2.2 https
```go
package main 
import (
"net/http"
)

func main(){
server := http.Server{
    Addr:"127.0.0.1:8080",
	Handler: nil 
}
server.ListenAndServeTLS("cert.pem", "key.pem")  // 证书和私钥 
}
```

#### 生成个人使用的证书和服务器私钥:
```go
package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"math/big"
	"net"
	"os"
	"time"
)

func main() {
	max := new(big.Int).Lsh(big.NewInt(1), 128)
	serialNumber, _ := rand.Int(rand.Reader, max)
	subject := pkix.Name{
		Organization:       []string{"Manning Publications Co."},
		OrganizationalUnit: []string{"Books"},
		CommonName:         "Go Web Programming",
	}


// serialNumber 用于记录VA分发的唯一号码, 本程序采用随机生成的长整数
	template := x509.Certificate{
		SerialNumber: serialNumber,
		Subject:      subject,
		NotBefore:    time.Now(),
		NotAfter:     time.Now().Add(365 * 24 * time.Hour), // 有效期一年
		KeyUsage:     x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature, // 表明用于服务器身份验证操作
		ExtKeyUsage:  []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		IPAddresses:  []net.IP{net.ParseIP("127.0.0.1")}, // 设置为只能在IP *** 上运行 
	}

	pk, _ := rsa.GenerateKey(rand.Reader, 2048) // 生成私钥  , 其中包含了公钥   

	derBytes, _ := x509.CreateCertificate(rand.Reader, &template, &template, &pk.PublicKey, pk)  // 创建SSL证书时用到 公钥 
	certOut, _ := os.Create("cert.pem")
	pem.Encode(certOut, &pem.Block{
		Type: "CERTIFICATE", Bytes: derBytes,
	})
	certOut.Close()
    // 将密钥保存到key.pem里面  
	keyOut, _ := os.Create("key.pem")
	pem.Encode(keyOut, &pem.Block{
		Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(pk),
	})
	keyOut.Close()
  // 如果证书是由CA签发的,那么证书文件中将同时包含服务器签名和CA签名,服务器签名在前,CA在后  
}

```

##  3.3 处理器和处理器函数  
### 3.3.1 处理请求
-  一个处理器就是一个拥有ServerHTTP方法的接口,拥有两个参数:ResponseWriter和一个Request指针, 换句话说,任何接口只要拥有一个ServerHTTP方法,并且带有以下签名,就是一个处理器
-  DefaultServerMux 既是servemux结构的实例,也是handler的结构的实例.  不仅是一个多路复用器,还是一个处理器.  
 ```go
 ServerHTTP(http.ResponseWriter, *http.Request)
 ```

 ```go
 type MyHandler struct{}

 func (h *MyHandler) ServerHTTP(w http.ResponseWriter, r *http.Request){
     fmt.Fprintf(w, "Hello World!")
 }

 func main(){
     handler := MyHandler{}
     server := http.Server{
	     Addr: "127.0.0.1:8080",
	     Handler: &handler,
	 }

	 server.ListenAndServe()  
 }
 ```
### 3.3.2 使用多个处理器
这时候不用在Server的Handler字段中指定处理器,而是使用默认的DefaultServeMux作为处理器,然后通过http.Handle函数将处理器绑定至DefaultServeMux.  

```go
package main

import (
	"fmt"
	"net/http"
)

type HelloHandler struct{}

func (h *HelloHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello!")
}

type WorldHandler struct{}

func (h *WorldHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "World!")
}

func main() {
	hello := HelloHandler{}
	world := WorldHandler{}

	server := http.Server{
		Addr: "127.0.0.1:8080",
	}

	http.Handle("/hello", &hello)
	http.Handle("/world", &world)

	server.ListenAndServe()
}

```

### 3.3.3 处理器函数
```go
func hello(w http.ResponseWriter, r *http.request){
fmt.Fprintf(w,"hello!")
}

func main(){
    server := ...
	http.HandleFunc("/hello", htllo)
}
```

### 3.3.4 串联多个处理器和处理器函数

诸如日志记录、安全检查和错误处理这样的操作通常被称为<mark>横切关注点(cross-cutting concern)</mark> ,可以使用串联(chaining)技术分隔代码中的横切关注点.  
```go
//串联两个处理器函数
package main
import(
	"fmt"
	"net/http"
	"reflect"
	"runtime"
)

func hello(w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "Hello!")
}

func log(h http.HandlerFunc) http.HandlerFunc{
	return func(w http.ResponseWriter, r *http.Request ){
		name := runtime.FuncForPC(reflect.ValueOf(h).Pointer()).Name()
		fmt.Println("Handler function called -" + name)
		h(w, r)
	}
}

func main(){
	server := http.Server{
		Addr : "127.0.0.1:8080",
	}

	http.HandleFunc("/hello",log(hello))
	server.ListenAndServe()
}

```
lgog 函数返回一个匿名函数,这个匿名函数是一个HandlerFunc  

串联多个函数可以让程序执行更多动作,这种做法有时候也叫管道处理(pipeline processing)
```go
//串联多个处理器 
package main
import(
	"fmt"
	"net/http"
)
type HelloHandler struct{}

func (h HelloHandler) ServeHTTP (w http.ResponseWriter, r *http.Request){
	fmt.Fprintf(w, "Hello!")
}

func log(h http.Handler) http.Handler{
	return http.HandlerFunc (func(w http.ResponseWriter, r *http.Request){
		fmt.Printf("Handler called - %T\n", h)
		h.ServeHTTP(w,r)
	})
}

func protect(h http.Handler) http.Handler{
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request){
		 ... 
		 h.ServeHTTP(w,r )
	})
}

func main(){
	server := http.Server{
		Addr:"127.0.0.1:8080",
	}
	hello := HelloHandler()
	http.Handler("/hello", protect(log(hello)))
	server.ListenAndServe()
}

```
- log和protect不再返回匿名函数,而是使用HandlerFunc直接将匿名函数转换成一个Handler,然后返回这个Handler.
- 程序也不再直接执行处理器函数,而是调用处理器的ServeHTTP函数.  
- 程序现在绑定的是处理器而不是处理器函数. 


### 3.3.5 ServeMux和DefaultServeMux  
- ServeMux包含一个映射,这个映射将URL映射到相应的处理器
- DefaultServeMux是ServeMux的一个实例
- 如果被绑定的URL不是以/结尾,那只会与完全相同的URL匹配/hello
- 如果以/结尾,则即使只有前缀部分与绑定URL相同,也是认为这两个URL匹配 /hello/
 
### 3.3.6 使用其他多路复用器
- ServeMux的一个缺陷是无法使用变量使用URL模式匹配. 
- httpRouter


## 3.4 使用HTTP/2
- 需要调用http2包中的ConfigureServer方法,并将服务器配置传递给它
```go
package main

import (
	"fmt"
	"net/http"

	"golang.org/x/net/http2"
)

type MyHandler struct{}

func (h *MyHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "hello World!")
}

func main() {
	handler := MyHandler{}
	server := http.Server{
		Addr:    "127.0.0.1:8080",
		Handler: &handler,
	}

	http2.ConfigureServer(&server, &http2.Server{})
	server.ListenAndServeTLS("cert.pem", "key.pem")
}

```


# Chapter4 处理请求
## 4.1 请求和响应
### 4.1.1 Request结构
- URL字段;
- Header 
- Body
- Form、PostForm 和 MultipartForm  


### 4.1.2 请求URL
```go
type URL struct{
    Scheme string
	Opaque string 
	User *Userinfo
	Host string
	Path string
	RawQuery string
	Fragment String
}
```
URL 格式:  
scheme://[userinfo@]host/path[?query][#fragment]  
scheme后不带//的为 :   
scheme:opaque[?query][#fragment]

### 4.1.3 请求首部 


### 4.1.4 请求主体


## 4.2 Go与HTML表单
请求表单:
```html
<form action="/process" method = "post" enctype="application/x-www-form-urlencoded">
<input type="text" name="first_name"/>
<input type="text" name="last_name"/>
<input type="submit"/>
</form>
```
用户在表单中输入的数据会以键值对的形式记录在请求的主体中,然后以HTTP post请求的形式发送至服务器.  
html表单的内容类型(content type)决定了post请求在发送键值对时使用何种格式,由enctype属性指定.  
enctype属性默认为application/x-www-form-urlencoded  ,在这个情况下,浏览器将把表单中的数据编码为一个连续的“长字符串查询”:不同的键值使用&分隔,键和值用=分隔.  
first_name`=sau%20sheong&last_name=chang  `    
如果设置成multipart/form-data,则转换成MIME报文:每个键值对构成这条报文的一部分,并且每个键值对都带有它们各自的内容类型以及内容配置.   
```html
------ WebKitFromBoundaryMPNjKpe09cLiocMw
Content-Disposition: from-data; name="first_name"

sau sheong 
------WebKitFromBoundaryMPNjKpe09cLiocMw
Content-Disposition: form-data; name="last_name"

chang 
------WebKitFromBoundaryMPNjKpe09cLiocMw--  

```

选择:  
如果只是简单的文本数据,使用URL编码更好,简单、搞笑,计算量少  
大量数据用multipart好  ,特殊情况还可以用base64  

### 4.2.1 Form字段
使用Request结构的方法获取表单数据的一般步骤是:
1. 调用ParseForm方法或者ParseMultipartForm方法,对请求进行语法分析 . 
2. 根据1调用的方法,访问相应的Form字段、PostForm字段或者Multipart字段  

```go
package main
import (
    "fmt"
	"net/http"
)

func process(w http.ResponseWriter, r *http.Request){
    r.ParseForm()
	fmt.Fprintln(w, r.Form)
}

func main(){
server := http.Server{
    Addr: "127.0.0.1:8080",
}
http.HandlerFunc("/process", process)
server.ListenAndServe()
}
```

<++>

