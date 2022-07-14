  
# 入门
## 1.2 命令行参数  
```go
package main
import(
	"fmt"
	"os"
)

func main(){
	var s, sep string
	for i := 1; i < len(os.Args); i++ {
		s += sep + os.Args[i]
		sep = " "
	}
	fmt.Println(s)
}
```
> <mark>:=</mark> :用于短变量声明,声明一个或多个变量,并根据初始化的只给予合适的类型.

## 2.1 名称
实体的第一个字母的大小写决定其可见性是否跨包(大跨小不跨) 例如: fmt.Printf

## 2.2 声明
- 变量 var
- 常量 const
- 类型 type
- 函数 func


## 2.21 运算符
优先级:  
\* / % << >> & &^  
\+ - | ^   
\== != < <= > >=  
&&  
||

### 2.21.1 位运算符
| | | |
|-------|---|---|  
| AND     |     按位与：都为1   |  a&b  0101&0011=0001 |  
| OR      |     按位或：至少一个1  | a\\|b  0101\\|0011=0111  |  |
| XOR      |    按位亦或：只有一个1   |  a^b  0101^0011=0110  |
| NOT      |    按位取反   (一元)     |   ^a ^0111=1000  |  
| AND NOT  |    按位清除   (bit clear) |  a&^b 0110&^1011=0100  |  
| LEFT SHIFT  |  位左移       |    a<<2 0001<<3=1000   |  
| RIGHT SHIFT   |    位右移    |       a>>2 1010>>2=0010”  |  

- 位清除和位异或不同.它将左右操作数对应二进制位都为1的重置为0,以达到一次清除多个标记位的目的.  


### iota 
iota 是go语言的常量计数器， 只能在常量的表达式中使用。 
iota 在 const 关键字出现的时候将被重置为0. const中每新增一行常量声明将使 iota 计数一次 。 

```go
const(
    n1 = iota //0
	n2   //1
	n3  //2
	n4 //3
)
const(
	_ = iota //0
	KB = 1<<(10*iota)  // 1 << (10*1)
	MB 
	GB
)

//如果中断iota自增,则必须显式恢复.且后续自增按行序递增,而非C enum按上一取值递增
const(
	a  = iota  //int
	b float32 = iota  // float32
	c  = iota  //int 
)
```



## 2.3 短变量声明
- 短变量声明不需要声明所有在左边的变量.  
- 短变量声明最少声明一个新变量  

## 2.22 switch
``` go
func main(){
	a,b,c,x := 1,2,3,2

	switch x{  //多个匹配条件中其一即可
		case a,b:  //匹配变量
		println("a|b")  
		case c:
		println("c")
		case 4:
		println("d")
		default:
		println("z")
	}
}


```


# Chapter3 基本数据
四大类型:
- 基础类型 basic type 
  - 整数
  - 浮点数
  - 复数
  - 布尔值
  - 字符串
  - 常量
- 聚合类型 aggregate type 
  - 数组
  - slice
  - map
  - 结构体
- 引用类型 reference type 
- 接口类型 interface type 

## 3.5 字符串
### 3.5.1 转换
要修改字符串，必须将其转换为可变类型（[]rune or []byte），完成后再转换回来。不管如何转换，都要重新分配内存，并复制数据。

```go
func pp(format string, ptr interface{}){
	p := reflect.ValueOf(ptr).Pointer()
	h := (*uintptr)(unsafe.Pointer(p))
	fmt.Printf(format, *h)
}

func main(){
	s := "hello,world!"
	pp("s: %x\n", &s)

	bs := []byte(s)
	s2 := string(bs)

	pp("string to []bytes, bs: %x\n", &bs)
	pp("[]byte to string, s2: %x\n", &s2)

	rs := []rune(s)
	s3 := string(rs)

	pp("string to[]rune, rs: %x\n", &rs)
	pp("[]rune to string, s3:")
}
--------
s:ffe30
  
string to[]byte,bs:c82000a2f0
[]byte to string,s2:c82000a310
  
string to[]rune,rs:c820010280
[]rune to string,s3:c82000a340

--------------
```
## 5.4 字符串和字节slice
4个标准包对字符串操作特别重要: bytes、 strings、 strconv、 unicode
- strings包提供了许多函数,用于<mark>搜索、替换、比较、修整、切分和连接字符串</mark> . 
- bytes 包用于操作字节slice([]bytes类型,某些属性和字符串相同)  
- strconv 主要用于转换布尔值、整数、浮点数为与之对应的字符串形式.  
- unicode 包具备判别文字符号值特性的函数,如 IsDigit、 IsLetter、 IsUpper和IsLower.  
- 允许以索引号访问字节数组(非字符),但不能获取元素地址

Buffer类型:
```go

package main

import (
    "bytes"
    "fmt"
)

func intsToString(values []int) string {
	var buf bytes.Buffer
	buf.WriteByte('[')
	for i, v := range values {
		if i > 0 {
			buf.WriteString(", ")
		}
		fmt.Fprintf(&buf, "%d", v)
	}
	buf.WriteByte(']')
	return buf.String()
}

func main() {
	fmt.Println(intsToString([]int{1, 2, 3}))
}

```

# Chapter4 符合数据类型
## 4.1 数组

