# Chapter: List

**定义**： 具有 <mark>相同数据类型</mark> 的n（n>=0) 个数据元素的<mark>有限序列</mark>。

n 表长
$$ L = (a_1,a_2,a_3,\dots,a_i \quad a_{i+1}, \dots,a_n)$$ 

位序从1开始

直接前驱、、、、直接后继

## 一、基本操作

```c++
InitList (&L)  初始化      \\构造、分配内存空间
DestroyList (&L) 销毁     \\销毁、释放内存空间
ListInsert (&L, i , e) 插入
ListDelete (&L, i , &e) 删除
LocateElem (L,e)  按位
GetElem (L,i) 按值
```

创、销、增、删、改、查

## 二、 顺序表的定义
顺序表: 用 <mark>顺序存储</mark> 的方式实现线性表顺序存储.  

线性表的顺序存储 \-\- \- *把逻辑上相邻的两个元素在物理位置上也相邻*的存储单元中.

### 1. 静态分配初始化 <u>---  一开始长度确定</u>

```C++
#define Maxsize 10 
typedef struct{
    ElemType date[Maxsize]; // 用静态的“数组”存放数据元素
    int length;  //顺序表的当前长度 
}SqList;


//基本操作-初始化一个顺序表
void InitList(Sqlist &L){
    for(int i=0; i<Maxsize; i++){
        L.data[i] = 0;
    }
    L.length = 0
}

int main(){
    SqList L;
    InitList(L);
    //.....后续操作
    return 0;
}
```

### 动态分配初始化 

```C++
#define InitSize 10
typedef struct{
    ElemType *data;
    int MaxSize;
    int length;
}SeqList;

void InitList(SeqList &L){
    L.data = (int *)malloc(InitSize * sizeof(int));
    L.length = 0;
    L.MaxSize = InitSize;
}

//动态增加数组的长度
void IncreaseSize(SeqList &L\quad int len){
    int *p = L.data;
    L.data = (int *)malloc((L.MaxSize + len) * sizeof(int));
    for(int i = 0; i < L.length ; i++){
        L.data[i] = p[i];
    }
    L.MaxSize = L.MaxSize + len;
	free(p);
	
}
L.data = (ElemType *)malloc(sizeof(ElemType)* InitSize);
```

特点：

1.  随机访问
  
2.  存储密度高
  
3.  拓展容量不方便
  
4.  插入、删除不方便
  

### 2. 插入

```C++
void ListInsert(SqList &L, int i, int e){
    for(int j = L.length; j>=i; j--){
        L.data[j] = L.data[j-1];
    }
    L.data[i-1] = e;
    L.length++;
} //不够健壮
bool ListInsert(SqList &L, int i, int e){
    if( i<1 || i>L.length+1)
        return false;
    if( L.length >= Maxsize)
        return false;
    for(int j=L.length; j>=i; j--){  //将第i个元素及之后的元素后移
        L.data[j] = L.data[j-1]
    }
    L.data[i-1] = e;
    L.length++;
    return true;
}
```

时间复杂度：

最好： i = n+1 0次 O(1)

最坏： i = 1 n次 O(n)

平均： np + (n-1)p + (n-2)p + ... + p = $\frac{n(n+1)}{2}·\frac{1}{n+1} = \frac{n}{2} \rightarrow$ O(n)

### 3. 删除
```C++
//删除操作
Bool ListDelete(SqList &L, int i, int &e){
    if ( i<1 || i > L.length)
        return false;
    e = L.data[i-1];
    for(int j=i; j < L.length; j++){
        L.data[j-1]= L.data[j];
    }
    L.length--;
    return true;
}

int main(){
    SqList L;
    InitList(L);
    
    int e = -1;
    if (ListDelete(L, 3, e))
        printf("已删除第3个元素，删除元素值为 = %d", e);
    else
        printf("位序i不合法，删除失败");
    return 0;
}
```

时间复杂度： $\frac{n-1}{2} \rightarrow O(n)$

### 4. 查找

```C++
//按位查找
ElemType GetElem(SeqList L, int i){
    return L.data[i-1];
}
//在顺序表L VS查找第一个元素值等于e的元素，并返回其位序
int LocateElem(SeqList L, int e){
    for(int i=0; i<L.length; i++){
        if(L.data[i] == e)   //结构体不可以用 “==”，手写代码可以
            return i+1;
    }
    return 0;
}
```

