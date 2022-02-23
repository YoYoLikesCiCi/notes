---
title: Tutorial for vim-go - 转载
date: 2022年2月9日 18:35:38
tags: 
- 环境安装
- VIM
- GO
categories: 
- 重剑无锋
- 环境配置
---


[https://www.5axxw.com/wiki/content/wo6s81#alternate-files](https://www.5axxw.com/wiki/content/wo6s81#alternate-files)

( 如需查看英文版本，请 点击这里 )

# 存档项目。无需维护。

此项目不再维护，已存档。如果需要的话，你可以自由选择，做出自己的改变。更多细节请阅读我的博客文章：从我的项目中无限期休假

感谢大家的宝贵反馈和贡献。

vim-go教程。一个关于如何安装和使用vim-go的简单教程。

# 目录

1. [Quick Setup](javascript:void(0);)
2. [Hello World](javascript:void(0);)
3. [Build it](javascript:void(0);)
4. [Cover it](javascript:void(0);)
5. [Edit it](javascript:void(0);)
- [Alternate files](javascript:void(0);)
- 转到定义
- 在函数之间移动
1. [Understand it](javascript:void(0);)
- [Documentation Lookup](javascript:void(0);)
- [Identifier resolution](javascript:void(0);)
- 依赖项和文件
- 实现接口的方法存根

# Quick Setup

我们将使用`vim-plug`来安装vim-go。请随意使用其他插件管理器。我们将创建一个最小的`~/.vimrc`，并在继续的过程中添加它。

首先获取并安装`vim-plug`和`vim-go`：

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
git clone https://github.com/fatih/vim-go.git ~/.vim/plugged/vim-go

```

使用以下内容创建`~/.vimrc`：

```
call plug#begin()
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
call plug#end()

```

或者打开Vim并执行`:GoInstallBinaries`。这是一个`vim-go`命令，它为您安装所有`vim-go`依赖项。它不下载预编译的二进制文件，而是在后台调用`go get`，因此二进制文件都在主机中编译（这既安全又简化了安装过程，因为我们不需要为多个平台提供二进制文件）。如果您已经有一些依赖项（例如`guru`，`goimports`），请调用`:GoUpdateBinaries`来更新二进制文件。

在本教程中，我们所有的例子都在`GOPATH/src/github.com/fatih/vim-go-tutorial/`下。请确保您在该文件夹中。这将使您更容易地遵循教程。如果已经有`GOPATH`设置，请执行：

```
go get github.com/fatih/vim-go-tutorial

```

或者根据需要创建文件夹。

# Hello World!

从终端打开`main.go`文件：

```
vim main.go

```

这是一个将`vim-go`打印到stdout的非常基本的文件。

# Run it

您可以使用`:GoRun %`轻松运行该文件。在引擎盖下，它为当前文件调用`go run`。您应该看到它打印了`vim-go`。

对于使用`:GoRun`运行的整个包。

# Build it

将`vim-go`替换为`Hello Gophercon`。让我们编译这个文件，而不是运行它。我们有`:GoBuild`。如果您调用它，您应该看到以下消息：

```
vim-go: [build] SUCCESS

```

在引擎盖下面它叫`go build`，但它更聪明一点。它做了一些不同的事情：

- 不创建二进制文件；您可以多次调用`:GoBuild`，而不会污染您的工作区。
- 它会自动`cd`s到源包的目录中
- 它分析任何错误并在快速修复列表中显示它们
- 它自动检测GOPATH并在需要时修改它（检测诸如`gb`、`Godeps`、etc..）等项目
- 如果在Vim8.0.xxx或NeoVim中使用，则运行异步

# Fix it

让我们通过添加两个编译错误来介绍两个错误：

```
var b = foo()

func main() {
	fmt.Println("Hello GopherCon")
	a
}

```

保存文件并再次调用`:GoBuild`。

这次将打开quickfix视图。要在错误之间跳转，可以使用`:cnext`和`:cprevious`。让我们修复第一个错误，保存文件并再次调用`:GoBuild`。您将看到quickfix列表更新了一个错误。同时删除第二个错误，保存文件并再次调用`:GoBuild`。现在，因为不再有错误，vim-go会自动关闭quickfix窗口。

让我们稍微改进一下。Vim有一个名为`autowrite`的设置，如果您调用`:make`，它会自动写入文件的内容。vim-go也使用此设置。打开`.vimrc`并添加以下内容：

```
set autowrite

```

现在，当您调用`:GoBuild`时，您不必再保存文件了。如果我们重新引入这两个错误并调用`:GoBuild`，我们现在可以通过只调用`:GoBuild`来更快地迭代。

`:GoBuild`跳转到遇到的第一个错误。如果您不想跳转附加`!`（bang）符号：`:GoBuild!`。

在所有`go`命令中，例如`:GoRun`、`:GoInstall`、`:GoTest`、etc..，每当出现错误时，quickfix窗口总是会弹出。

### vimrc improvements

- 您可以添加一些快捷方式，以便在快速修复列表中的错误之间切换：

```
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

```

- 我还使用这些快捷方式来构建和运行一个带有`<leader>b`和`<leader>r`的Go程序：

```
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)

```

- Vim中有两种类型的错误列表。一个叫做`location list`，另一个叫`quickfix`。不幸的是，每个列表的命令是不同的。所以`:cnext`只适用于`quickfix`列表，而`location lists`则必须使用`:lnext`。`vim-go`中的一些命令打开一个位置列表，因为位置列表与一个窗口相关联，每个窗口都可以有一个单独的列表。这意味着您可以有多个窗口和多个位置列表，一个用于`Build`，一个用于`Check`，一个用于`Tests`，等等。。

但是有些人喜欢只使用`quickfix`。如果将以下内容添加到`vimrc`中，则所有列表的类型都为`quickfix`：

```
let g:go_list_type = "quickfix"

```

# Test it

让我们编写一个简单的函数并对该函数进行测试。添加以下内容：

```
func Bar() string {
	return "bar"
}

```

打开一个名为`main_test.go`的新文件（无论您如何打开它，从Vim内部，一个单独的Vim会话，等等）。。这取决于你）。让我们使用当前缓冲区并通过`:edit main_test.go`从Vim打开它。

当你打开新文件时，你会注意到一些东西。文件将自动添加包声明：

```
package main

```

这是由vim-go自动完成的。它检测到文件在一个有效的包中，因此基于包名创建了一个文件（在我们的例子中，包名是`main`）。如果没有文件，vim-go会自动用一个简单的主包填充内容。

使用以下代码更新测试文件：

```
package main

import (
	"testing"
)

func TestBar(t *testing.T) {
	result := Bar()
	if result != "bar" {
		t.Errorf("expecting bar, got %s", result)
	}
}

```

打电话`:GoTest`。您将看到以下消息：

```
vim-go: [test] PASS

```

`:GoTest`在引擎盖下调用`go test`。它具有与`:GoBuild`相同的改进。如果有任何测试错误，将再次打开快速修复列表，您可以轻松地跳转到该列表。

另一个小的改进是您不必打开测试文件本身。你自己试试：打开`main.go`然后打`:GoTest`。您将看到测试也将为您运行。

`:GoTest`默认10秒后超时。这很有用，因为Vim在默认情况下不是异步的。您可以使用`let g:go_test_timeout = '10s'`更改超时值

我们还有两个命令，可以方便地处理测试文件。第一个是`:GoTestFunc`。这只测试光标下的函数。让我们将测试文件（`main_test.go`）的内容更改为：

```
package main

import (
	"testing"
)

func TestFoo(t *testing.T) {
	t.Error("intentional error 1")
}

func TestBar(t *testing.T) {
	result := Bar()
	if result != "bar" {
		t.Errorf("expecting bar, got %s", result)
	}
}