```go
//三种声明方式
var a [3]int
var b =  [3]int{1,2,3}
var c = [...]bool{true, false, true, false}
var d = [...]int{10,3:100}

c = d  // error , c和d不是同一个类型

for _, value := range cityArray{
 fmt.Println(value) 
}
```

- 长度不同的数组不属于同一类型
- 定义多维数组时,只有第一维度允许使用“...”
- go数组是值类型,不同于C,赋值和传参都会复制整个数组数据.
- 下标包头不包尾
- 内置函数len和cap都返回第一维长度  
- 如果元素类型支持“==、！=”操作符，那么数组也支持此操作
- Go中函数参数中的数组使用值传递.赋值和传参操作都会复制整个数组数据。  

- 对于结构等复合类型，可以省略元素初始化类型标签
```go 
func main(){
	type user struct{
		name string
		age byte
	}

	d := [...]user{
		{"Tom",20},
		{"Mary",18}
	}

	fmt.Printf("%#v\n",d)
}
```

## 4.2 slice
表示一个拥有相同类型元素的可变长度的序列.   
切片本身不是动态数组或数组指针。内部通过指针饮用底层数组，设定相关属性将数据读写操作限定在指定区域内。  
```go
type slice struct{
    array unsafe.Pointer  
	len int  
	cap int  
}
// cap 代表所引用数组片段的真实长度
//len用于限定可读的写元素数量  
```
```go
var array = [10]int{1,2,3,4,5,6,7,8,9,10}   //数组
var a []int //切片
var b = []int{1,2,3}  //切片
c := array[1:4]
d := array[0:len(array)]
e := make([]int, 5, 10)
a = append(a, 10)  //切片扩容 

array[2:5]  // [2 3 4] len:3 cap:8  
array[2:5:7]  // [2 3 4] len:3 cap:5  


// copy切片
f := make([]int, 5, 5)  //切片
copy(f,a)

// 切片的删除
a = append(a[0:2], a[3:]...) 删除第3个元素

```

- 切片初始化之后才能使用
- 三属性: 长度、容量、指针
- slice无法做比较
- slice类型的零值是nil, 检查是否为空用 len(s) == 0, 因为 s != nil 的情况下,slice也有可能是空.  
- 在旧切片截取出来的新切片,依旧指向原来的底层数组,修改对所有关联切片可见  
- 可以获取元素的地址，但不能用虽元素的指针访问元素内容
- 利用reslice，可以实现一个栈式数据结构： 
```go
func main(){
// 栈最大容量5
   stack:=make([]int,0,5) 
  
    // 入栈 
   push:=func(x int)error{ 
       n:=len(stack) 
       if n==cap(stack) { 
           return errors.New("stack is full") 
        } 
  
       stack=stack[:n+1] 
       stack[n] =x
  
       return nil
    } 
// 出栈 
pop:=func() (int,error) { 
    n:=len(stack) 
    if n==0{ 
        return 0,errors.New("stack is empty") 
     } 

    x:=stack[n-1] 
    stack=stack[:n-1] 

    return x,nil
 } 

 // 入栈测试 
for i:=0;i<7;i++ { 
    fmt.Printf("push%d: %v, %v\n",i,push(i),stack) 
 } 

 // 出栈测试 
for i:=0;i<7;i++ { 
    x,err:=pop() 
    fmt.Printf("pop: %d, %v, %v\n",x,err,stack) 
 } 
}

// 输出：
// push 0: <nil>, [0] 
// push 1: <nil>, [0 1] 
// push 2: <nil>, [0 1 2] 
// push 3: <nil>, [0 1 2 3] 
// push 4: <nil>, [0 1 2 3 4] 
// push 5:stack is full, [0 1 2 3 4] 
// push 6:stack is full, [0 1 2 3 4] 

// pop:4, <nil>, [0 1 2 3] 
// pop:3, <nil>, [0 1 2] 
// pop:2, <nil>, [0 1] 
// pop:1, <nil>, [0] 
// pop:0, <nil>, [] 
// pop:0,stack is empty, [] 
// pop:0,stack is empty, []
```

- 数据被追加到超过原底层数组，如果超过cap限制，则为新切片对象重新分配数组。  
  - 超出cap限制，而不是底层数组长度
  - 新分配数组长度是原来cap两倍，不是原来数组两倍
  - 并非总是2被，对于较大的切片，会尝试扩容1/4，以节约内存。  


## 4.3 map
```go
    var a map[string]int 
	c := make(map[string]int)
	var b := map[string]bool{
	    "1" : true, 
		"2" : false,
	}

	value, ok  := b["2"] // 判断某元素在不在map中
	delete( b, "2" )

```


- 键的类型k,必须是可以通过操作符==来进行比较的数据类型(点名slice)
- 运行时会对字典并发操作做出检测,如果冲突会导致进程崩溃
- 对字典进行迭代，每次返回的键值次序都不相同。  
- 因为内存访问和哈希算法等缘故，字典被设计成“not addressable”， 不能直接修改value成员。  正确做法是返回整个value,等修改后再设定字典键值,或者直接用指针类型.
- 
```go
func main(){
type user struct{
    name string 
	age byte 
}

    m := map[int]user{
        1:{"Tom",19}
}
    m[1].age += 1   //error : cannot assign to m[1].age  

    u := m[1]
    u.age += 1  
    m[1] = u   //set all the value  
    
	m2: = map[int]*user{ //value is pointer type  
	1 : &user("Jack", 20)
	}

	m2[1].age++  // m[2]1 return a pointer, you can change the value of the target object by poiter 

}
```