时间复杂度：$\frac{n}{2} \rightarrow O(n)$



## 三、链表

### 1. 单链表

```C++
typedef struct LNode{
    ElemType data;
    struct LNode *next;
}LNode, *LinkList;

struct LNode * p = (struct LNode *) malloc (sizeof(struct LNode));
//增加一个新的结点：在内存中申请一个节点所需空间，并用指针p指向这个结点
```

![image-20200831232609949](http://picbed.yoyolikescici.cn/uPic/image-20200831232609949.png)

#### 初始化单链表

不带头结点：

```C++
bool InitList(LinkList &L){
    L = NULL;
    return true;
}
```

带头结点：

```C++
bool InitList(LinkList &L){
    L = (LNode *)malloc(sizeof(LNode));
    if( L == NULL)
        return false;
    L -> next = NULL;
    return true;
}
```

#### 插入和删除

##### 按位序插入(带头结点)：

```C++
bool ListInsert(LinkList &L, int i, ElemType e){
    if( i<1 )
        return false
    LNode *p;
    int j = 0 ;
    p = L;
    while (p != NULL && j< i-1){
        p = p->next;
        j++;
    }              //先判断合法性，再执行操作
    if (p==NULL)
        return false;
    LNode *s = (LNode *)malloc(sizeof(LNode));
    s->data = e;
    s->next = p->next;
    p->next = s;
    return true;
}
```

##### 按位序插入(不带头结点)
```C++
bool ListInsert(LinkList &L, int i, ElemType e){
    if (i < 1)
        return false;
    if(i==1){
        LNode * s = (LNode *)malloc(sizeof(LNode));
		s -> data = e;
		s -> next = L;
		L = s ;
		return true;
	}
	LNode *p;
    int j = 1 ;
    p = L;
    while (p != NULL && j< i-1){
        p = p->next;
        j++;
    }              //先判断合法性，再执行操作
    if (p==NULL)
        return false;
    LNode *s = (LNode *)malloc(sizeof(LNode));
    s->data = e;
    s->next = p->next;
    p->next = s;
    return true;

}
```
##### 在定结点后插 
```C++
bool InsertNextNode(LNode *p, ElemType e){
    if(p == NULL)
        return false;
    LNode *s = (LNode *)malloc(sizeof(LNode));
    if (s == NULL)
        return false;
    s->data = e;
    s->next = p->next;
	p->next = s;
	return true;
}
```
##### 在定结点前插--偷天换日

```C++
bool InsertPriorNode(Lnode *p, ElemType e){
    if (p==NULL)
        return false;
    LNode *s = (LNode *)malloc(sizeof(LNode));
    if (s==NULL)
        return false;
    s->next = p->next;
    p->next = s;
    s->data = p->data;
    p->data = e;
    return true;
}
```

##### 按位序删除(带头结点)

```C++
bool ListDelete(LinkList &L, int i, ElemType &e){
    if ( i<1)
        reutrn false;
    LNode *p;
    int j = 0;
    p = L;
    while ( p != NULL && j <i-1 )f{    //循环找到第i-1ge结点
        p = p->next;
        j++;
    }
    if ( p==NULL )
        return false;
    if (p->next == NULL)
        return false;
    LNode *q = p->next;
    e = q->data;
    p->next = q->next;
    free(q);
    return true;
}
```

##### 删除指定结点：

```C++
//如果是最后一个元素有bug
bool DeleteNode( LNode *p ){
    if (p == NULL)
        return false;
    LNode *q = p->next;
    p->data = p->next->data;
    p->next = q->next;
    free(q);
    return true
}
```

#### 查找

##### 按位查找

```c++
LNode * GetElem(LinkList L, int i){
    if( i<0 ){
        return NULL;
    }
    LNode *p;
    int j = 0;
    p = L;
    while ( p!= NULL && j < i){
        p = p->next;
        j++;
    }
    return p;
}
```

##### 按值查找

```C++
LNode * LocateElem(LinkList L, ElemType e){
    LNode *p = L->next;
    while( p!=NULL && p->data != e){
        p = p->next;
    }
    return p;
}
```

#### 建立

$$
\left\{ \begin{matrix} 尾插法 \\ 头插法 \end{matrix} 
\right. 
\rightarrow 核心： 初始化、插入
$$

##### 尾插法：

```C++
LInkList List_TailInsert(LinkList &L){
    int x;
    L = (LinkList)malloc(sizeof(LNode));
    LNode *s, *r = L;
    scanf("%d", &x);
    while(X!=9999){//输入9999表示结束
        s = (LNode *)malloc(sizeof(LNode));
        s->data = x;
        r->next = s;
        r = s;
        scanf("%d",&x);
    }
    r -> next = NULL;
    return L;
}
```

![image-20200901181550307](http://picbed.yoyolikescici.cn/uPic/image-20200901181550307.png)

头插法

```C++
LinkList List_HeadInsert(LinkList &L){
    LNode *s;
    int x;
    L = (LinkList)malloc(sizeof(LNode));
    L->next = NULL;  //初始化，养成好习惯，防止脏数据
    scanf("%d", &x);
    while( x!= 9999){
        s = (LNode *)malloc(sizeof(LNode));
        s->data = x;
        s->next = L->next;
        L->next = s;
        scanf("%d", &x);
    }
    return L;
}
```

![image-20200901183438056](http://picbed.yoyolikescici.cn/uPic/image-20200901183438056.png)

### 2\. 双链表

```C++
typedef struct DNode{
    ElemType data;
    struct DNode *prior, *next;  
}DNode, *DLinklist;

//初始化
bool InitDLinkList(DLinklist &L){
    L = (DNode *)malloc(sizeof(DNode));
    if (L==NULL)
        return false;
    L -> prior = NULL;
    L -> next = NULL;
    return true; 
}

//插入，p后插入s 
bool InsetNextDNode(DNode *p, DNode *s){
    s->next = p->next;
    p->next->prior = s;
    s->prior = p;
    p->next = s;
}

//插入，考虑p是最后一个（健壮性）
bool InsetNextDNode(DNode *p, DNode *s){
    if ( p==NULL || s== NULL)
        return false;
    s->next = p->next;
    if (p->next != NULL)
        p->next->prior = s;
    s->prior = p;
    p->next = s;
    return true;
}

//删除 p的后继结点
p->next = q->next;
q->next->prior = p;
free(q);

//删除，考虑p是最后一个（健壮性）
bool DeleteNextDNode(DNode *p){
    if (p == NULL)
        return false;
    DNode *q = p->next;
    if (q == NULL)
        return false;
    p->next = q->next;
    if (q->next != NULL)
        q->next->prior = p;
    free(q);
    return true;
}
```

### 3\. 循环链表

### 4.静态链表

#### 定义：

单链表：各个结点在内存中星罗棋布、散落天涯。

静态链表：分配一整片连续的内存空间，各个结点集中安置。

通俗理解：用数组实现单链表，指针就是数组下标

![image-20200901190555746](http://picbed.yoyolikescici.cn/uPic/image-20200901190555746.png)

代码：

```C++
#define MaxSize 10 //静态链表的最大长度
typedef struct{
    ElemType data;
    int next;
} SLinkList[MaxSize];

```

![image-20200901191320338](http://picbed.yoyolikescici.cn/uPic/image-20200901191320338.png)

## 四、 顺序表和链表的对比

![image-20200901193102281](http://picbed.yoyolikescici.cn/uPic/image-20200901193102281.png)

# 第三章 栈和队列

## 1\. 栈

定义：只允许在一端进行插入或删除操作的线性表。

栈顶：线性表允许进行插入删除的那一端。

栈底：固定的，不允许进行插入和删除的另一端。

空栈：不含任何元素的空表。

后进先出 Last In First Out LIFO

数学性质： n个不同元素进栈，出栈元素不同排列的个数为 $$\frac{1}{n+1}C^{n}_{2n} \quad 
\rightarrow$$又叫卡特兰数 Catalan

### 基本操作

```
InitStack( &S):
StackEmpty(S):判断一个栈是否为空
Push(&S, x):进栈，未满，则将x加入使其成为栈顶
Pop(&S, &x):出栈，若S非空，则弹出栈顶元素，并用x返回
GetTop(&S, &x):读栈顶元素
DestroyStack(&S):销毁栈，并释放栈S占用的存储空间
```

### 栈的顺序存储结构

#### 1.顺序栈的实现

```C++
#define MaxSize 10
typedef struct{
    ElemType data[MaxSize];
    int top;  //栈顶指针
}SqStack;

//初始化栈
void InitStack(SqStack &S){
   S.top = -1;
}

//判断栈空
bool StackEmpty(SqStack S){
    if (S.top == -1)
        return true;
    else
        return false;
}
//进栈
bool Push(SqStack &S, ElemType x){
    if (S.top == MaxSize -1 ){
        return false;   	//栈满，报错
    }
    S.top = S.top + 1;
    S.data[S.top] = x;
    return true;
}

//出栈
bool Pop(SqStack &S,Elemtype &x){
    if (S.top == -1){
        return false; //栈空，报错
    }
    x = S.data[S.top];
    S.top--;
    return true;
}
//读栈顶元素
bool GetTop(SqStack S, ElemType &x){
    if(S.top == -1)
        return false;
    x = S.data[S.top];
    return true;
}
```

### 栈的链式存储结构

## 2\. 队列

定义：只允许在一端进行插入，在另一端删除的线性表。

队头、队尾、空队列

特性：先进先出

FIFO

### 基本操作：

```
InitQueue(&Q):
DestroyQueue(&Q):
EnQueue(&Q,x):
DeQueue(&Q, &x):
GetHead(Q,&x):
QueueEmpty(Q):

```

### 顺序实现：

```C++
#define MaxSize 10
typedef struct{
    ElemType data[MaxSize];
    int front,rear;//队头和队尾指针
    //队尾指针指向队尾元素的后一个位置 
}SqQueue;

bool InitQueue(SqQueue &Q){
    Q.rear = Q.front = 0;
}

bool QueueEmpty(SqQueue Q){
    if (Q.rear == Q.front)
        return true;
    else
        return false;
}
//队列已满的条件：队尾指针的再下一个位置是队头
bool EnQueue(SqQueue &Q,ElemType x){
    if((Q.rear+1)%MaxSize == Q.front)
        return false;
    Q.data[Q.rear] = x;
    Q.rear = (Q.rear+1)%MaxSize;
    return true;
}

bool DeQueue(SqQueue &Q, ElemType &x){
    if (Q.rear == Q.front)
        return false;
    x = Q.data[Q.front];
    Q.front = (Q.front+1) % MaxSize;
    return true;
}

bool GetHead(SqQueue Q, ElemType &x){
    if(Q.rear==Q.front)
        return false;
    x = Q.data[Q.front];
    return true;
}
//队列元素个数：
//(rear + MaxSize - front) % MaxSize
 
```

![image-20200908091233988](http://picbed.yoyolikescici.cn/uPic/image-20200908091233988.png)

### 链式实现：

```C++
//带头节点
typedef struct LinkNode{
    ElemType data;
    struct LinkNode *next;
}LinkNode;


typedef struct{
    LinkNode *front,*rear;
}LinkQueue;

//初始化（带头节点）
void InitQueue(LinkQueue &Q){
    Q.front = Q.rear = (LinkNode*)malloc(sizeof(LinkNode));
    Q.front->next = NULL;
}
bool isEmpty(LinkQueue Q){
    if (Q.front == Q.rear)
        return true;
    else
        return false; 
}
void EnQueue(LinkQueue &Q,ElemType x){
    LinkNode *s = (LinkNode *)malloc(sizeof(LinkNode));
    s -> data= x;
    s -> next = NULL;
    Q.rear->next = s;
    Q.rear = s;
}
bool DeQueue(LinkQueue &Q, ElemType &x){
    if (Q.front == Q.rear)
        return false;
    LinkNode *p = Q.front -> next;
    x = p->data;
    Q.front -> next = p -> next;
    if (Q.rear == p)
        Q.rear = Q.front;
    free(p);
    return true;
}

//不带头节点入队
void EnQueue(LinkQueue &Q,ElemType x){
    LinkNode *s = (LinkNode *)malloc(sizeof(LinkNode));
    s->data = x;
    s->next = NULL;
    if (Q.front == NULL){
        Q.front = s;
        Q.rear = s;
    }else{
        Q.rear->next = s;
        Q.rear = s;
    }
}

bool DeQueue(LinkQueue &Q, ElemType x){
    if (Q.front == NULL)
        return false;
    LinkNode *p = Q.front;
    x = p->data;
    Q.front = p->next;
    if (Q.rear == p){
        Q.front = NULL;
        Q.rear = NULL;
    }
    free(p);
    return true;
}
```

### 双端队列：

考点：判断输出序列合法性

## 3\. 栈和队列的应用

### 括号匹配

![image-20200908100222007](/Applications/Joplin.app/Contents/Library/Application%20Support/typora-user-images/image-20200908100222007.png)


```C++
#define MaxSize 10
typedef struct{
    char data[MaxSize];
    int top;
}SqStack;

bool bracketChect(char str[], int length){
    SqStack S;
    InitStack(S);
    for (int i=0; i < length; i++){
        if (str[i] == '(' || str[i] = '[' || str[i] == '{'){
            Push(S,str[i]);
        }else{
            if (StackEmpty(S)) //扫描到右括号，且当前栈空
                return false; //匹配失败
         
            char topElem;
            Pop(S, topElem); //栈顶元素出栈
            if(str[i]==')' && topElem!='(' )
                return false;
            if(str[i]==']' && topElem!= '[')
                return false;
            if(str[i] == '}' && topElem!='{')
                return false;
        }
    }
    return StackEmpty(S);
}
```

### 表达式求值

Reverse Polish notation (逆波兰表达式=后缀表达式)

Polish notation (波兰表达式=前缀表达式)

![image-20200908112514164](http://picbed.yoyolikescici.cn/uPic/image-20200908112514164.png)

![image-20200908112749250](http://picbed.yoyolikescici.cn/uPic/image-20200908112749250.png)

![image-20200908113730261](http://picbed.yoyolikescici.cn/uPic/image-20200908113730261.png)

![ ](http://picbed.yoyolikescici.cn/uPic/image-20200908120159623.png)

![image-20200908123611295](/Applications/Joplin.app/Contents/Library/Application%20Support/typora-user-images/image-20200908123611295.png)

### 递归

函数调用时，需要一个栈存储：

1.  调用返回地址
2.  实参
3.  局部变量

### 树的层次遍历

### 图的广度优先遍历

## 4\. 特殊矩阵的压缩存储

### 对称矩阵

$$
a_{i,j} = a_{j,i}
$$

普通存储：n*n二维数组

策略：只存储主对角线+下三角区

按行优先原则将个元素存入一维数组中

### 三角矩阵

下三角矩阵：除了主对角线和下三角区，其余的元素都相同

策略：按行优先原则将橙色区元素存入一维数组种。并在最后一个位置存储常量c

### 三对角矩阵

当 $$|i-j|>1$$时，有$$a_{i,j}=0 (1\\leq i,j \\leq n)$$

策略：按 行优先原则，只存储带状部分

### 稀疏矩阵

非零元素远远少于矩阵元素的个数

策略：

顺序存储\-\- 三元组&lt;行，列，值&gt;

链式存储：十字链表法

![image-20200908133205028](http://picbed.yoyolikescici.cn/uPic/image-20200908133205028.png)

# 第四章 串

定义：即 字符串（String），是由零个或多个字符组成的有限序列。

子串：串中任意个 连续的字符组成的子序列。

主串：包含子串的串。

==字符在主串中的位置：==字符在串中的序号。

子串在主串中的位置： 子串的第一个字符在主串 中的位置

## 串vs线性表

- 串是一种特殊的线性表，数据元素之间呈现线形关系
- 串的数据对象限定为字符集
- 串的基本操作，如增删改查 通常以子串为操作对象

## 基本操作

```cpp
StrAssign(&T,chars):赋值
StrCopy(&T,S):复制
StrEmpty(S):判空
StrLength(S):求串长
ClearString(&S):清空
DestroyString(&S):销毁（回收存储空间）
Concat(&T,S1,S2)：串连接，返回s1，s2连接而成的新串
SubString(&Sub,S,pos,len):求子串，用Sub返回串S的第pos个字符起长度为len的子串
Index(S,T):定位操作。若主串S中存在与串T值相同的子串，则返回它在主串S中第一次出现的位置，否则函数值为0
StrCompare(S,T):比较操作，若S>T，返回值>0

```

考研默认每个字符占1B

## 串的存储结构

### 串的顺序存储

```C++
#define MAXLEN 255
//静态数组实现
typedef struct{
    char ch[MAXLEN];
    int length;
}SString;

//动态数组实现（堆分配存储）
typedef struct{
    char *ch;
    int length;
}HString;
HString S;
S.ch = (char *)malloc(MAXLEN * sizeof(char));
S.length = 0;

```

![image-20200910143726629](/Applications/Joplin.app/Contents/Library/Application%20Support/typora-user-images/image-20200910143726629.png)

### 串的链式存储

```C++
typedef struct StringNode{
    char ch;
    //使用 char ch[4] 可以提高存储密度
    struct StringNode * next;
}StringNode, *String;

```

## 基本操作的实现

```C++
#define MAXLEN 255
//静态数组实现
typedef struct{
    char ch[MAXLEN];
    int length;
}SString;

bool SubString(SString &Sub, SString S, int pos, int len){
    if (pos+len-1 > S.length)
        return false;
    for (int i=pos; i<pos+len; i++){
        Sub.ch[i-pos+1] = S.ch[i];
    }
    Sub.length = len;
    return true;
}
//比较操作。若S>T,则返回值>0;若S=T，则返回值=0；若S<T,则返回值<0
int StrCompare(SStrign S, SString T){
    for (i = 0; i<=S.length && i<=T.length;i++){
        if (S.ch[i] != T.ch[i]){
            return S.ch[i]-T.ch[i];
        }
    }
    return S.length - T.length;  //扫描过的所有字符都相同，则长度长的串更大
}
//定位操作,S为主串，T为子串
可以先sub再compare
Index(S,T){
    int i=1, n=StrLength(S), ,=StrLength(T);
    SString sub;
    while(i<=n-m+1){
        SubString(sub,S,i,m);
        if(StrCompare(sub,T)!=0)
            ++i;
        else
            return i;
    }
    return 0;  //不存在与T相等的子串
}
```

![image-20200910145126709](http://picbed.yoyolikescici.cn/uPic/image-20200910145126709.png)

## 朴素匹配模式算法

主串： S = 'wangdao'

子串：'wang', 'ang', 'ao'----一定在主串中存在的才叫“子串”

模式串：'gda', 'bao' ----想尝试在主串中找到的串，未必存在

==串的匹配模式：==在主串中找到与模式串相同的子串，并返回其所在位置。

Index(S,T):定位操作（模式匹配）。

![image-20200911143658593](http://picbed.yoyolikescici.cn/uPic/image-20200911143658593.png)

```C++
int Index(SString S, SString T){
    int k = 1;
    int i = k, j = 1;
    while( i<=S.length && j<=T.length){
        if (S.ch[i] == T.ch[j]){
            ++j;
            ++i;
        }else{
            k++;
            i=k;
            j=1;
        }
    }
    if(j>T.length)
        return k;
    else
        return 0;
}
//匹配成功的最好时间复杂度：O(m)
//匹配失败的最好时间复杂度：O(n-m+1)=O(n-m) ~~ O(n)

```

## KMP算法

由 D.E.Knuth, J.H.Morris & V.R.Pratt 提出，因此称为KMP算法

![image-20200911150931210](http://picbed.yoyolikescici.cn/uPic/image-20200911150931210.png)

```C++
int Index_KMP(SSTring S, SString T, int next[]){ //next[]是一个特殊数组，标记了j应该溯洄到哪一个位置
    int i = 1, j = 1;
    while(i<=S.length && j <= T.length){
        if (j==0||S.ch[i]==T.ch[i]){
            ++i;
            ++j;
        }else{
            j = next[j];
        }
    }
    if( j>T.length)
        return i-T.length;
    else
        return 0;
}
```

![image-20200911155448964](/Applications/Joplin.app/Contents/Library/Application%20Support/typora-user-images/image-20200911155448964.png)

## KMP算法求NEXT数组

next数组：当模式串的第j个字符匹配失败时，令模式串跳到next\[j\]再继续匹配

串的前缀：包含第一个字符，且不包含最后一个字符的子串

串的后缀：包含最后一个字符，且不包含第一个字符的子串

当第j个字符匹配失败，由前1~j-1个字符组成的串记为S，则

next\[j\] = S 的最长相等前后缀长度+1

特别的， next\[1\] = 0

![image-20200911165046995](http://picbed.yoyolikescici.cn/uPic/image-20200911165046995.png)

![image-20200911165145028](http://picbed.yoyolikescici.cn/uPic/image-20200911165145028.png)

```C++
//求模式串的next数组
void get_next(SString T, int next[]){
    int i=1, j=0;
    next[1] = 0;
    while(i<T.length){
        if (j==0 || T.ch[i]==T.ch[j] ){
            ++i;
            ++j;
            next[i] = j;
        }
        else
            j = next[j];
    }
}
//KMP算法
int Index_KMP(SString S, SString T){
    int i=1, j=1;
    int next[T.length+1];
    get_next(T,next);
    while(i<=S.length && j<=T.length){
        if (j==0 || S.ch[i] == T.ch[j]){
            ++i;
            ++j;
        }
        else
            j = next[j];
    }
    if (j>T.length)
        return i- T.length;
    else
        return 0;
}
```

## KMP算法优化：

nextval数组

![image-20200911172418043](http://picbed.yoyolikescici.cn/uPic/image-20200911172418043.png)

# 第五章 树与二叉树

## 基本概念

空树：结点数为0的树

非空树：有且仅有一个根结点

![image-20200914235253884](/Applications/Joplin.app/Contents/Library/Application%20Support/typora-user-images/image-20200914235253884.png)

非空树的特性：

- 有且仅有一个根结点
- 没有后继的结点称为“叶子结点”（或终端结点）
- 有后继结点的称为“分支结点”（或非终端结点）
- 除了根结点外，任何一个结点都有且仅有一个前驱
- 每个结点可以有0个或多个后继

树是n(n>=0)个结点的有限集合，n=0时，称为空树，这是一种特殊情况。

任意一棵非空树中应满足：

1.  有且仅有一个特定的称为根的结点。
2.  当n>1时，其余结点可分为m(m>0)个互不相交的有限集合t1,t2,...,tm, 其中每个集合本身又是一棵树，并且称为根结点的子树。

![image-20200914235803050](http://picbed.yoyolikescici.cn/uPic/image-20200914235803050.png)

1.  祖先结点：K到A的唯一路径上的任意结点，称为K的祖先。 如B

K是B的子孙结点

E为K的双亲

K为E的孩子

有相同相亲的称为兄弟结点

2.  一个结点的孩子个数称为 该结点的度，树中结点的最大度数称为树的度。
  
3.  度大于0的结点称为分支结点；度为0称为叶子结点。
  
4.  结点的层次从树根开始定义，根结点为第一层，它的子结点为第2层。双亲在同一层的结点互为堂兄弟。
  
    结点的深度是从根结点开始自顶向下逐层累加的。
    
    结点的高度是从叶结点自底向上逐层累加的。
    
5.  树中结点的各子树从左到右是有次序的，不能互换，称该树为有序树，否则称为无序树。
  
6.  树中两个结点之间的路径是由这两个结点之间所经过的结点序列构成的，而路径长度是路径上所经过的边的个数。
  
7.  森林是m(m>=0)棵互不相交的树的集合。森林的概念与树的概念十分相近，因为只要把书的根结点删去就成了森林。反之，只要给m棵独立的树加上一个结点，并把这m棵树作为我该结点的子树，则森林就变成了树。
  

## 树的常考性质

1.  结点数 = 总度数+1
  
2.  度：各结点的度的最大值
  

m叉树：每个结点最多只能由m个孩子的树

| 度为m的树 | m叉树 |
| --- | --- |
| 任意结点的度<=m | 任意结点的度<=m |
| 至少有一个结点度=m | 允许所有结点的度都<m |
| 一定是非空树，至少有m+1个结点 | 可以是空树 |

3.  度为m的树第i层至多有$$m^{i-1}$$个结点（i>=1)
  
4.  高度为h的m叉树至多有$$\frac{23}{23}$$



