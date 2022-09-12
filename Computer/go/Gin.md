# hello world
```
package main

import (
    "net/http"

    "github.com/gin-gonic/gin"
)

func main() {
    // 1.创建路由
   r := gin.Default()
   // 2.绑定路由规则，执行的函数
   // gin.Context，封装了request和response
   r.GET("/", func(c *gin.Context) {
      c.String(http.StatusOK, "hello World!")
   })
   // 3.监听端口，默认在8080
   // Run("里面不指定端口号默认为8080") 
   r.Run(":8000")
}
```
## 自定义验证器
```go
package main

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

type PostParams struct {
	name string `json:"name" uri:"name" form:"name" xml:"name" binding:"required"`
	Age  int    `json:"age" uri:"age" form:"age" xml:"age" binding:"required,mustBig"`
	Sex  bool   `json:"sex" uri:"sex" form:"sex" xml:"sex" binding:"required"`
}

//v9 以上写法
func mustBig(fl validator.FieldLevel) bool {
	if fl.Field().Interface().(int) <= 18 {
		return false
	}
	return true
}

// v8 写法
//func mustBig(
//v *validator.Validate, topStruct reflect.Value, currentStructOrField reflect.Value,
//field reflect.Value, fieldType reflect.Type, fieldKind reflect.Kind, param string,
//)bool {
//if date , ok := field.Interface().(time.Time); ok{
//today := time.Now()
//if today.Year()> date.Year() || today.YearDay()>date.YearDay() {
//return false
//}
//}
//return true
//}

func main() {
	r := gin.Default()
    //给验证器绑定标签名 
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("mustBig", mustBig)
	}
	r.POST("/testBind", func(c *gin.Context) {
		var p PostParams
		err := c.ShouldBindJSON(&p)
		fmt.Println(err)
		if err != nil {
			c.JSON(200, gin.H{
				"msg":  "报错了",
				"data": gin.H{},
			})
		} else {
			c.JSON(200, gin.H{

				"msg":  "success",
				"data": p,
			})
		}
	})

	r.Run(":5699")
}
```

## gin对文件的接收和返回

```go
func main() {
	r := gin.Default()
	//给验证器绑定标签名
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("mustBig", mustBig)
	}
	r.POST("/testBind", func(c *gin.Context) {
		var p PostParams
		err := c.ShouldBindJSON(&p)
		fmt.Println(err)
		if err != nil {
			c.JSON(200, gin.H{
				"msg":  "报错了",
				"data": gin.H{},
			})
		} else {
			c.JSON(200, gin.H{

				"msg":  "success",
				"data": p,
			})
		}
	})

	//上传文件
	//限制上传文件大小(默认32MB)
	r.POST("/upload", func(c *gin.Context) {
		//单文件
		file, _ := c.FormFile("file")
		log.Println(file.Filename)

		//多文件
		form, _ := c.MultipartForm()
		files := form.File["upload[]"]
		for _, file := range files {
			log.Println(file.Filename)
		}
		c.String(http.StatusOK, fmt.Sprintf("%d files uploaded", len(files)))
		//上传文件到指定路径
		c.SaveUploadedFile(file, "./"+file.Filename)

		//返回文件给client
		c.Writer.Header().Add("Content-Dispositon", fmt.Sprintf("attachment; filename=%s", file.Filename))
		c.File("./" + file.Filename)
		//c.String(http.StatusOK, fmt.Sprintf("'%s' uploaded!", file.Filename))

	})

	r.Run(":5699")
}
```

<++>