- 不能对空字典进行写操作,但是可以读.  
- 在迭代期间删除或新增键值是安全的.   
- 运行时会对字典并发操作做出检测.如果某个任务正在对字典进行写操作,那么其他任务就不能对该字典执行并发操作(读、写、删除),否则会导致进程崩溃.
- 字典对象本身就是指针包装,传参时无须再次取地址.  
## 4.4 结构体

```go
// 自定义类型
type MyInt int 
//类型别名 
type MyInt2 = int 

```

```go
type person struct{ 
 
    name, city string
	age    int
}
```


- 成员变量的顺序严格(成员变量顺序定义不同则为不同的结构体)
- 成员变量首字母大写则可导出
- 可以直接定义匿名结构类型变量,或者用作字段类型,但是因为缺少类型标识,作为字段类型时无法直接初始化. 
```go
func main(){
   u := struct{
       name string
       age byte
   }{
       name : "Tom",
       age : 12,
   }
    type file struct{
        name string
        attr struct{
            owner int
            perm int
        }
    }

    f := file {
        name :"test.dat",
        //attr :{     //error: missing type in composite literal 
        //.   owner : 1,
        //.   perm: 0755,},
        }
    f.attr.owner = 1 //the right way 
    f.attr.perm = 0755. 
    fmt.Println(u,f)
}
```
- 一个聚合类型不可以包含自己,但是可以定义一个指向自己的指针类型
- 结构体的零值由结构体成员的零值组成. 
- 按值调用,所以需要修改结构体内容的时候传参用指针
- 如果结构体的所有成员变量都是可比较的,那么这个结构体就是可比较的.
- 空结构(struct{})是没有字段的结构类型,无论是其自身,还是作为数组元素类型,其长度都是0. 可以作为通道元素类型,用于事件通知.  


  

### 4.4.3 结构体嵌套和匿名成员
- 指没有名字,仅有类型的字段
```go
type Person struct{
    string 
    int 
}

func main(){
    p1 := Person{
    string: "jj"
    int : 18
}
    fmt.Println(p1.string, p1.int)
}
```


- 结构体中可以定义不带名称的结构体成员,但其类型必须是<mark>命名类型</mark> 或者指向命名类型的指针. 
- 访问时可以直接通过.访问嵌套的子结构体变量,但是初始化时不能省略偷懒.
- 因为拥有隐式的名字,所以不能在一个结构体中定义两个相同类型的匿名成员.  
- 不能将基础类型和其指针类型同时嵌入,因为两者隐式名字相同.  
### 4.4.4 自定义类型
- 即使指定基础类型,只表明它们有相同底层数据结构,两者间不存在任何关系,属完全不同的两种类型.
- struct tag 也属于类型组成部分(有和没有是两种类型)
- 函数的参数顺序页数签名组成部分
### 4.5 json
- marshal 使用Go结构体成员的名称作为json对象里面字段的名称，只有可导出的成员可以转换为json字段。
```go

package main

import (
	"encoding/json"
	"fmt"
	"log"
)

//!+
type Movie struct {
	Title  string
	Year   int  `json:"released"`
	Color  bool `json:"color,omitempty"`
	Actors []string
}

var movies = []Movie{
	{Title: "Casablanca", Year: 1942, Color: false,
		Actors: []string{"Humphrey Bogart", "Ingrid Bergman"}},
	{Title: "Cool Hand Luke", Year: 1967, Color: true,
		Actors: []string{"Paul Newman"}},
	{Title: "Bullitt", Year: 1968, Color: true,
		Actors: []string{"Steve McQueen", "Jacqueline Bisset"}},
	// ...
}

//!-

func main() {
	{
		//!+Marshal
		data, err := json.Marshal(movies)
		if err != nil {
			log.Fatalf("JSON marshaling failed: %s", err)
		}
		fmt.Printf("%s\n", data)
		//!-Marshal
	}

	{
		//!+MarshalIndent
		data, err := json.MarshalIndent(movies, "", "    ")
		if err != nil {
			log.Fatalf("JSON marshaling failed: %s", err)
		}
		fmt.Printf("%s\n", data)
		//!-MarshalIndent

		//!+Unmarshal
		var titles []struct{ Title string }
		if err := json.Unmarshal(data, &titles); err != nil {
			log.Fatalf("JSON unmarshaling failed: %s", err)
		}
		fmt.Println(titles) // "[{Casablanca} {Cool Hand Luke} {Bullitt}]"
		//!-Unmarshal
	}
}

/*
//!+output
[{"Title":"Casablanca","released":1942,"Actors":["Humphrey Bogart","Ingr
id Bergman"]},{"Title":"Cool Hand Luke","released":1967,"color":true,"Ac
tors":["Paul Newman"]},{"Title":"Bullitt","released":1968,"color":true,"
Actors":["Steve McQueen","Jacqueline Bisset"]}]
//!-output
*/

/*
//!+indented
[
    {
        "Title": "Casablanca",
        "released": 1942,
        "Actors": [
            "Humphrey Bogart",
            "Ingrid Bergman"
        ]
    },
    {
        "Title": "Cool Hand Luke",
        "released": 1967,
        "color": true,
        "Actors": [
            "Paul Newman"
        ]
    },
    {
        "Title": "Bullitt",
        "released": 1968,
        "color": true,
        "Actors": [
            "Steve McQueen",
            "Jacqueline Bisset"
        ]
    }
]
//!-indented
*/
```



