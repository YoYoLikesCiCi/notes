

- `zr`: reduces fold level throughout the buffer
- `zR`: opens all folds
- `zm`: increases fold level throughout the buffer
- `zM`: folds everything all the way
- `za`: open a fold your cursor is on
- `zA`: open a fold your cursor is on recursively
- `zc`: close a fold your cursor is on
- `zC`: close a fold your cursor is on recursively
- 

| vi[m] + file     | 打开[新建]文件                                |
| ---------------- | --------------------------------------------- |
|                  |                                               |
| 【命令模式】     | 可以移动光标、删除字符等                      |
| h,j,k,l          | 左，下，上，右                                |
| Blankspace       | 向右                                          |
| Backspace        | 向左                                          |
| Enter            | 移动到下一行首                                |
| -                | 移动到上一行首                                |
| b                | 上一个词的词首                                |
| w                | 下一个词的词首                                |
| e                | 下一个词的词尾                                |
| ^                | 行首                                          |
| $                | 行尾                                          |
| f/F + 字符       | 向前/向后移动到特定的字符（行内）             |
| gg               | 文件的第一行                                  |
| G                | 文件的最后一行                                |
| nG               | 移动到第n行                                   |
| n+               | 向下跳n行                                     |
| n-               | 向上跳n行                                     |
| /字              | 正向查找搜素字符串                            |
| ?字              | 反向查找搜素字符串                            |
| n                | 向下搜索前一个搜素动作                        |
| N                | 向上搜索前一个搜索动作                        |
| x                | 删除字符                                      |
| nx               | 删除从光标开始的n个字符                       |
| df + 字符        | 删除从当前字符到指定字符                      |
| dw/daw           | 删除单词                                      |
| d$               | 删除从当前光标到行尾                          |
| dd               | 删除当前行                                    |
| ndd              | 向下删除当前行在内的n行                       |
| dd + p           | delete一行，然后放在当前光标下方              |
| dd + P           | delete一行，然后放在当前光标上方              |
| dw + p           | delete单词，然后放在当前光标后面              |
| dw + P           | delete单词，然后放在当前光标前面              |
| p/P              | 重复粘贴，粘贴剪切板里的内容在光标后/前       |
| yw               | 复制单词                                      |
| yf + 字符        | 复制从当前字符到指定字符                      |
| yy               | 复制整行                                      |
| y$               | 复制当前光标到行尾的内容                      |
| y^               | 复制从光标到行首的内容                        |
| J                | 合并光标所在行及下一行为一行                  |
| .                | 重复上一个操作                                |
| n+action         | 表示执行某个操作n次                           |
| u                | 撤销上一步操作                                |
| U                | 撤销对当前行的所有操作                        |
| ctrl + r         | 重做                                          |
| ctrl + b         | 向前翻一页                                    |
| ctrl + f         | 向后翻一页                                    |
| ctrl + u         | 向前翻半页                                    |
| ctrl + d         | 向后翻半页                                    |
| ctrl + e         | 下滚一行                                      |
| :set nu          | 显示行号                                      |
| :set nonu        | 取消显示行号                                  |
| :s/old/new       | 用new替换行中首次出现的old                    |
| :s/old/new/g     | 用new替换行中所有的old                        |
| :n,m s/old/new/g | 用new替换从n到m行里所有的old                  |
| :%s/old/new/g    | 用new替换当前文件里所有的old                  |
| :w               | 保存正在编辑的文件                            |
| :w new.txt       | 保存至new.tex文件                             |
| :q               | 退出不保存（文件未修改时）                    |
| :q!              | 退出编辑器，且不保存                          |
| :wq              | 保存后退出正在编辑的文件                      |
| :help            | 显示相关命令的帮助                            |
|                  |                                               |
| 【选择模式】     |                                               |
| v                | 不规则选择                                    |
| V                | 按行选择                                      |
| Ctrl + v         | 按列选择                                      |
|                  |                                               |
| 【插入模式】     | 在此模式下可以输入字符，按ESC将回到命令模式。 |
| i                | 在当前字符前面插入                            |
| I                | 在行首插入                                    |
| a                | 在当前字符后面插入                            |
| A                | 在行尾插入                                    |
| o                | 在当前行的下一行插入                          |
| O                | 在当前行的上一行插入                          |
| r                | 更改当前的字符                                |
| R                | 更改多个字符                                  |
| cw/caw           | 更改单词                                      |
| cf + 字符        | 更改从当前字符到指定字符                      |
| c$               | 更改从当前字符到行尾                          |
| cc               | 更改整行                                      |