func TestQuz(t *testing.T) {
	t.Error("intentional error 2")
}

```

现在，当我们调用`:GoTest`时，一个快速修复窗口将打开，并显示两个错误。但是，如果进入`TestBar`函数并调用`:GoTestFunc`，您将看到我们的测试通过了！如果您有很多需要时间的测试，而您只想运行某些测试，那么这非常有用。

另一个test-related命令是`:GoTestCompile`。测试不仅需要成功地通过，而且还必须毫无问题地进行编译。`:GoTestCompile`编译测试文件，就像`:GoBuild`一样，并在出现错误时打开快速修复程序。但这并不能运行测试。这是非常有用的，如果你有一个大的测试，你要编辑很多。调用`:GoTestCompile`在当前测试文件中，您应该看到以下内容：

```
vim-go: [test] SUCCESS

```

### vimrc improvements

- 与`:GoBuild`一样，我们可以添加一个映射，用组合键轻松调用`:GoTest`。在`.vimrc`中添加以下内容：

```
autocmd FileType go nmap <leader>t  <Plug>(go-test)

```

现在您可以通过`<leader>t`轻松测试文件

- 让我们简化building Go文件。首先，删除前面添加的以下映射：

```
autocmd FileType go nmap <leader>b  <Plug>(go-build)

```

我们将添加一个改进的映射。为了使任何Go文件无缝，我们可以创建一个简单的Vim函数来检查Go文件的类型，并执行`:GoBuild`或`:GoTestCompile`。下面是可以添加到`.vimrc`中的帮助函数：

```
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

```

现在只要你点击`<leader>b`，它就会生成你的Go文件，或者无缝地编译你的测试文件。

- 默认情况下，leader快捷方式被定义为：`\`我已经将我的leader映射到`,`，因为我发现下面的设置更有用（将它放在.vimrc的开头）：

```
let mapleader = ","

```

因此，通过这个设置，我们可以轻松地用`,b`构建任何测试和非测试文件。

# Cover it

让我们深入到测试的世界。测试真的很重要。Go有一种非常好的方式来显示源代码的覆盖率。vim-go可以很容易地看到代码覆盖率，而不必以非常优雅的方式离开Vim。

让我们首先将`main_test.go`文件改回：

```
package main

import (
	"testing"
)

func TestBar(t *testing.T) {
	result := Bar()
	if result != "bar" {
		t.Errorf("expecting bar, got %s", result)
	}
}

```

和`main.go`到

```
package main

func Bar() string {
	return "bar"
}

func Foo() string {
	return "foo"
}

func Qux(v string) string {
	if v == "foo" {
		return Foo()
	}

	if v == "bar" {
		return Bar()
	}

	return "INVALID"
}

```

现在让我们打电话给`:GoCoverage`。在引擎盖下面，这叫做`go test -coverprofile tempfile`。它解析概要文件中的行，然后动态更改源代码的语法以反映覆盖率。如您所见，因为我们只对`Bar()`函数进行了测试，这是唯一一个绿色的函数。

要清除语法突出显示，可以调用`:GoCoverageClear`。让我们添加一个测试用例，看看覆盖率是如何变化的。将以下内容添加到`main_test.go`：

```
func TestQuz(t *testing.T) {
	result := Qux("bar")
	if result != "bar" {
		t.Errorf("expecting bar, got %s", result)
	}

	result = Qux("qux")
	if result != "INVALID" {
		t.Errorf("expecting INVALID, got %s", result)
	}
}

```

如果我们再次调用`:GoCoverage`，您将看到`Quz`函数现在也经过了测试，并且覆盖范围更广。再次调用`:GoCoverageClear`清除语法高亮显示。

因为调用`:GoCoverage`和`:GoCoverageClear`经常一起使用，所以有另一个命令可以方便地调用和清除结果。您也可以使用`:GoCoverageToggle`。它充当一个开关并显示覆盖范围，当再次调用时，它将清除覆盖范围。如何使用它们取决于您的工作流程。

最后，如果您不喜欢vim-go's内部视图，也可以调用`:GoCoverageBrowser`。它使用`go tool cover`创建一个HTML页面，然后在默认浏览器中打开它。有些人更喜欢这个。

使用`:GoCoverageXXX`命令不会创建任何类型的临时文件，也不会污染您的工作流。所以你不必每次都处理删除不需要的文件。

### vimrc improvements

在`.vimrc`中添加以下内容：

```
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

```

有了这个，你可以很容易地用`<leader>c`调用`:GoCoverageToggle`

# Edit it

### Imports

让我们从一个`main.go`文件开始：

```
package main

     import "fmt"

func main() {
 fmt.Println("gopher"     )
}

```

让我们从我们已经知道的事情开始吧。如果我们保存文件，你会看到它会自动格式化。默认情况下，它是启用的，但是如果需要，可以使用`let g:go_fmt_autosave = 0`禁用它（不确定为什么要禁用：）。我们还可以选择提供`:GoFmt`命令，它在引擎盖下运行`gofmt`。

让我们用大写字母打印`"gopher"`字符串。为此，我们将使用`strings`包。要更改定义：

```
fmt.Println(strings.ToUpper("gopher"))

```

当你建立它时，你会得到一个错误，当然：

```
main.go|8| undefined: strings in strings.ToUpper

```

您将看到我们得到一个错误，因为`strings`包没有导入。vim-go有两个命令可以方便地操作导入声明。

我们可以很容易地去编辑文件，但是我们将使用Vim命令`:GoImport`。此命令将给定的包添加到导入路径。{via:`:GoImport strings`}运行。您将看到正在添加`strings`包。这个命令最棒的地方是它还支持完成。所以你只需输入`:GoImport s`然后点击tab。

我们还需要`:GoImportAs`和`:GoDrop`来编辑导入路径。`:GoImportAs`与`:GoImport`相同，但它允许更改包名。例如`:GoImportAs str strings`，将使用包名`str.`导入`strings`

最后，`:GoDrop`可以很容易地从导入声明中删除任何导入路径。`:GoDrop strings`将从导入声明中删除它。

当然，操纵导入路径是2010年的事了。我们有更好的工具来处理这个案子。如果你还没听说过，那就叫`goimports`。`goimports`是`gofmt`的替代品。你有两种使用方法。第一种（也是推荐的）方法是告诉vim-go在保存文件时使用它：

```
let g:go_fmt_command = "goimports"

```

现在每当您保存文件时，`goimports`将自动格式化并重写导入声明。有些人不喜欢`goimports`，因为它在非常大的代码基上可能很慢。在本例中，我们还有`:GoImports`命令（注意末尾的`s`）。这样，您就可以显式地调用`goimports`

### Text objects

让我们展示更多编辑技巧。我们可以使用两个文本对象来更改函数。它们是`if`和`af`。`if`表示内部函数，它允许您选择函数外壳的内容。将`main.go`文件更改为：

```
package main

import "fmt"

func main() {
	fmt.Println(1)
	fmt.Println(2)
	fmt.Println(3)
	fmt.Println(4)
	fmt.Println(5)
}

```

将光标放在`func`关键字上，现在在`normal`模式下执行以下操作，然后看看会发生什么：

```
dif

```

您将看到函数体被移除。因为我们使用了`d`运算符。使用`u`撤消更改。最棒的是，光标可以是从`func`关键字开始到右大括号`}`的任意位置。它使用引擎盖下的刀具运动。我为vim-go显式地编写了motion来支持这样的特性。它具有很强的感知能力，因此它的性能非常好。你可能会问什么？将`main.go`改为：

```
package main

import "fmt"

func Bar() string {
	fmt.Println("calling bar")

	foo := func() string {
		return "foo"
	}

	return foo()
}