## 4.6 文本和HTML模板
- text/template , html/template
- 模板是一个字符串或者文件，包含一个或者多个两边用双大括号包围的单元——{{...}},这称为操作。


## 4.7 字段标签
- 不是注释,是用来对字段进行描述的元数据,尽管不属于数据成员,确是类型的组成部分.
- 可用反射获取标签信息,常被用作格式校验,数据库关系映射等.  
```go
type user struct{
    name string `昵称`
    sex byte `性别`
}

func main(){
    u := user{"Tom",1}
    v := reflect.ValueOf(u)
    t := v.Type()
    for i,n := 0, t.NumField(); i < n; i++{
        fmt.Printf("%s: %v\n",t.Field(i).Tag, v.Field(i))}
}
--------output:
昵称:Tom
性别:1
```

# Chapter5 函数
## 5.1 函数声明
```go
func intSum(a int, b int) int {
    ret := a+b
	return ret
}
// 可变参数，固定参数和可变参数同时出现时，可变参数要放在最后
// 变参本质上是一个切片,只能接受一到多个同类型参数
func intSum2(a ...int) int {
    ret := 0
	for _, arg := range a {
	    ret = ret + arg 
	}
	return ret 
}
```
```go
func main(){ // 匿名函数
    ... 
	var user struct{
	name string
	married bool 
	}
	user.name = "9ii"
}
```
- Go语言没有默认参数值的概念也不能指定实参名。
- 按值传递
- 有些函数的声明没有函数体，说明这个函数使用了Go以外的语言实现。
- 一个函数如果有命名的返回值，可以省略return语句的操作数，被称为裸返回。
- 函数是第一类对象，具备相同签名（参数和返回值列表）的视作同一类型。
- 第一类对象指可在运行期创建，可用作函数参数或返回值，可存入变量的实体。最常见的用法就是匿名函数。  


- 使用命名类型更加方便
```go
type FormatFunc func(string, ...interface{}) (string,error)
//如果不使用命名类型，参数签名会很长
func format(f FormatFunc, s string, a...interface{})(string, error){
	return f(s,a...)
}
```

## 5.4 错误处理
```go
// 标准库将error定义成接口类型,以便实现自定义错误类型
type error interface{
	Error() string
}

var errDivByZero = errors.New("division by zero")

func div(x,y int)(int,error ){
	if y == 0{
		return 0,errDivByZero
	}
	return x/y, nil
}

func main(){
	z,err := div(5,0)
	if err == errDivByZero{
		log.Fatalln(err)
	}
	println(z)
}
```


## 5.5 函数变量
- 函数零值是nil
- 函数变量可以和空值比较
- 函数变量本身不可比较
- 函数变量是的函数不仅将数据进行参数化，还将函数的行为当作参数进行传递。

- 不管是指针、引用类型，还是其他类型参数，都是值拷贝传递。区别无非是拷贝目标对象，还是拷贝指针。函数调用前，回味形参和返回值分配内存空间，并将实参拷贝到形参内存。

## 5.6 匿名函数
指没有定义名字符号的函数  
```go
sayHello := func(){
    fmt.Println("匿名函数")
}

//或者

func(){
     fmt.Println("匿名函数")
}()

//闭包 
// 闭包 = 函数 + 外层变量的引用(引用环境)
func a() func() {
    return func(){
        fmt.Println("something")
}
}

func makeSuffixFunc(suffix string) func(string) string{
    return func(name string string{	
        if !strings.HasSuffix(name, suffix) {
   			return name + suffix
		}
		return name
	}
}
```

```go
func calc(base int) (func(int), func(int) int){
add := func(i int) int{
    base += i 
	return base 
}
sub := func(i int) int { 
    base -= i 
	return base 
}
return add, sub 
}

func main(){
    f1, f2 := calc(10)
	fmt.Println(f1(1), f2(2)) // 11 , 9
	fmt.Println(f1(3), f2(4)) // 12 , 8
	fmt.Println(f1(5), f2(6)) // 13 , 7

}
```



- 函数字面量就行函数声明，但在func关键字后面没有函数的名称。
- 用这种方式定义的函数能够获取到整个词法环境，因此里层的函数能够使用外层函数中的变量。 


## 闭包
```go 
func test(x int)func(){
	return func(){
		println(x)
	}
}

func main(){
	f := test(123)
	f()
}
```
## 捕获迭代变量 p109

## 5.7 变长函数
在参数列表最后的类型名称之前使用省略号"..."表示声明一个变长函数，调用这个函数的时候可以传递该类型任意数目的参数。 
```go
func sum(vals ...int) int {
    total := 0
	for _, val := range vals{
	total += val 
	}
	return total
}
```

