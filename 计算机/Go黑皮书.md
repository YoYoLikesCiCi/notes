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