```

以前我们使用regexp-based文本对象，这会导致问题。例如，在这个例子中，将光标放在匿名函数`func`关键字上，并以`normal`模式执行`dif`。您将看到只有匿名函数的主体被删除。

到目前为止，我们只使用了`d`运算符（delete）。但这取决于你。例如，您可以通过`vif`选择它，或者使用`yif`来拖动（复制）。

我们还有`af`，意思是`a function`。此文本对象包括整个函数声明。将`main.go`更改为：

```
package main

import "fmt"

// bar returns a the string "foo" even though it's named as "bar". It's an
// example to be used with vim-go's tutorial to show the 'if' and 'af' text
// objects.
func bar() string {
	fmt.Println("calling bar")

	foo := func() string {
		return "foo"
	}

	return foo()
}

```

所以这是一件伟大的事情。由于`motion`，我们对每个语法节点都有充分的了解。将光标放在`func`关键字的上方或下方或上方的任何位置（无所谓）。如果现在执行`vaf`，您将看到函数声明和doc注释都被选中了！例如，您可以用`daf`删除整个函数，您将看到注释也消失了。继续将光标放在注释的顶部，执行`vif`，然后执行`vaf`。您将看到它选择了函数体，即使光标在函数之外，或者它也选择了函数注释。

这真的很强大，这一切都要归功于我们从`let g:go_textobj_include_function_doc = 1motion`学到的知识。如果不希望注释成为函数声明的一部分，可以使用以下方法轻松禁用它：

```
let g:go_textobj_include_function_doc = 0

```

如果您有兴趣了解关于`motion`的更多信息，请查看我写的博客文章：将Go类型视为vim中的对象

（可选问题：不看`go/ast`包，doc注释是否是函数声明的一部分？）

### 结构拆分和联接

有一个很好的插件可以让你拆分或连接Go结构。它实际上不是一个Go插件，但它支持Go结构。要启用它，请将`plug`定义之间的plugin指令添加到`vimrc`中，然后在vim编辑器中执行`:source ~/.vimrc`并运行`:PlugInstall`。例子：

```
call plug#begin()
Plug 'fatih/vim-go'
Plug 'AndrewRadev/splitjoin.vim'
call plug#end()

```

安装插件后，将`main.go`文件更改为：

```
package main

type Foo struct {
	Name    string
	Ports   []int
	Enabled bool
}

func main() {
	foo := Foo{Name: "gopher", Ports: []int{80, 443}, Enabled: true}
}

```

将光标放在与结构表达式相同的行上。现在输入`gS`。这将`split`将结构表达式分成多行。你甚至可以逆转它。如果光标仍在`foo`变量上，请在`normal`模式下执行`gJ`。您将看到字段定义都已联接。

这不使用任何AST-aware工具，因此例如，如果您在字段顶部键入`gJ`，您将看到只有两个字段被联接。

### Snippets

Vim-go支持两个流行的snippet插件。Ultisnips和neosnippet。默认情况下，如果您安装了`Ultisnips`，它就可以工作了。让我们先安装`ultisnips`。在`vimrc`中的`plug`指令之间添加它，然后在vim编辑器中执行`:source ~/.vimrc`，然后运行`:PlugInstall`。例子：

```
call plug#begin()
Plug 'fatih/vim-go'
Plug 'SirVer/ultisnips'
call plug#end()

```

有许多有用的片段。要查看完整列表，请查看我们当前的片段：https://github.com/fatih/vim-go/blob/master/gosnippets/UltiSnips/go.snippets

UltiSnips和YouCompleteMe可能在[tab]按钮上发生冲突

让我展示一下我用得最多的一些片段。将`main.go`内容更改为：

```
package main

import "encoding/json"

type foo struct {
	Message    string
	Ports      []int
	ServerName string
}

func newFoo() (*foo, error) {
	return &foo{
		Message:  "foo loves bar",
		Ports: []int{80},
		ServerName: "Foo",
	}, nil
}

func main() {
	res, err := newFoo()

	out, err := json.Marshal(res)
}

```

让我们把光标放在`newFoo()`表达式之后。如果错误是non-nil，让我们在这里惊慌失措。在insert模式下输入`errp`，然后点击`tab`。您将看到它将被展开并将光标放在“panic（）`”函数中：

```
if err != nil {
    panic( )
          ^
          cursor position
}

```

用`err`填充恐慌，然后转到`json.Marshal`语句。做同样的事情。

现在让我们打印变量`out`。由于变量打印非常流行，因此我们有几个片段：

```
fn -> fmt.Println()
ff -> fmt.Printf()
ln -> log.Println()
lf -> log.Printf()

```

这里`ff`和`lf`是特殊的。它们还动态地将变量名复制到格式字符串中。你自己试试吧。将光标移到main函数的末尾，输入`ff`，然后点击tab。展开代码段后，可以开始键入。输入`string(out)`，您将看到格式字符串和变量参数都将用您键入的相同字符串填充。

这对于快速打印用于调试的变量非常方便。使用`:GoRun`运行文件，您将看到以下输出：

```
string(out) = {"Message":"foo loves bar","Ports":[80],"ServerName":"Foo"}

```

伟大的。现在让我展示最后一个我认为非常有用的片段。正如您在输出中看到的，字段`Message`和`Ports`以大写字符开头。为了解决这个问题，我们可以在struct字段中添加一个json标记。vim-go使添加字段标记变得非常容易。将光标移到字段中`Message`字符串行的末尾：

```
type foo struct {
    Message string .
                   ^ put your cursor here
}

```

在`insert`模式下，输入`json`并点击tab。您将看到它将自动扩展为有效的字段标记。字段名将自动转换为小写，并放在那里。现在应该可以看到以下内容：

```
type foo struct {
	Message  string `json:"message"`
}

```

真是太神奇了。但我们可以做得更好！继续为`ServerName`字段创建一个代码段扩展。您将看到它被转换为`server_name`。太棒了对吧？

```
type foo struct {
	Message    string `json:"message"`
	Ports      []int
	ServerName string `json:"server_name"`
}

```

### vimrc improvements

- 别忘了把`gofmt`改成`goimports`

```
let g:go_fmt_command = "goimports"

```

- 当您保存文件时，`gofmt`在解析文件期间显示任何错误。如果有任何解析错误，它会在快速修复列表中显示它们。这是默认启用的。有些人不喜欢。要禁用它，请添加：

```
let g:go_fmt_fail_silently = 1

```

- 您可以在转换时更改应应用的大小写。默认情况下，vim-go使用`snake_case`。但如果您愿意，也可以使用`camelCase`。例如，如果要将默认值更改为大小写，请使用以下设置：

```
let g:go_addtags_transform = "camelcase"

```

# Beautify it

默认情况下，我们只启用了有限的语法高亮显示。主要有两个原因。首先，人们不喜欢太多的颜色，因为它会让人分心。第二个原因是它对Vim的性能影响很大。我们需要显式地启用它。首先将以下设置添加到`.vimrc`：

```
let g:go_highlight_types = 1

```

这突出显示了`bar`和`foo`：

```
type foo struct{
  quz string
}

type bar interface{}

```

添加以下内容：

```
let g:go_highlight_fields = 1

```

将突出显示下面的`quz`：

```
type foo struct{
  quz string
}

f := foo{quz:"QUZ"}
f.quz # quz here will be highlighted

```

如果我们添加以下内容：

```
let g:go_highlight_functions = 1

```

我们现在还在声明中突出显示函数和方法名。`Foo`和`main`现在将突出显示，但是`Println`不是因为这是一个调用：

```
func (t *T) Foo() {}

func main() {
  fmt.Println("vim-go")
}

```

如果还想突出显示函数和方法调用，请添加以下内容：

```
let g:go_highlight_function_calls = 1

```

现在，`Println`也将突出显示：

```
func (t *T) Foo() {}

func main() {
  fmt.Println("vim-go")
}

```