## 5.8 defer延迟函数调用
- 延迟执行的函数在return语句之后执行，并且可以更新函数的结果变量。 
- 最先defer的语句最后执行，最后defer的语句最先执行 
- 延迟调用开销挺大
- 延迟调用注册的是调用，必须提供执行所需参数。参数值在注册时被复制并被缓存起来。如果对状态敏感，可改用指针或闭包。
```go
func main(){
	x,y := 1,2

	defer func(a int){
		println("defer x,y= ", a, y)
	}(x)

	x+= 100
	y+= 200
	println(x,y)
}
-------
101 202
defer x,y=1 202
-------
```
## 5.9 panic 宕机
当宕机发生时，所有的延迟函数以倒序执行，从栈最上面的函数开始一直返回到main函数。 

## 5.10 recover 恢复
- 不应该尝试恢复从另一个包内发生的宕机。 


## 5.21 函数参数
### 5.21.1 变参
- 将切片作为变参时，必须进行展开操作，如果是数组，先将其转换为切片。 
- 
# Chapter6 方法
## 6.1 方法声明
```go
func (p Point) Distance(q Point) float64{
    return math.Hypot(q.X - p.X, q.Y - p.Y)
}
package main

import (
	"fmt"
	"math"
)
--------------------------------------------
type Vertex struct {
	X, Y float64
}

func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	v := Vertex{3, 4}
	fmt.Println(v.Abs())
}


```
- 每一个类型都有自己的命名空间
- GO语言中方法可以绑定到任何类型上,内建类型需要重新命名. 

- receiver的类型是指针还是基础类型关系到调用时对象实例是否被复制
```go
type N int

func(n N)value(){
    n++ 
    fmt.Printf("v: %p, %v\n", &n,n)
}

func(n*N) pointer(){
    (*n)++
    fmt.Printf("p: %p, %v\n", n ,*n)
    }

func main(){
    var a N = 25 
    a.value()
    a.pointer()

    fmt.Printf("a: %p, %v\n", &a, a)
}

--------output:
v:0xc8200741c8,26            //receiver被复制 
p:0xc8200741c0,26
a:0xc8200741c0,26

```

## 6.2 指针接收者的方法
- 实参形参尽量保证同类型的变量


## 6.3 通过结构体内嵌组成类型
类似继承  

## 6.4 方法变量
- 把方法变成一个变量，可以省略接收者 


## 6.5 位向量
得看

## 6.6 封装
如果变量或者方法是不能通过对象访问到的，称作<mark>封装</mark> 的变量或者方法. 
- GO语言只有一种方式控制命名的可见性:定义的时候(首字母大小写)
- 要封装一个对象,必须使用结构体.  
- Go语言中封装的单元是包而不是类型. 结构体类型内的字段对于同一个包中的所有代码都是可见的. 

## 6.7 方法集
类型有一个与之相关的方法集,决定了它是否实现某个接口.  

> 类型T方法集包含所有receiver T方法。
> 类型*T方法集包含所有receiver T+*T方法。
>匿名嵌入S，T方法集包含所有receiver S方法。
>匿名嵌入*S，T方法集包含所有receiver S+*S方法。
>匿名嵌入S或*S，*T方法集包含所有receiver S+*S方法。”

```go 
type S struct{}
type T struct{
    S
}

func(S) sVal() {}
func(*S) sPtr() {}
func(T) tVal()  {}
func(*T) tPtr()  {}

func methodSet(a interface{}){  //显示方法集里所有方法名字
    t:=reflect.TypeOf(a) 

    for i,n:=0, t.NumMethod(); i<n; i++{
        m:=t.Method(i)
        fmt.Println(m.Name, m.Type)
    }
}

func main(){
    var t T
    methodSet(t)
    println("--------")
    methodSet(&t)
}
----------output:
sVal func(main.T) 
tVal func(main.T) 
---------------------- 
sPtr func(*main.T) 
sVal func(*main.T) 
tPtr func(*main.T) 
tVal func(*main.T)
```

方法集仅影响接口实现和方法表达式转换,与通过实例或实例指针调用方法无关.实例并不适用方法集,而是直接调用. 

- 匿名字段是为方法集准备的.
- “封装”、“继承”和“多态”, go仅实现了部分特征,更倾向于“组合优于继承”. 将模块分解成相互独立的更小单元,分别处理不同方面的需求,最后以匿名嵌入方式组合到一起,共同实现对外接口. 
- 组合没有父子依赖,不会破坏封装. 整体和局部松耦合，可以任意增加来实现扩展。 


## 6.8 表达式

# Chapter7 接口
- 接口是一种抽象类型(把它当作一种类型)
- 更像是一种协议(swift protocol)
- 只要一个类型实现了一个接口的所有方法,就说这个类型实现了某个接口
- 使用值接收者实现接口:类型的值和类型的指针都能够保存到接口变量中
- 所有类型都实现了空接口, 空接口可以存储任何值,
 > 空接口作为函数的参数  
 > 空接口可以作为map的value
 ```go
 var m = make(map[string]interface{}, 16)
 m["name"]= "liBai"
 m["age"] = 18
 m["hobby"] = []string{"basketball", "soccer", "table tennis"}

 ```

-  不能有字段
- 不能定义自己的方法
- 只能声明方法，不能实现。
- 可嵌入其他接口类型。

