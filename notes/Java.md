Java

# StringBuilder

```java
1）构造函数

StringBuilder有四个构造函数：

StringBuilder() value内容为空，并设置容量为16个字节；
StringBuilder(CharSequece seq)  使用seq初始化，容量在此基础上加16；
StringBuilder(int capacity) 设置特定容量；
StringBuilder(String str)  使用str初始化，容量str大小的基础上加16；
（2）append方法

由于继承了Appendable接口，所以要实现append方法，StringBuilder类对几乎所有的基本类型都重载了append方法：

append(boolean b)
append(char c)
append(char[] str)
append(char[] str,int offset,int len)
append(CharSequence s)
append(CharSequence s,int start,int end)
append(double d)
append(float f)
append(int i)
append(long lng)
append(Object obj)
append(String str)
append(StringBuffer sb)
（3）insert方法

insert方法可以控制插入的起始位置，也几乎对所有的基本类型都重载了insert方法：

insert(int offser,boolean b)
insert(int offset,char c)
insert(int offset,char[] str)
insert(int index,char[] str,int offset,int len)
insert(int dsfOffset,CharSequence s)
insert(int dsfOffset,CharSequence s,int start,int end)
insert(int offset,double d)
insert(int offset,float f)
insert(int offset,int i)
insert(int offset,long l)
insert(int offset,Object obj)
insert(int offset,String str)
（4）其它会改变内容的方法

上面的那些方法会增加StringBuilder的内容，还有一些方法可以改变StringBuilder的内容：

StringBuilder delete(int start,int end) 删除从start到end（不包含）之间的内容；
StringBuilder deleteCharAt(int index) 删除index位置的字符；
StringBuilder replace(int start,int end,String str) 用str中的字符替换value中从start到end位置的子序列；
StringBuilder reverse() 反转；
void setCharAt(int index,char ch) 使用ch替换位置index处的字符；
void setLength(int newLength) 可能会改变内容（添加'\0'）；
（5）其它常用方法

下面这些方法不会改变内容：

int capacity() 返回value的大小即容量；
int length() 返回内容的大小，即count；
char charAt(int index) 返回位置index处的字符；
void ensureCapacity(int minimumCapacity) 确保容量至少是minimumCapacity；
void getChars(int srcBegin,int srcEnd,char[] dst,int dstBegin) 返回srcBegin到srcEnd的字符到dst；
int indexOf(String str) 返回str第一次出现的位置；
int indexOf(String str,int fromIndex) 返回从fromIndex开始str第一次出现的位置；
int lastIndexOf(String str) 返回str最后出现的位置；
int lastIndexOf(String str,int fromIndex) 返回从fromIndex开始最后一次出现str的位置；
CharSequence subSequence(int start,int end) 返回字符子序列；
String substring(int start) 返回子串；
String substring(int start,int end) 返回子串；
String toString() 返回value形成的字符串；
void trimToSize() 缩小value的容量到真实内容大小；

```