如果添加`let g:go_highlight_operators = 1`，它将突出显示以下运算符，例如：

```
- + % < > ! & | ^ * =
-= += %= <= >= != &= |= ^= *= ==
<< >> &^
<<= >>= &^=
:= && || <- ++ --

```

如果添加`let g:go_highlight_extra_types = 1`，以下额外类型也将突出显示：

```
bytes.(Buffer)
io.(Reader|ReadSeeker|ReadWriter|ReadCloser|ReadWriteCloser|Writer|WriteCloser|Seeker)
reflect.(Kind|Type|Value)
unsafe.Pointer

```

让我们继续了解更多有用的亮点。构建标签呢？不查看`go/build`文档就不容易实现它。让我们首先添加以下内容：`let g:go_highlight_build_constraints = 1`并将`main.go`文件更改为：

```
// build linux
package main

```

你会看到它是灰色的，所以它是无效的。将`+`添加到`build`单词并再次保存：

```
// +build linux
package main

```

你知道为什么吗？如果您阅读`go/build`包，您将看到以下内容隐藏在文档中：

> 
> 
> 
> ... 前面只有空行和其他行注释。
> 

让我们再次更改内容并将其保存到：

```
// +build linux

package main

```

您将看到它以有效的方式自动高亮显示它。真的很棒。如果您将`linux`更改为某个内容，您将看到它还检查有效的官方标记（例如`darwin`、`race`、`ignore`等）

另一个类似的特性是突出显示Go指令`//go:generate`。如果将`let g:go_highlight_generate_tags = 1`放入vimrc，它将突出显示使用`go generate`命令处理的有效指令。

我们有更多的亮点设置，这些只是一个偷窥。如需更多信息，请通过`:help go-settings`查看设置

### vimrc improvements

- 有些人不喜欢标签的显示方式。默认情况下，Vim为单个选项卡显示`8`个空格。然而，如何在Vim中表示取决于我们。以下内容将更改为将单个选项卡显示为4个空格：

```
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

```

此设置不会将选项卡展开为空格。它将用`4`空格显示一个选项卡。它将使用`4`空格来表示单个缩进。

- 很多人要我的配色方案。我用的是稍加修改的`molokai`。要启用它，请在Plug定义之间添加Plug指令：

```
call plug#begin()
Plug 'fatih/vim-go'
Plug 'fatih/molokai'
call plug#end()

```

同时添加以下内容，以启用原始配色方案和256色版本的molokai：

```
let g:rehash256 = 1
let g:molokai_original = 1
colorscheme molokai

```

然后重启Vim并调用`:source ~/.vimrc`，然后调用`:PlugInstall`。这将拉插件并为您安装。安装插件后，您需要重新启动Vim。

# Check it

从前面的示例中，您看到我们有许多命令，当出现问题时，这些命令将显示quickfix窗口。例如，`:GoBuild`显示编译输出中的错误（如果有）。或者例如`:GoFmt`显示当前文件格式化时的解析错误。

我们有许多其他命令，允许我们调用然后收集错误、警告或建议。

例如`:GoLint`。在幕后，它调用`golint`，这是一个建议更改以使Go代码更具惯用性的命令。还有一个`:GoVet`，它在引擎盖下调用`go vet`。有许多其他工具可以检查某些东西。为了让它更简单，有人决定创建一个调用所有这些跳棋的工具。这个工具叫做`gometalinter`。vim-go通过命令`:GoMetaLinter`支持它。那么它有什么作用呢？

如果您只是调用`:GoMetaLinter`来获取给定的Go源代码。默认情况下，它将同时运行`go vet`、`golint`和`errcheck`。`gometalinter`收集所有输出并将其规范化为通用格式。因此，如果您调用`:GoMetaLinter`，vim-go将在快速修复列表中显示所有这些跳棋的结果。然后，您可以轻松地在lint、vet和errcheck结果之间切换。此默认设置如下：

```
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']

```

还有许多其他工具，您可以轻松地自定义此列表。如果您调用`:GoMetaLinter`，它将自动使用上面的列表。

因为`:GoMetaLinter`通常很快，vim-go也可以在每次保存文件时调用它（就像`:GoFmt`）。要启用它，您需要将以下内容添加到`.vimrc:`

```
let g:go_metalinter_autosave = 1

```

最棒的是，autosave的跳棋与`:GoMetaLinter`不同。这很好，因为您可以自定义它，所以在保存文件时只调用快速检查程序，但如果您调用`:GoMetaLinter`，则调用其他检查程序。下面的设置允许您为`autosave`特性定制方格。

```
let g:go_metalinter_autosave_enabled = ['vet', 'golint']

```

如您所见，默认情况下启用`vet`和`golint`。最后，为了防止`:GoMetaLinter`运行太长时间，我们有一个设置，在给定的超时之后取消它。默认为`5 seconds`，但可以通过以下设置进行更改：

```
let g:go_metalinter_deadline = "5s"

```

# Navigate it

到目前为止，我们只跳过了`main.go`和`main_test.go`两个文件。如果在同一个目录中只有两个文件，那么切换非常容易。但是如果项目随着时间的推移变得越来越大呢？或者如果文件本身太大，以至于您很难导航它呢？

### Alternate files

vim-go有几种改进导航的方法。首先让我展示一下如何在Go源代码和它的测试文件之间快速跳转。

假设您有一个`foo.go`及其等价的测试文件`foo_test.go`。如果您有前面示例中的`main.go`及其测试文件，您也可以打开它。打开后，只需执行以下Vim命令：

```
:GoAlternate

```

您将看到您立即切换到`main_test.go`。如果您再次执行它，它将切换到`main.go`。`:GoAlternate`起到切换的作用，如果您有一个包含许多测试文件的包，则非常有用。这个想法非常类似于plugina.vim命令名。这个插件在`.c`和`.h`文件之间跳跃。在我们的例子中，`:GoAlternate`用于在测试和non-test文件之间切换。

### 转到定义

最常用的特性之一是`go to definition`。从一开始，vim-go有一个`:GoDef`命令，该命令跳转到任何标识符的声明。让我们首先创建一个`main.go`文件来显示它的实际操作。使用以下内容创建它：

```
package main

import "fmt"

type T struct {
	Foo string
}

func main() {
	t := T{
		Foo: "foo",
	}

	fmt.Printf("t = %+v\n", t)
}

```

现在我们有几种跳到声明的方法。例如，如果您将光标放在`T`表达式的顶部，紧跟在main函数之后并调用`:GoDef`，它将跳转到类型声明。

如果您将光标放在`t`变量声明的顶部，紧跟在main函数之后并调用`:GoDef`，您将看到不会发生任何事情。因为没有地方可去，但是如果您向下滚动几行并将光标放在`fmt.Printf()`中使用的`t`变量并调用`:GoDef`，您将看到它跳转到变量声明。

`:GoDef`不仅适用于本地范围，而且在全局范围内（跨`GOPATH`）工作。例如，如果您将光标放在`Printf()`函数的顶部并调用`:GoDef`，它将直接跳转到`fmt`包。因为这是如此频繁地使用，vim-go也覆盖了内置的Vim快捷方式`gd`和`ctrl-]`。因此，您可以轻松地使用`gd`或`ctrl-]`来代替`:GoDef`

一旦我们跳转到一个声明，我们可能还想回到以前的位置。默认情况下，Vim快捷键`ctrl-o`会跳转到上一个光标位置。当它运行得很好时，它会很好地工作，但是如果您在Go声明之间导航，就不够好了。例如，如果您跳转到`:GoDef`的文件，然后向下滚动到底部，然后可能到顶部，`ctrl-o`也会记住这些位置。因此，如果你想在调用`:GoDef`时跳回上一个位置，你必须多次点击`ctrl-o`。这真的很烦人。