```go
// code of the book
package main

import (
	"fmt"
	"math"
)

type Abser interface {
	Abs() float64
}

func main() {
	var a Abser
	f := MyFloat(-math.Sqrt2)
	v := Vertex{3, 4}

	a = f  // a MyFloat 实现了 Abser
	a = &v // a *Vertex 实现了 Abser

	// 下面一行，v 是一个 Vertex（而不是 *Vertex）
	// 所以没有实现 Abser。
	a = v

	fmt.Println(a.Abs())
}

type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

type Vertex struct {
	X, Y float64
}

func (v *Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}





//code of go语言学习笔记
type tester interface{ 
   test() 
   string()string
} 
  
type data struct{} 
  
func(*data)test() {} 
func(data)string()string{return"" } 
  
func main() { 
   var d data
  
    //var t tester=d  // 错误:data does not implement tester
             //    (test method has pointer receiver) 
  
   var t tester= &d
   t.test() 
   println(t.string()) 
}
// 编译器根据方法集来判断是否实现了接口，上面的例子中只有*data才符合tester的要求。

```

## 嵌入接口
嵌入其他接口类型，相当于将其声明的方法集导入
```go
type stringer interface{
    string() string
}
type tester interface{
    stringer  //嵌入其他接口
    test()
}

type data struct{}

func(*data)test() {}
func(data)string()string{
    return ""
}

func main(){
    var d data
    var t tester = &d
    t.test()
    println(t.string())
}
```
## 7.5 接口值
- 一个接口类型的值分为两个部分: 一个具体类型 和 该类型的一个值. 称为接口的<mark>动态类型</mark> 和<mark>动态值</mark> . 

## 7.10 接口断言(类型断言)
-
```go
package main
import(
    "fmt" 
)

type cat struct{}
func (c cat) say(){
    fmt.Println("miaomiaomiao")
}

type dog struct{}
func (d dog) say(){
    fmt.Println("wangwangwang")
}

type sayer interface{
    say()
}

func da(arg sayer){
    arg.say()
}

func main(){
    c1 := cat{}
	da(c1)
	d1 := dog{}
	da(d1)

}
```

```go
type interfaceName interface{
    funcName1(arglist1) returnList1
	funcName2(arglist2) returnList2
	... 
}
```


```go
package main

import "fmt"

func findType(i interface{}) {
    switch x := i.(type) {
    case int:
        fmt.Println(x, "is int")
    case string:
        fmt.Println(x, "is string")
    case nil:
        fmt.Println(x, "is nil")
    default:
        fmt.Println(x, "not type matched")
    }
}

func main() {
    findType(10)      // int
    findType("hello") // string

    var k interface{} // nil
    findType(k)

    findType(10.23) //float64
}


```

# Chapter8 goroutine 和通道 channel
## 8.1 goroutine
关键字go并非执行并发操作，而是创建一个并发任务单元。新建任务被放置在系统队列中，等待调度器安排合适系统线程去获取执行权。当前流程不会阻塞，不会等待该任务启动，且运行时也不保证并发任务的执行次序。

  每个任务单元除保存函数指针、调用参数外，还会分配执行所需的栈内存空间。相比系统默认MB级别的线程栈，goroutine自定义栈初始仅须2 KB，所以才能创建成千上万的并发任务。自定义栈采取按需分配策略，在需要时进行扩容，最大能到GB规模。

  在不同版本中，自定义栈大小略有不同。如未做说明，本书特指1.6 amd64。

```go
package main 
import(
	"fmt"
	"time"
)

func task(id int){
	for i := 0; i < 5 ; i++{
		fmt.Printf("%d: %d\n",id, i)
		time.Sleep(time.Second)
	}
}

func main(){
	go task(1)
	go task(2)

	time.Sleep(time.Second*6)
}
// 1:0
// 2:0
// 1:1
// 2:1
// 1:2
// 2:2
---------------
var wg sync.WaitGroup

func hello() {
	fmt.Println("hello someone")
	wg.Done()
}

func main() {
	wg.Add(1)
	go hello()    
	fmt.Println("hello main")
	wg.Wait()

}

```

## wait
进程退出时不会等待并发任务结束，可用channel阻塞，然后发出退出信号。
```go
func main(){
    exit := make(chan struct{})  //创建通道，仅是通知，所以数据没有实际意义
    go func(){
        time.Sleep(time.Second)
        println("goroutine done.")
        close(exit)  //关闭通道，发出信号
    }()
    println("main...") -< exit  //如果通道关闭，立即解除阻塞
    println("main exit.")
}
-----------output:
main...
goroutine done.
main exit. 
```

如果要等待多个任务结束，可以使用sync.WaitGroup。通过设定计数器，让每个goroutine在退出前递减，直至归零时解除阻塞。 

```go
import(
    "sync"
    "time"
)
func main(){
    var wg sync.WaitGroup
    for i:=0;i<10;i++{
        wg.Add(1)
        go func(id int){
            defer wg.Done()
            time.Sleep(time.Second)
            println("goroutine",id,"done.")
        }(i)
    }
    println("main...")
    wg.wait()  //阻塞，直到技术归零。
    println("main exit.")
}
--------output:
main...
goroutine 9 done. 
goroutine 4 done. 
goroutine 2 done. 
goroutine 6 done. 
goroutine 8 done. 
goroutine 3 done. 
goroutine 5 done. 
goroutine 1 done. 
goroutine 0 done. 
goroutine 7 done. 
main exit.
```

