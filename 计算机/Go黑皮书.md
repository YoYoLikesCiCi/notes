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