不过，我们不需要使用这个快捷方式，因为vim-go为您提供了更好的实现。有一个命令`:GoDefPop`正是这样做的。vim-go为使用`:GoDef`访问的所有位置保留一个内部堆栈列表。这意味着您可以通过`:GoDefPop`轻松地跳回原来的位置，即使您在文件中向下/向上滚动也可以。因为这也被使用了很多次，所以我们有一个快捷方式`ctrl-t`，它在引擎盖下调用`:GoDefPop`。所以回顾一下：

- 使用`ctrl-]`或`gd`跳转到本地或全局定义
- 使用`ctrl-t`跳回上一个位置

让我们继续问另一个问题，假设你跳得太远，只想回到你开始的地方？如前所述，vim-go保存通过`:GoDef`调用的所有位置的历史记录。有一个命令显示了所有这些，它名为`:GoDefStack`。如果您调用它，您将看到一个带有旧位置列表的自定义窗口。只需导航到所需的位置，然后按enter键。最后随时调用`:GoDefStackClear`清除堆栈列表。

### 在函数之间移动

从前面的例子中，我们看到`:GoDef`如果您知道您想跳转到哪里，那么`:GoDef`是很好的。但是如果你不知道你的下一个目的地呢？或者你只知道一个函数的名字？

在我们的`Edit it`部分中，我提到了一个名为`motion`的工具，它是一个专门为vim-go定制的工具。`motion`还有其他功能。`motion`解析Go包，因此对所有声明都有很好的理解。我们可以利用这个特性在声明之间跳转。有两个命令，在安装某个插件之前是不可用的。命令包括：

```
:GoDecls
:GoDeclsDir

```

首先，让我们通过安装必要的插件来启用这两个命令。这个插件叫做ctrlp。Long-timeVim用户已经安装了它。要安装它，请在`plug`指令之间添加以下行，然后在vim编辑器中执行`:source ~/.vimrc`，并调用`:PlugInstall`来安装它：

```
Plug 'ctrlpvim/ctrlp.vim'

```

安装后，请使用以下`main.go`内容：

```
package main

import "fmt"

type T struct {
	Foo string
}

func main() {
	t := T{
		Foo: "foo",
	}

	fmt.Printf("t = %+v\n", t)
}

func Bar() string {
	return "bar"
}

func BarFoo() string {
	return "bar_foo"
}

```

以及一个`main_test.go`文件，其中包含以下内容：

```
package main

import (
	"testing"
)

type files interface{}

func TestBar(t *testing.T) {
	result := Bar()
	if result != "bar" {
		t.Errorf("expecting bar, got %s", result)
	}
}

func TestQuz(t *testing.T) {
	result := Qux("bar")
	if result != "bar" {
		t.Errorf("expecting bar, got %s", result)
	}

	result = Qux("qux")
	if result != "INVALID" {
		t.Errorf("expecting INVALID, got %s", result)
	}
}

```

打开`main.go`并调用`:GoDecls`。您将看到`:GoDecls`为您显示了所有类型和函数声明。如果您输入`ma`，您将看到`ctrlp`为您过滤列表。如果你点击`enter`，它将自动跳转到它。模糊搜索功能与`motion`的AST功能相结合，给我们带来了一个非常简单但功能强大的特性。

例如，调用`:GoDecls`并写入`foo`。您将看到它将为您过滤`BarFoo`。Go解析器速度非常快，可以很好地处理包含数百个声明的大型文件。

有时仅仅在当前文件中搜索是不够的。一个Go包可以有多个文件（例如测试）。类型声明可以在一个文件中，而特定于一组功能的某些函数可以在另一个文件中。这就是`:GoDeclsDir`有用的地方。它解析给定文件的整个目录，并列出给定目录（但不是子目录）中文件的所有声明。

打电话`:GoDeclsDir`。这次您将看到它还包括来自`main_test.go`文件的声明。如果您输入`Bar`，您将看到`Bar`和`TestBar`函数。如果您只想获得所有类型和函数声明的概述，并跳转到它们，这真是太棒了。

让我们继续问一个问题。如果你只想转到下一个或上一个函数呢？如果当前函数体很长，则很可能看不到函数名。或者在当前函数和其他函数之间还有其他声明。

Vim已经有了像`w`表示单词或`b`表示向后单词的运动操作符。但是如果我们可以加上行动计划呢？例如函数声明？

vim-go提供（重写）两个运动对象在函数之间移动。这些是：

```
]] -> jump to next function
[[ -> jump to previous function

```

默认情况下，Vim有这些快捷方式。但这些都适用于C源代码和大括号之间的跳转。我们可以做得更好。就像我们前面的例子一样，`motion`是在引擎盖下用于这个操作的

打开`main.go`并移动到文件的顶部。在`normal`模式下，输入`]]`，然后看看会发生什么。您将看到您跳转到`main()`函数。另一个`]]`将跳转到`Bar()`，如果你点击`[[`，它将跳回`main()`函数。

`]]`和`[[`也接受`counts`。例如，如果您再次移动到顶部并点击`3]]`，您将看到它将跳转到源文件中的第三个函数。接下来，因为这些都是有效的运动，你也可以对它应用操作符！

如果您将文件移到顶部并点击`d]]`，您将看到它在下一个函数之前删除了任何内容。例如，一个有用的用法是输入`v]]`，然后再次点击`]]`来选择下一个函数，直到完成选择为止。

### .vimrc improvements

- 我们可以改进它来控制它如何打开备用文件。在`.vimrc`中添加以下内容：

```
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

```

这将添加新的命令，称为`:A`、`:AV`、`:AS`和`:AT`。这里`:A`的工作方式与`:GoAlternate`相同，它用备用文件替换当前缓冲区。`:AV`将使用备用文件打开一个新的垂直拆分。`:AS`将在新的拆分视图中打开备用文件，在新选项卡中打开`:AT`。这些命令的效率非常高，这取决于您如何使用它们，所以我认为拥有它们很有用。

- “go to definition”命令系列非常强大，但使用起来却很简单。默认情况下，它使用工具`guru`（以前是`oracle`）。`guru`有很好的可预测性记录。它适用于点导入、供应商化导入和许多其他non-obvious标识符。但有时对于某些查询来说，它非常慢。以前vim-go使用的是`godef`，它在解决查询方面非常快。在最新版本中，可以很容易地使用或切换`:GoDef`的底层工具。要将其更改回`godef`，请使用以下设置：

```
let g:go_def_mode = 'godef'

```

- 当前默认情况下，`:GoDecls`和`:GoDeclsDir`显示类型和函数声明。这可以使用`g:go_decls_includes`设置进行自定义。默认情况下，它的形式是：

```
let g:go_decls_includes = "func,type"

```

如果只想显示函数声明，请将其更改为：

```
let g:go_decls_includes = "func"

```

# Understand it

编写/编辑/更改代码通常只有在我们首先了解代码在做什么时才能做。vim-go有几种方法可以使您更容易地理解代码的全部内容。

### Documentation lookup

让我们从基础知识开始。Go文档非常well-written，并且高度集成到goast中。如果只编写一些注释，解析器可以轻松地解析它并与AST中的任何节点关联。所以这意味着我们可以很容易地以相反的顺序找到文档。如果您有一个AST节点，那么您可以轻松地从该节点读取它！

我们有一个名为`:GoDoc`的命令，它显示与光标下标识符相关的任何文档。让我们将`main.go`的内容更改为：

```
package main

import "fmt"

func main() {
	fmt.Println("vim-go")
	fmt.Println(sayHi())
	fmt.Println(sayYoo())
}

// sayHi() returns the string "hi"
func sayHi() string {
	return "hi"
}

func sayYoo() string {
	return "yoo"
}

```

将光标放在`Println`函数的顶部，紧跟`main`函数，然后调用`:GoDoc`。您将看到它vim-go自动打开一个草稿窗口，为您显示文档：