## GOMAXPROCS
运行时可能会创建很多线程，但任何时候仅有限的几个线程参与并发任务执行。该数量默认与处理器核数相等，可用runtime.GO-MAXPROCS函数（或环境变量）修改。

## 8.4 channel 

- channel 是一种类型,一种引用类型
- var someChannel chan type
- channel 与 goroutine搭配,实现用通信代替内存共享的CSP模型.


```go
var ch1 chan int 
var ch2 chan bool
var ch3 chan string
// make(chan type, [缓冲大小])
ch4 := make(chan int) 

```

支持3种操作
1. 发送 send   
ch <- 10  
// >
2. 接收 receive  
x := <- ch  
// >
3. 关闭 close     
close(ch)    


### 8.4.1 无缓冲通道
```go
func f1(ch chan<- int){
// chan<-  限制只能向通道发送内容
for i := 0; i < 100; i++{
    ch <- i 
}
close(ch)
}

func f2(ch1 <-chan int, ch2 chan<- int){
// 限制只能从ch1里面取, 向ch2里发送
    temp := <- ch1
	// way1 of fetch value from channel 
	for{
	tem, ok := <- ch1
	if !ok{
	break
	}
	ch2 <- temp*temp 
	}
	close(ch2) 
}

func main(){
    ch1 := make(chan int, 100)
	ch2 := make(chan int, 200)

	go f1(ch1)
	go f2(ch2)

	// wat2 of fetch value from channel 
	for ret := range ch2{
	fmt.Println(ret)
	}
}

```

## workpool模式

```go 
func worker(id int, jobs<-chan int, results chan<- int){
for job := range jobs {
    fmt.Printf("worker:%d start jbo:%d\n", id, job)
	results <- job*2 
	time.Sleep(time.Millisencond*500)
	fmt.Printf("worrker:%d stop jbo:%d \n", id, job )
}
}
func main(){
    jbos := make(chan int , 100)
	results := make(chan int, 100)
    
	for j := 0; j < 3; j++{
	go worker(j, jobs, results)
	}

	for i := 0; i < 5; i++{
	jobs <- i 
	}
	close(jobs)

	for i := 0; i < 3; i++{
	ret := <- results
	fmt.Println(ret)
	}
```

## 8.7 select 多路复用
- 如果多个情况同时满足,select会随机选择一种

```go
func main(){
ch := make(chan int, 1)
for i := 0; i < 10; i++{
select{
    case x:= <-ch:
	fmt.Println(x)
	case ch<-i:

	defalut:
	fmt.Prinln("nothing")

	// 0,2,4,6,8
}
}
}
```

# Chapter9 使用共享变量实现并发

## 9.2 互斥锁: sync.Mutex

```go
var (
x int64
wg sync.WaitGroup
lock sync.Mutex
)

func add(){
for i := 0; i < 5000; i++{
    lock.Lock()
	x = x + 1
	lock.Unlock() 
}
wg.Done() 
}

func main(){
    wg.Add(2)
	go add()
	go add()
	wg.Wait()
}
```

## 9.3 读写互斥锁: sync.RWMutex 

```go
var(
    x int64
	wg sync.WaitGroup
	lock sync.Mutex 
	rwlock sync.RWMutex 
)

func write(){
    //lock.Lock()
	rwlock.Lock()
	x = x + 1
	time.Sleep(10 * time.Millisencond)
	rwlock.Unlock()
	//lock.Unlock()
	wg.Done() 
}

func read(){
//lock.Lock()
    rwlock.Rlock()
	time.Sleep(time.Millisencond)
	rwlock.Runlock()
	//lock.Unlock()
	wg.Done()
}

func main(){
    start := time.Now()
	for i := 0; i < 10; i++{
	wg.Add(1)
	go write()
	}

	for i := 0; i < 1000 ; i++{
	wg.Add(1)
	go read()
	}

	wg.Wait()
	end := time.Now()
	fmt.Println(end.Sub(start))
}
```

## 9.5 延迟初始化
只执行一次的操作,例如只加载一次配置文件、只关闭一次通道等等. 
只有一个do 方法  
func(o *Once) Do(f func()) {}


## map不安全
安全的map:
```go

```

<++>


# Chapter10 包和go工具

## 10.3 包的声明 
```go
import(
    "crypto/rand"
	mrand "math/rand"  //两个名字一样的包需要指定别名来避免冲突 
)
```

# Chapter12 反射
定义: 在编译时不知道类型的情况下,可更新变量、在运行时查看值、调用方法以及直接对它们的布局进行操作. 

## 12.1 why?
想想 Println 打印自定义的类型时的代码应该怎么写 

## 12.2 reflect.Type 和 reflect.Value

- reflect.Type 接受任何的interface{}参数, 并且把接口中的动态类型以reflect.Type形式返回
```go
t := reflect.TypeOf(3)  // a reflect.Type
fmt.Println(t.String()) // int
fmt.Println(t.Name())  // 类型 , 像数组、切片、map、指针等类型的变量, 返回为空  
fmt.Println(t.Kind())  //底层的类型 
fmt.Println(t) // int
```

