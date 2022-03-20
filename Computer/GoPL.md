# 入门
## 1.2 命令行参数
``` go
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
```



## 2.3 短变量声明
- 短变量声明不需要声明所有在左边的变量.  
- 短变量声明最少声明一个新变量  

# 基本数据
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

for _, value := range cityArray{
 fmt.Println(value) 
}
```

- 长度不同的数组不属于同一类型
- 定义多维数组时,只有第一纬度允许使用“...”
- go数组是值类型,不同于C,赋值和传参都会复制整个数组数据.
- 下标包头不包尾
- 
Go中函数参数中的数组使用值传递.

## 4.2 slice
表示一个拥有相同类型元素的可变长度的序列. 

```go
var array = [10]int{1,2,3,4,5,6,7,8,9,10}   //数组
var a []int //切片
var b = []int{1,2,3}  //切片
c := array[1:4]
d := array[0:len(array)]
e := make([]int, 5, 10)
a = append(a, 10)  //切片扩容 

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
- 

## 4.3 map
```go
    var a map[string]int 
	var b := map[string]bool{
	    "1" : true, 
		"2" : false,
	}

	value, ok  := b["2"] // 判断某元素在不在map中
	delete( b, "2" )

```


- 键的类型k,必须是可以通过操作符==来进行比较的数据类型(点名slice)
- 运行时会对字典并发操作做出检测,如果冲突会导致进程崩溃
- 
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
- 一个聚合类型不可以包含自己,但是可以定义一个指向自己的指针类型
- 结构体的零值由结构体成员的零值组成. 
- 按值调用,所以需要修改结构体内容的时候传参用指针
- 如果结构体的所有成员变量都是可比较的,那么这个结构体就是可比较的.


### 4.4.3 结构体嵌套和匿名成员

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



### 4.6 文本和HTML模板
- text/template , html/template
- 模板是一个字符串或者文件，包含一个或者多个两边用双大括号包围的单元——{{...}},这称为操作。


# Chapter5 函数
## 5.1 函数声明
```go
func intSum(a int, b int) int {
    ret := a+b
	return ret
}
// 可变参数，固定参数和可变参数同时出现时，可变参数要放在最后
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

## 5.5 函数变量
- 函数零值是nil
- 函数变量可以和空值比较
- 函数变量本身不可比较
- 函数变量是的函数不仅将数据进行参数化，还将函数的行为当作参数进行传递。



## 5.6 匿名函数
```go
sayHello := func(){
    fmt.Println("匿名函数")
}

//或者

func(){
     fmt.Println("匿名函数")
}()

//闭包 
// 闭包 = 函数 + 外层变量的引用
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

## 5.9 panic 宕机
当宕机发生时，所有的延迟函数以倒序执行，从栈最上面的函数开始一直返回到main函数。 

## 5.10 recover 恢复
- 不应该尝试恢复从另一个包内发生的宕机。 


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


## 6.2 指针接收者的方法
- 实参形参尽量保证同类型的变量


## 6.3 通过结构体内嵌组成类型
不太明白

## 6.4 方法变量
- 把方法变成一个变量，可以省略接收者 


## 6.5 位向量
得看

## 6.6 封装
如果变量或者方法是不能通过对象访问到的，称作<mark>封装</mark> 的变量或者方法. 
- GO语言只有一种方式控制命名的可见性:定义的时候(首字母大小写)
- 要封装一个对象,必须使用结构体.  
- Go语言中封装的单元是包而不是类型. 结构体类型内的字段对于同一个包中的所有代码都是可见的. 



# Chapter7 接口
- 接口是一种抽象类型(把它当作一种类型)
- 更像是一种协议(swift protocol)
- 只要一个类型实现了一个接口的所有方法,就说这个类型实现了某个接口
- 使用值接收者实现接口:类型的值和类型的指针都能够保存到接口变量中
- 所有类型都实现了接口, 空接口可以存储任何值,
 > 空接口作为函数的参数  
 > 空接口可以作为map的value
 ```go
 var m = make(map[string]interface{}, 16)
 m["name"]= "liBai"
 m["age"] = 18
 m["hobby"] = []string{"basketball", "soccer", "table tennis"}

 ```

 
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
```go
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

## 8.4 channel 
- channel 是一种类型,一种引用类型
- var someChannel chan type
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