```
import "fmt"

func Println(a ...interface{}) (n int, err error)

Println formats using the default formats for its operands and writes to
standard output. Spaces are always added between operands and a newline is
appended. It returns the number of bytes written and any write error
encountered.

```

它显示导入路径、函数签名，最后是标识符的doc注释。最初vim-go使用的是普通的`go doc`，但它有一些缺点，例如不能基于字节标识符进行解析。`go doc`非常适合终端使用，但是很难集成到编辑器中。幸运的是，我们有一个非常有用的工具`gogetdoc`，它解析并检索底层节点的AST节点，并输出相关的doc注释。

这就是`:GoDoc`适用于任何类型的标识符的原因。如果您将光标放在`sayHi()`下并调用`:GoDoc`，您将看到它也显示了它。如果你把它放在`sayYoo()`下，你会看到它只输出`no documentation`作为AST节点，没有doc注释。

与其他特性一样，我们重写默认的普通快捷方式`K`，以便它调用`:GoDoc`，而不是`man`（或其他东西）。很容易找到文档，只需在正常模式下点击`K`！

`:GoDoc`只显示给定标识符的文档。但是它不是一个文档浏览器，如果你想浏览文档，有一个third-party插件来完成它：go-explorer。在vim-go中包含了一个开放的bug。

### Identifier resolution

有时您想知道函数接受或返回的是什么。或者光标下的标识符是什么。像这样的问题很常见，我们有命令来回答。

使用相同的`main.go`文件，检查`Println`函数并调用`:GoInfo`。您将看到函数签名正在状态行中打印。这真的很好的看到它在做什么，因为你不必跳到定义和检查签名是什么。

但是每次打`:GoInfo`都很乏味。我们可以做一些改进来更快地调用它。一如既往，加快速度的一种方法是添加快捷方式：

```
autocmd FileType go nmap <Leader>i <Plug>(go-info)

```

现在只需按一下`<leader>i`，就可以轻松地调用`:GoInfo`。但仍有改进的余地。vim-go支持在移动光标时自动显示信息。要启用它，请在`.vimrc`中添加以下内容：

```
let g:go_auto_type_info = 1

```

现在，只要将光标移到有效标识符上，就会看到状态行自动更新。默认情况下，它每更新一次`800ms`。这是一个vim设置，可以用`updatetime`设置进行更改。要将其更改为`100ms`，请将以下内容添加到`.vimrc`

```
set updatetime=100

```

### Identifier highlighting

有时我们只想快速看到所有匹配的标识符。例如变量、函数等。。假设您有以下Go代码：

```
package main

import "fmt"

func main() {
	fmt.Println("vim-go")
	err := sayHi()
	if err != nil {
		panic(err)
	}
}

// sayHi() returns the string "hi"
func sayHi() error {
	fmt.Println("hi")
	return nil
}

```

如果您将光标放在`err`上并调用`:GoSameIds`，您将看到所有的`err`变量都会高亮显示。将光标放在`sayHi()`函数调用上，您将看到`sayHi()`函数标识符都高亮显示。要清除它们，请致电`:GoSameIdsClear`

如果我们不必每次都手动调用它，这会更有用。vim-go可以自动突出显示匹配的标识符。在`vimrc`中添加以下内容：

```
let g:go_auto_sameids = 1

```

重新启动vim之后，您将看到不再需要手动调用`:GoSameIds`。匹配的标识符变量现在会自动为您高亮显示。

### 依赖项和文件

如您所知，一个包可以由多个依赖项和文件组成。即使目录中有许多文件，也只有正确包含package子句的文件才是包的一部分。

要查看组成包的文件，可以调用以下命令：

```
:GoFiles

```

将输出（my`$GOPATH`设置为`~/Code/Go`）：

```
['/Users/fatih/Code/go/src/github.com/fatih/vim-go-tutorial/main.go']

```

如果你有其他文件，这些也会列出。请注意，此命令仅用于列出属于构建一部分的Go文件。将不列出测试文件。

为了显示文件的依赖关系，可以调用`:GoDeps`。如果你叫它，你会看到：

```
['errors', 'fmt', 'internal/race', 'io', 'math', 'os', 'reflect', 'runtime',
'runtime/internal/atomic', 'runtime/internal/sys', 'strconv', 'sync',
'sync/atomic ', 'syscall', 'time', 'unicode/utf8', 'unsafe']

```

### Guru

前一个特性是在引擎盖下使用`guru`工具。让我们来谈谈古鲁。那么什么是古鲁？Guru是一个用于导航和理解Go代码的编辑器集成工具。有一本用户手册显示了所有的特性：https://golang.org/s/using-guru

让我们使用手册中的相同示例来展示我们集成到vim-go中的一些功能：

```
package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	h := make(handler)
	go counter(h)
	if err := http.ListenAndServe(":8000", h); err != nil {
		log.Print(err)
	}
}

func counter(ch chan<- int) {
	for n := 0; ; n++ {
		ch <- n
	}
}

type handler chan int

func (h handler) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-type", "text/plain")
	fmt.Fprintf(w, "%s: you are visitor #%d", req.URL, <-h)
}

```

将光标放在`handler`上，然后调用`:GoReferrers`。这将调用`referrers`模式`guru`，它查找对所选标识符的引用，扫描工作区内所有必需的包。结果将是一个位置列表。

`guru`的模式之一也是`describe`模式。它就像`:GoInfo`，但它更高级一些（它提供了更多信息）。例如，它显示类型的方法集（如果有）。如果选中，则显示包的声明。

让我们继续使用相同的`main.go`文件。将光标放在`URL`字段或`req.URL`（在`ServeHTTP`函数内）的顶部。打电话给`:GoDescribe`。您将看到一个包含以下内容的位置列表：

```
main.go|27 col 48| reference to field URL *net/url.URL
/usr/local/go/src/net/http/request.go|91 col 2| defined here
main.go|27 col 48| Methods:
/usr/local/go/src/net/url/url.go|587 col 15| method (*URL) EscapedPath() string
/usr/local/go/src/net/url/url.go|844 col 15| method (*URL) IsAbs() bool
/usr/local/go/src/net/url/url.go|851 col 15| method (*URL) Parse(ref string) (*URL, error)
/usr/local/go/src/net/url/url.go|897 col 15| method (*URL) Query() Values
/usr/local/go/src/net/url/url.go|904 col 15| method (*URL) RequestURI() string
/usr/local/go/src/net/url/url.go|865 col 15| method (*URL) ResolveReference(ref *URL) *URL
/usr/local/go/src/net/url/url.go|662 col 15| method (*URL) String() string
main.go|27 col 48| Fields:
/usr/local/go/src/net/url/url.go|310 col 2| Scheme   string
/usr/local/go/src/net/url/url.go|311 col 2| Opaque   string
/usr/local/go/src/net/url/url.go|312 col 2| User     *Userinfo
/usr/local/go/src/net/url/url.go|313 col 2| Host     string
/usr/local/go/src/net/url/url.go|314 col 2| Path     string
/usr/local/go/src/net/url/url.go|315 col 2| RawPath  string
/usr/local/go/src/net/url/url.go|316 col 2| RawQuery string
/usr/local/go/src/net/url/url.go|317 col 2| Fragment string

```

您将看到，我们可以看到字段的定义、方法集和`URL`结构的字段。这是一个非常有用的命令，如果您需要它并想理解周围的代码，它就在那里。尝试通过在其他各种标识符上调用`:GoDescribe`来测试输出是什么。

被问得最多的问题之一是如何知道一个类型正在实现的接口。假设您有一个类型和一个由多个方法组成的方法集。您想知道它可能实现哪个接口。`guru`的模式`implement`就是这样做的，它有助于找到一个类型实现的接口。