- reflect.Value可以包含任意一个类型的值 ,它的返回值也是具体的值
```go
v := reflect.ValueOf(3) 
fmt.Println(v) // "3"
fmt.Println("%v\n",v)  //"3"
fmt.Println(v.String()) // "<int Value>"
```

- reflect.Value 的逆操作 reflect.Value.Interface()
```go
v := reflect.ValueOf(3) // a reflect.Value
x := v.Interface() // an interface
i := x.(int)  // an int
fmt.Printf("%d\n", i) // "3"
```
## 12.5 使用reflect.Value设置值
```go
x := 2 // is value type var?
a := reflect.ValueOf(2)  // 2 int no
b := reflect.ValueOf(x) // 2 int no 
c := reflect.ValueOf(&x) // &x *int no 
d := c.Elem() // 2 int yes(x)

fmt.Println(a.CanAddr())  // false 
...
...
d.CanAddr() // true 
```
- 从一个可寻址的reflect.Value()获取变量需要三步 
1. 调用Addr(),返回一个Value,其中包含一个指向变量的指针 
2. 在这个value上调用Interface() , 返回一个包含这个指针的interface{}值. 
3. 如果知道变量的类型,就可以使用类型断言把接口内容转换成一个普通指针,然后通过指针来更新变量. 
```go
x := 2 
d := reflect.ValueOf(&x).Elem()  // d 代表变量x
px := d.Addr().Interface().(*int) // px := &x
*px = 3 // x = 3
fmt.Println(z)  // "3"

```


## 12.7 访问结构体字段标签
- 与结构体有关的方法

	|方法|说明|
	| ---|---|
	|Field(i int) StructField| 根据索引,返回索引对应的结构体字段的信息.|
	|NumField() int |返回结构体成员的字段数量| 
	|FieldByName(name string)(StructField, bool) | 根据给定字符串返回字符串对应的结构体字段的信息 |
	|FieldByIndex(index []int) StructField|多层成员访问时,根据[]int提供的每个结构体的字段索引,返回字段的信息|
	|FieldByNameFunc(match func(string) bool)(StructField, bool)| 根据传入的匹配函数匹配需要的字段|
	|NumMethod() int| 返回该类型中方法集中方法的数目|
	| Method(int) Method | 返回该类型中方法集中的第i个方法|
	|MethodByName(string) (Method, bool) | 根据方法名返回该类型方法集中的方法 |

- structField类型
```go
type StructField struct{
    Name string
	PkgPath string
	Type Type
	Tag StructTag
	Offset uintptr
	Index []int
	Anonymous bool 
}
```
```go
type student struct{
    Name string `json:"name"`
	Score int `json:"score"`
}

func main(){
stu1 := student{
    Name : "prince"
	Socre : 90
}

t := reflect.TypeOf(stu1)
fmt.Println(t.Name(), t.Kind()) // student, struct 

for i := 0; i < t.NumField(); i++ {
     field := t.Field(i)
	 fmt.Printf("name:%s index:%d type:%v json tag:%v\n", field.Name, field.Index, field.Type)
	 // Name , string ,  json:"name"  ini:"s_name"
	 //Score, int , json:"score" , ini:"s_socre" 
}

if scoreField, ok := t.FieldByName("score"): ok {
    fmt.Printf("name:%s index:%d type:%v json tag:%v\n", scoreField.Name, scoreField.Index,)
}
}
```
# 网络编程 
# 网络编程 
```go
// server

package main 


func process(conn net.Conn){
    defer conn.Close() 
	// send & receive for current connection 
	for {
	    reader := bufio.NewReader(conn)
		var buf [128]byte 
		n, err := reader.Read(buf[:]) // read data 
		if err != nil{
		    fmt.Printf("read from conn failed, err : %v\n", err)
			break 
		}
		recv := string(buf[:n])
		fmt.Printf("data received: ", recv )
		conn.Write([]byte("ok"))// return data back to client 
	}
}

func main(){
    listen, err := net.Listen("tcp", "127.0.0.1:20000")

	if err != nil{
		fmt.Printf("listen failed, err : %v\n", err )
		return 
	}
	for{  

	// wait for the client connection 
	conn, err := listen.Accept()
	if err != nil{
	    fmt.Printf("accept failed, err : %v\n", err)
	}
	go process(conn)
	}
}
```

```go
//client 
package main 
import {
    "net"
}

func main() {
    //1. create connection to server
	conn, err := net.Dial("tcp", "127.0.0.1:20000")

	if err != nil{
	fmt.Printf("dial failed, err : %v\n", err)
	return 
	}

	input := bufio.NewReader(os.Stdin)
	for {
	    s, _ := input.ReadString('\n')
		s = strings.TrimSpace(s)
		if strings.ToUpper(s) == "Q"{
		return 
		}

		// send message 
		_, err := conn.Write([]byte(s))
		if err != nil{
		    fmt.Printf("send failed, err : %v\n", err )
			return 
		}

		//receive message from the server 
		var buf [1024]byte 
		n, err := conn.Read(buf[:])
		if err != nil {
		    fmt.Printf("read failed, err : %v\n", err )
			return 
		}
		fmt.Println("message received : ", string(buf[:n]))
	}
}
```

<++>




