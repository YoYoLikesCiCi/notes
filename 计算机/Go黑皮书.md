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

Go中函数参数中的数组使用值传递.

## 4.2 slice
表示一个拥有相同类型元素的可变长度的序列. 

- 三属性: 长度、容量、指针
- slice无法做比较
- slice类型的零值是nil, 检查是否为空用 len(s) == 0, 因为 s != nil 的情况下,slice也有可能是空.  


## 4.3 map
- 键的类型k,必须是可以通过操作符==来进行比较的数据类型(点名slice)

## 4.4 结构体
- 成员变量的顺序严格(成员变量顺序定义不同则为不同的结构体)
- 成员变量首字母大写则可导出
- 一个聚合类型不可以包含自己,但是可以定义一个指向自己的指针类型
- 结构体的零值由结构体成员的零值组成. 
- 按值调用,所以需要修改结构体内容的时候传参用指针
- 如果结构体的所有成员变量都是可比较的,那么这个结构体就是可比较的.


### 4.4.3 结构体嵌套和匿名成员
- 结构体中可以定义不带名称的结构体成员,但其类型必须是<mark>命名类型</mark> 或者指向命名类型的指针. 
- 访问时可以直接通过.访问嵌套的子结构体变量,但是初始化时不能省略偷懒.
- 因为拥有隐式的名字,所以不能在一个结构体中定义两个相同类型的匿名成员.  
<++>