只需继续前一个`main.go`文件。将光标放在`handler`标识符上`main()`函数之后。Call`:GoImplements`您将看到一个位置列表，其中包含以下内容：

```
main.go|23 col 6| chan type handler
/usr/local/go/src/net/http/server.go|57 col 6| implements net/http.Handler

```

第一行是我们选择的类型，第二行是它实现的接口。因为一个类型可以实现许多接口，所以它是一个位置列表。

`guru`模式中可能有帮助的是`whicherrs`。如你所知，错误只是价值观。所以它们可以被编程，因此可以代表任何类型。看看`guru`手册上说的：

> 
> 
> 
> whichers模式报告可能出现在类型error值中的一组可能的常量、全局变量和具体类型。在处理错误时，这些信息可能很有用，以确保所有重要的案件都得到处理。
> 

那么我们如何使用它呢？很简单。我们仍然使用相同的`main.go`文件。将光标放在从`http.ListenAndServe`返回的`err`标识符的顶部。调用`:GoWhicherrs`，您将看到以下输出：

```
main.go|12 col 6| this error may contain these constants:
/usr/local/go/src/syscall/zerrors_darwin_amd64.go|1171 col 2| syscall.EINVAL
main.go|12 col 6| this error may contain these dynamic types:
/usr/local/go/src/syscall/syscall_unix.go|100 col 6| syscall.Errno
/usr/local/go/src/net/net.go|380 col 6| *net.OpError

```

您将看到`err`值可能是`syscall.EINVAL`常量，也可能是动态类型`syscall.Errno`或`*net.OpError`。如您所见，这在实现定制逻辑以不同方式处理错误时非常有用。注意，这个查询需要设置guru`scope`。稍后我们将介绍`scope`是什么，以及如何动态地更改它。

让我们继续使用相同的`main.go`文件。Go以其并发原语（如channels）而闻名。跟踪值如何在通道之间发送有时会很困难。为了更好地理解它，我们有`peers`模式`guru`。此查询显示通道操作数上可能的发送/接收集（发送或接收操作）。

将光标移到以下表达式并选择整行：

```
ch <- n

```

打电话给`:GoChannelPeers`。您将看到一个包含以下内容的位置列表窗口：

```
main.go|19 col 6| This channel of type chan<- int may be:
main.go|10 col 11| allocated here
main.go|19 col 6| sent to, here
main.go|27 col 53| received from, here

```

如您所见，您可以看到通道的分配，它从何处发送和接收。因为这使用指针分析，所以必须定义一个范围。

让我们看看函数调用和目标是如何相关的。这次创建以下文件。`main.go`的内容应为：

```
package main

import (
	"fmt"

	"github.com/fatih/vim-go-tutorial/example"
)

func main() {
	Hello(example.GopherCon)
	Hello(example.Kenya)
}

func Hello(fn func() string) {
	fmt.Println("Hello " + fn())
}

```

文件应该在`example/example.go`下：

```
package example

func GopherCon() string {
	return "GopherCon"
}

func Kenya() string {
	return "Kenya"
}

```

所以跳转到`main.go`中的`Hello`函数，并将光标放在名为`fn()`的函数调用的顶部。执行`:GoCallees`。此命令显示所选函数调用的可能调用目标。如您所见，它将向我们展示`example`函数中的函数声明。这些函数是被调用者，因为它们是由名为`fn()`的函数调用调用的。

再次跳回`main.go`，这次将光标放在函数声明`Hello()`上。如果我们想看到这个函数的调用者呢？执行`:GoCallers`。

您应该看到输出：

```
main.go| 10 col 7 static function call from github.com/fatih/vim-go-tutorial.Main
main.go| 11 col 7 static function call from github.com/fatih/vim-go-tutorial.Main

```

最后还有`callstack`模式，它显示从调用图根到包含选择的函数的任意路径。

将光标放回`Hello()`函数内的`fn()`函数调用。选择函数并调用`:GoCallstack`。输出应如下（简化形式）：

```
main.go| 15 col 26 Found a call path from root to (...)Hello
main.go| 14 col 5 (...)Hello
main.go| 10 col 7 (...)main

```

它从`15`行开始，然后到`14`行，然后在`10`行结束。这是从根（从`main()`开始）到我们选择的函数（在我们的例子中是`fn()`）的图

对于大多数`guru`命令，您不需要定义任何范围。什么是`scope`？以下摘录直接摘自`guru`手册：

> 
> 
> 
> 指针分析范围：有些查询涉及指针分析，这是一种回答“这个指针可能指向什么”形式的问题的技术？”. 对工作区中的所有包运行指针分析通常开销太大，因此这些查询需要一个称为scope的附加配置参数，它决定要分析的包集。将作用域设置为当前正在使用的应用程序（或applications---a客户机和服务器的集合）。指针分析是whole-program分析，因此范围内唯一重要的包是主包和测试包。
> 
> 作用域通常被指定为comma-separated包集，或者像github.com/my/dir/...这样的通配符子树；请参阅编辑器的特定文档，了解如何设置和更改范围。
> 

`vim-go`自动尝试智能化，并为您将当前包导入路径设置为`scope`。如果命令需要一个作用域，那么大部分都可以覆盖。大多数情况下，这已经足够了，但是对于某些查询，您可能需要更改范围设置。为了便于动态更改`scope`，请使用一个名为`:GoGuruScope`的特定设置

如果您调用它，它将返回一个错误：`guru scope is not set`。让我们显式地将其更改为`github.com/fatih/vim-go-tutorial“范围：

```
:GoGuruScope github.com/fatih/vim-go-tutorial

```

您应该看到以下消息：

```
guru scope changed to: github.com/fatih/vim-go-tutorial

```

如果不带任何参数运行`:GoGuruScope`，它将输出以下内容

```
current guru scope: github.com/fatih/vim-go-tutorial

```

要选择整个`GOPATH`，可以使用`...`参数：

```
:GoGuruScope ...

```

您还可以定义多个包和子目录。以下示例选择`github.com`和`golang.org/x/tools`包下的所有包：

```
:GoGuruScope github.com/... golang.org/x/tools

```

您可以通过在包前面加上`-`（负号）来排除包。以下示例选择`encoding`下而不是`encoding/xml`下的所有包：

```
:GoGuruScope encoding/... -encoding/xml

```

要清除范围，只需传递一个空字符串：

```
:GoGuruScope ""

```

如果您正在一个项目中工作，您必须将范围始终设置为相同的值，并且您不希望每次启动Vim时都调用`:GoGuruScope`，那么您还可以通过向`vimrc`添加一个设置来定义一个永久作用域。该值必须是字符串类型的列表。以下是上述命令中的一些示例：

```
let g:go_guru_scope = ["github.com/fatih/vim-go-tutorial"]
let g:go_guru_scope = ["..."]
let g:go_guru_scope = ["github.com/...", "golang.org/x/tools"]
let g:go_guru_scope = ["encoding/...", "-encoding/xml"]

```

最后，`vim-go`会在使用`:GoGuruScope`时自动完成软件包。所以当你试图写`github.com/fatih/vim-go-tutorial`只需输入`gi`并点击`tab`，你会发现它会扩展到`github.com`

另一个需要注意的设置是构建标记（也称为构建约束）。例如，下面是您在Go源代码中放置的构建标记：

```
// +build linux darwin

```

有时源代码中可能有自定义标记，例如：

```
// +build mycustomtag

```

在这种情况下，guru将失败，因为底层的`go/build`包将无法构建该包。因此，所有`guru`相关的命令都将失败（即使`:GoDef`在使用`guru`时也是如此）。幸运的是，`guru`有一个`-tags`标志，允许我们传递自定义标记。为了方便`vim-go`用户，我们有一个`:GoBuildTags`

对于示例，只需调用以下命令：

```
:GoBuildTags mycustomtag

```

这将把这个标记传递给`guru`，从现在起它将按预期工作。就像`:GoGuruScope`，你可以用以下方法清除它：

```
:GoBuildTags ""

```

最后，如果您愿意，可以使用以下设置使其永久化：

```
let g:go_build_tags = "mycustomtag"

```

# Refactor it

### Rename identifiers

重命名标识符是最常见的任务之一。但这也是一件需要小心处理的事情，以免破坏其他包裹。同样，仅仅使用`sed`这样的工具有时是没有用的，因为您希望能够感知AST的重命名，所以它只应该重命名属于AST的标识符（它不应该重命名其他非Go文件中的标识符，比如构建脚本）

有一个为您重命名的工具，名为`gorename`。`vim-go`使用`:GoRename`命令在引擎盖下使用`gorename`。让我们将`main.go`更改为以下内容：

```
package main

import "fmt"

type Server struct {
	name string
}

func main() {
	s := Server{name: "Alper"}
	fmt.Println(s.name) // print the server name
}

func name() string {
	return "Zeynep"
}

```

将光标放在`Server`结构中`name`字段的顶部，然后调用`:GoRename bar`。您将看到所有`name`引用都被重命名为`bar`。最终内容如下：

```
package main

import "fmt"

type Server struct {
	bar string
}

func main() {
	s := Server{bar: "Alper"}
	fmt.Println(s.bar) // print the server name
}

func name() string {
	return "Zeynep"
}

```

如您所见，只有必要的标识符被重命名，但是函数`name`或注释中的字符串没有被重命名。更好的是`:GoRename`搜索`GOPATH`下的所有包，并重命名依赖于该标识符的所有标识符。这是一个非常强大的工具。

### Extract function

让我们来看另一个例子。将`main.go`文件更改为：

```
package main

import "fmt"

func main() {
	msg := "Greetings\nfrom\nTurkey\n"

	var count int
	for i := 0; i < len(msg); i++ {
		if msg[i] == '\n' {
			count++
		}
	}

	fmt.Println(count)
}

```

这是一个基本示例，它只计算`msg`变量中的换行数。如果您运行它，您将看到它输出`3`。

假设我们想在其他地方重用换行计数逻辑。让我们重构它。在这些情况下，大师可以用`freevars`模式帮助我们。`freevars`模式显示在给定选择中被引用但未定义的变量。

让我们选择`visual`模式下的片段：

```
var count int
for i := 0; i < len(msg); i++ {
	if msg[i] == '\n' {
		count++
	}
}

```

选择后，请致电`:GoFreevars`。它应该是`:'<,'>GoFreevars`的形式。结果又是一个快速修复列表，它包含了所有自由变量的变量。在我们的例子中，它是一个单一变量，结果是：

```
var msg string

```

那么这有多有用呢？这一小块信息足以将其重构为一个独立的函数。创建包含以下内容的新函数：

```
func countLines(msg string) int {
	var count int
	for i := 0; i < len(msg); i++ {
		if msg[i] == '\n' {
			count++
		}
	}
	return count
}

```

您将看到内容是我们先前选择的代码。函数的输入是`:GoFreevars`，自由变量的结果。我们只决定归还什么（如果有的话）。在我们的情况下，我们返回计数。我们的`main.go`将采用以下形式：

```
package main

import "fmt"

func main() {
	msg := "Greetings\nfrom\nTurkey\n"

	count := countLines(msg)
	fmt.Println(count)
}

func countLines(msg string) int {
	var count int
	for i := 0; i < len(msg); i++ {
		if msg[i] == '\n' {
			count++
		}
	}
	return count
}

```

这就是重构一段代码的方法。`:GoFreevars`也可以用来理解代码的复杂性。只需运行它，看看有多少变量与之相关。

# Generate it

代码生成是一个热门话题。因为有很棒的std libs，比如go/ast、go/parser、go/printer等。。围棋的优势在于能够轻松地创造出伟大的发电机。

首先我们有一个`:GoGenerate`命令，它在引擎盖下调用`go generate`。它就像`:GoBuild`，`:GoTest`，等等。。如果有任何错误，它也会显示它们，以便您可以轻松地修复它。

### 实现接口的方法存根

接口对组合非常有用。它们使代码更容易处理。创建测试也更容易，因为您可以模拟接受接口类型的函数，该接口类型具有实现测试方法的类型。

`vim-go`支持工具impl。`impl`生成实现给定接口的方法存根。让我们将`main.go`的内容更改为以下内容：

```
package main

import "fmt"

type T struct{}

func main() {
	fmt.Println("vim-go")
}

```

将光标放在`T`的顶部，然后键入`:GoImpl`。系统将提示您编写接口。输入`io.ReadWriteCloser`，然后按enter键。您将看到内容更改为：

```
package main

import "fmt"

type T struct{}

func (t *T) Read(p []byte) (n int, err error) {
	panic("not implemented")
}

func (t *T) Write(p []byte) (n int, err error) {
	panic("not implemented")
}

func (t *T) Close() error {
	panic("not implemented")
}

func main() {
	fmt.Println("vim-go")
}

```

你看那真是太好了。当你在一个类型上面时，你也可以只输入`:GoImpl io.ReadWriteCloser`，它也会这样做。

但不需要将光标放在类型的顶部。你可以从任何地方调用它。例如，执行以下操作：

```
:GoImpl b *B fmt.Stringer

```

您将看到将创建以下内容：

```
func (b *B) String() string {
	panic("not implemented")
}

```

如您所见，这是非常有帮助的，特别是当您有一个带有大型方法集的大型接口时。您可以很容易地生成它，因为它使用`panic()`，所以编译时没有任何问题。只要把必要的部分填好就行了。

# Share it

`vim-go`还具有通过https://play.golang.org/与他人轻松共享代码的功能。正如你所知，围棋场是一个分享小片段、练习和/或提示和技巧的完美场所。有时候你在玩弄一个想法，想和别人分享。复制代码并访问play.golang.org，然后粘贴它。`vim-go`使用`:GoPlay`命令可以使所有这些都变得更好。

首先，让我们用以下简单代码更改`main.go`文件：

```
package main

import "fmt"

func main() {
	fmt.Println("vim-go")
}

```

现在调用`:GoPlay`，然后按enter键。您将看到`vim-go`自动上载了源代码`:GoPlay`，并且还打开了一个显示它的浏览器选项卡。但还有更多。代码段链接也会自动复制到剪贴板。只需将链接粘贴到某个地方。你会看到链接与正在播放的内容相同play.golang.org.

`:GoPlay`也接受一个范围。您可以选择一段代码并调用`:GoPlay`。它只会上传所选的部分。

有两个设置可以调整`:GoPlay`的行为。如果您不喜欢`vim-go`为您打开一个浏览器选项卡，您可以使用以下命令禁用它：

```
let g:go_play_open_browser = 0

```

其次，如果您的浏览器被错误检测到（我们使用的是`open`或`xdg-open`），您可以通过以下方式手动设置浏览器：

```
let g:go_play_browser_command = "chrome"

```

# HTML template

默认情况下，`.tmpl`文件启用了gohtml模板的语法高亮显示。如果要为另一个文件类型启用它，请将以下设置添加到`.vimrc`：

```
au BufRead,BufNewFile *.gohtml set filetype=gohtmltmpl

```

# Donation

本教程是我在业余时间创作的。如果你喜欢并愿意捐款，你现在可以成为一个完全的支持者，成为一个赞助人！

作为一个用户，你使vim-go成长和成熟，帮助我投资于错误修复、新文档，并改进当前和未来的功能。它是完全可选的，只是支持vim-go's正在进行的开发的一种直接方法。谢谢！

[https://www.patreon.com/fatih](javascript:void(0);)

## TODO Commands

- :GoPath
- :AsmFmt
