[TOC]
# Chapter 1 Introduction 
## 1.2 Purpose of DS
### disadvantages of keeping organizational information in a file-processing system :
1. data redundancy and inconsistency 数据的冗余和不一致
2. difficulty in accessing data 
3. data ioslation 数据孤立
4. integrity problem 完整性问题  
5. atomicity problem 
6. concurrent-access anomaly 并发访问异常 
7. security problem 

## 1.3 View of Data 
### 1.3.1 Data Abstraction 
- Physical level 
- Logical level 
- View level 


### 1.3.2 instances and schemas 实例和模式
var x = 5     
instance : 5 now  
schemas : x

### 1.3.3 data models 
1. relational model 
> uses a collection of tables to represent both data and the relationships among those data . 
2. entity-relationship model 
3. object-based data model 
4. semistructured data model 
> XML 

## 1.4 Database Languages 
- data-definition language 
- data-manipulation language 数据操纵语言  
### 1.4.1 data-manipulation language 
- retrieval 检索
- insert
- delete
- modify


two types:
- Procedual DML
- declarative DML  


## 1.7 data storage and querying 
### 1.7.1 storage manager
负责在数据库中存储的低层数据与应用程序以及向系统提交的查询之间提供接口的部件.  
原始数据通过os提供的文件系统存储在磁盘上.  
存储管理器将各种DML语句翻译为底层文件系统命令.  
include: 
- authorization and integrity manager 权限及完整性管理器  
- transaction manager 
> 确保即使发生故障,数据库也保持在正确状态,并保证事物的执行不发生冲突. 
- file manager 
- bffer manager 
- data files 
> which store the database itself 
- data dictionary  
> store metadata about the structure of the databse , in particular the schema of the database 
- index 


# Chapter2 Introduction to the Relational Model 
- table
- key
  - super key
  - candidate key 候选码
  - primary key 
- foreign key


# Chapter3 SQL
## 3.1 概览
- 数据定义语言
- 数据操纵语言
- 完整性
- 视图定义
- 事物控制
- 嵌入式SQL和动态SQL
- 授权

## sql数据定义

### 3.2.1 基本类型
- char(n)
- varchar(n)
- int
- smallint
- numeric(p, d)
> 定点数,有p位数字(算上小数点),d位在小数点右边, numeric(3, 1) store 44.5 
- real, double precision 
- float(n)   : 精度至少为n位的浮点数. 


### SQL
#### create
```SQL
create table section
	(course_id		varchar(8),
         sec_id			varchar(8),
	 semester		varchar(6)
		check (semester in ('Fall', 'Winter', 'Spring', 'Summer')),
	 year			numeric(4,0) check (year > 1701 and year < 2100),
	 building		varchar(15),
	 room_number		varchar(7),
	 time_slot_id		varchar(4),
	 primary key (course_id, sec_id, semester, year),
	 foreign key (course_id) references course (course_id)
		on delete cascade,
	 foreign key (building, room_number) references classroom (building, room_number)
		on delete set null
	);
```
#### insert
```SQL
insert into instructor
    values(10211, 'Smith', 'Biology', 66000)
```

#### delete
```sql
delete from student;
drop table r;
```
#### alter
```sql
alter table r add A D;
alter table r drop A;
```

## 3.3 sql查询基本结构
select、 from 、 where
### 3.3.1 单关系查询
```sql
select dept_name from instructor;
select distinct dept_name from instructor; // distinct去除重复
select name from instructor where dept_name = 'Comp.Sci' and salary > 70000; 
```

### 3.3.2 多关系查询
```sql
// 找出所有教师的姓名,以及它们所在系的名称和系所在建筑的名称
select name, instructor.dept_name, building from instructor, department where instructor.dept_name = department.dept_name;
```

通常一个sql查询的含义可以理解如下:
1. 为from子句中列出的关系产生笛卡尔积
2. 在步骤1的结果上应用where子句中指定的谓词
3. 对于步骤2的结果中的每个元组,输出select子句中指定的属性. 


## 3.3.3 自然连接
等值连接去掉重复的行     
自然连接只考虑在两个关系模式中都出现的属性上取值相同的元组对. 
出现顺序:
1. 都存在的
2. 只出现在第一个关系模式的
3. 只出现在第二个关系模式的 

```sql
select name, course_id from instructor, teaches where instructor.ID = teaches.ID; 
= 
select name, course_id from instructor natural join teaches; 
```

```sql
select name, title from instructor natural join teaches, course where teaches.course_id = course.course_id; 
// is different from 
// 上面的语句会多出 course_id 和dept_name 两个重复列 
select name, title from instructor natural join teaches natural join course;
```

## 3.4 附加运算
### 更名运算
old-name as new-name  

```sql
select name as instructor_name, course_id from instructor, teaches where instructor.ID = teaches.ID; 
```
#### 用途
1. 省懒
2. 自取
> 找出满足下面条件的所有教师的姓名,他们的工资至少比biology系某一个教师的工资要高. 

```sql
select distinct T.name from instructor as T, instructor as S where T.salary > S.salary and S.dept_name = 'Biology'; 
```

### 3.4.2 字符串运算
使用like来进行模式匹配
- % : 匹配任意子串
- _ : 匹配任意一个自负
- “Intro%” : 匹配任意以“Intro”打头的字符串
- “% Comp%” : 匹配任何包含“Comp”子串的字符串
- “___“ : 匹配只含三个字符的字符串  
- ”___%“ : 匹配至少含三个字符的字符串

```sql
select dept_name from department where building like '%Watson%'; 
```

### 3.4.4 排列元组的显示顺序
- order by   
- desc 降序  
- asc 升序  
```sql
select * from instructor order by salary desc, name asc; 
```

### 3.4.5 where子句谓语
```sql
select name from instructor where salary between 90000 and 100000; 
select name, course_id from instructor, teaches where (instructor.ID, dept_name) = (teaches.ID, 'Biology');  
```

## 3.5 集合运算 
- union : 并
- intersect : 交  
- except : 除掉


### 3.5.1 并
```sql
( select course_id from section where semester = 'Fall' and year = 2009 )
union all // union自动去重, 如果需要重复, 加 all
( select course_id from section where semester = 'Spring' and year = 2010);
```

## 3.6 null
unknown 值
- and : 
> true and unknown : unknown    
> false and unknown : false     
> unknown and unknown : unknown
- or: 
> true or unknown : true    
> false or unknown : false   
> unknown or unknown : unknown
- not:
> not unknown : unknown    

```sql
select name from instructor where salary is null;
```
## 3.7 聚集函数
- avg
- min
- max
- sum
- count  

### 3.7.1 基本聚集

```sql
select avg (salary) from instructor where dept_name = 'Comp.Sci';
select count(distinct ID) from teaches where semester = 'Spring' and year = 2010; 
```

### 3.7.2 分组聚集 group by

```sql
select dept_name, avg(salary) as avg_salary from instructor group by dept_name;  
```
- 任何没有出现在group by子句中的属性如果出现在select子句中的话,它只能出现在聚集函数内部,否则语句为错.  
```sql 
//error 
select dept_name, ID, avg(salary) from instructor group by dept_name;
```
<span id='table1'> 表1
3.7.3 having 
- having 修饰 group by
包含聚集、group by或having子句的查询的含义可通过下述操作序列定义:
1. 最先根据from计算出一个关系
2. 如果出现where子句,where子句的谓语作用到from子句的结果关系上; 
3. 如果出现group by 子句, 满足where谓词的元组通过group by 形成分组. 如果没有,就当成一个分组
4. 如果出现having子句, 应用到每个分组上. 
5. select 利用剩下的分组产生查询结果中的元组.  

对于在2008年讲授的每个课程段,如果该课程段至少2名学生选课,找出选修该课程段的所有学生的总学分的平均值. 
```sql
select course_id, semester, year, sec_id, avg(tot_cred) 
from takes natural join student 
where year = 2009 
group by course_id, semester, year, see_id 
haaving count(ID) >= 2;
```

### 3.7.4 对空值和布尔值的聚集
- 除了count(*) 外所有的聚集函数都忽略输入集合中的控制. 
- 空集的count运算值为0, 其他所有聚集运算在输入为空集的情况下返回一个空值. 


## 3.8 嵌套子查询  
### 集合成员资格 in not in
```sql
select distinct course_id 
from section
where semester = 'Fall' and year = 2009 and 
course_id not in (select course_id 
from section 
where semester = 'Spring' and year = 2010); 
```

### 3.8.2 集合的比较 
-  >some : 至少比某一个要大  
   找出满足工资至少比biology系某一个教师的工资要高的教师的姓名
```sql
select dintinct T.name from instructor as T, instructor as S where T.salary > S.salary and S.dept_name = 'Biology' ;

select name from instructor where salary > some (select salary from instructor where dept_name = 'Biology'); 
```

### 3.8.3 空关系测试 exist
```sql
select course_id from sectioin as S
where semester = 'Fall' and year = 2009 and 
exists (select * from section as T 
where semester = 'Spring' and year = 2010 and S.course_id = T.course_id); 
```

### 3.8.4 重复元组存在性测试 unique
有些数据库不支持   
找出所有在2008 年最多开设一次的课程  
```sql 
select T.course_id from course as T
where unique (select R.course_id from section as R where T.course_id = R.course_id and R.year = 2009);
```

### 3.8.5 from 子句中子查询 
找出系平均工资超过42000美元的那些系中教师的平均工资  
```sql
select dept_name, avg_salary from ( select dept_name, avg (salary) as avg_salary from instructor group by dept_name ) where avg_salary > 42000;  
```

### 3.8.6 with
定义提供临时关系的方法,只对包含with子句的查询有效  
```sql
with max_budget (value) as (select max(budget) from department)
select budget from department, max_budget where department.budget = max_budget.value;  

```
with 子句中定义了临时关系max_budget, 此关系在随后的查询中马上被使用了.  

### 3.8.7 标量子查询 
sql允许查询出现在返回单个值的表达式能够出现的任何地方,只要该子查询只返回包含单个属性的单个元组; 
```sql
select dept_name, (
select count(*) from instructor where department.dept_name = instructor.dept_name)
as num_instructors
from department;
```

## 3.9 数据库的修改 
### 3.9.1 删除
```sql
delete from r whre P;
```
- 一次只能从一个关系中删除元组,但通过嵌套,可以引用任意数目的关系.   
- delete语句首先测试 关系中的元组再执行.

### 3.9.2 插入
- 在执行插入前执行完select语句非常重要. 
```sql
insert into course( course_id, title, dept_name, credits ) 
values ('CS-437', 'Database Systems', 'Comp.Sci.', 4);

//让MUSIC系每个修满144学分的学生称为music系的教师, 工资18000
insert into instructor 
select ID, name, dept_name, 18000 
from student 
where dept_name = 'Music' and tot_cred > 144 ;
```
- 如果只给出部分属性的值,其余属性将被赋空值,用null表示.  

### 3.9.3 更新
```sql
update instructor set salary = salary * 1.03 where salary > 100000;

update instructor set salary = case 
    when salary <= 100000 then salary * 1.05
	else salary * 1.03 
	end
```

# Chapter4 Intermediate SQL
## 4.1 连接表达式
### 4.1.1 连接条件 on

on 条件允许在参与连接的关系上设置通用的谓词.  

```sql
select * from student join takes on student.ID = takes.ID; 
=
select * from student, takes where student.ID = takes.ID;
```


- 使用带on条件的连接表达式的查询可以用不带on条件的等价表达式来替换, 把 on something 中的something转移到where中即可. 
- 两个优点:
1. 对外连接来说on 的表现 和 where 不同.
2. 更易读  

### 4.1.2 外连接
想显示所有的学生列表,以及他们选修的课程.  
select * from student natural join takes;  无法显示 在student但takes中没有的项

三种形式的外连接:
1. 左外连接(left outer join):只保留出现在左外连接运算之前(左边)的关系中的元组  
2. 右外连接(right outer join): 只保留右
3. 全外连接(full outer join): 保留出现在两个关系中的元组  
- 为了区分,之前不保留未匹配元组的连接运算被称为内连接.  
- 左连接和右连接是对称的  
```sql
select * from student natural left outer join takes ;
= 
select * from takes natural right outer join students;
```

- 全外连接是左外连接与右外连接类型的组合. 在内连接结果计算出来之后,左侧关系中不匹配右侧关系任何元组的元组被添上空值并加到结果中.  
```sql
select * from 
(select * from sutdents
where dept_name = ‘Comp.Sci‘ )
natural full outer join
(select * from takes where semester =‘Spring’ and year =2009);
```

# Chapter7 数据库设计和E-R模型  
## 7.1 设计过程概览

## 7.2 实体-联系模型
### 7.2.1 实体集
- 实体
> 现实世界中可区别于所有其他对象的一个“事物”或者“对象”  
- 实体集
> 具有相同类型的实体集和
- 实体集不必互不相交

### 7.2.2 联系集
- 联系
> 指多个实体间的相互关联  
- 实体集之间的关联称为参与  


### 7.2.3 属性
分类:
1. 简单和复合属性
> 名字, 姓和名 
2. 单值和多值属性
> phone number不止一个
3. 派生属性
> 年龄可以从 出生日期派生出来

## 7.3 约束
### 7.3.1 映射基数
- 一对一
- 一对多
- 多对一
- 多对多


### 7.3.2 参与约束
部分参与, 全部参与

### 7.3.3 码  

### 7.4 删除冗余属性

## 7.5 实体-联系图
包含:
- 分成两部分的矩形代表实体集
- 菱形代表联系集
- 未分割的矩形代表联系集的属性  
- 线段将实体集连接到联系集
- 虚线将联系集属性连接到联系集
- 双线显示实体在联系集中的参与度
- 双菱形代表连接到弱实体集的标志性联系集
![](http://picbed.yoyolikescici.cn/uPic/20220309123712.png)

### 7.5.2 映射基数
有箭头一,没箭头多
![](http://picbed.yoyolikescici.cn/uPic/20220309124003.png)

### 7.5.3 复杂的属性

### 7.5.6 弱实体集
- 没有足够的属性以形成主码的实体集称作弱实体集,有主码的实体集称作<mark>强实体集.</mark> 
- 弱实体集必须与另一个称作<mark>标识</mark> 或<mark>属主实体集</mark> 的实体集关联才能有意义.  
- 弱实体集与其标识实体集相联的联系称为标志性联系.  
- 弱实体集的主码由标识实体集的主码加上该如实体集的分辨符构成.  
- 在E-R图中,弱实体集的分辨符以虚下划线表明,  之间的联系集以双菱形表示  
![section为弱实体集](http://picbed.yoyolikescici.cn/uPic/20220309183232.png)

### 大学的E-R图
![](http://picbed.yoyolikescici.cn/uPic/20220309193103.png)

## 7.6 转换为关系模式

### 7.6.2 具有复杂属性的强实体集的表示
- 复合属性直接创建子属性
- 多值属性则另外创建一个新的关系模式.  

### 7.6.3 弱实体集的表示
section(~~course_id, sec_id, semester, year~~  )

### 7.6.4 联系集的表示
- 对于多对多的二元联系,参与实体集的主码属性的并集成为主码
- 对于一对一的二元联系集,任何一个实体集的主码都可选作主码
- 对于多对一或者一对多的二元联系集,“多”的那一方的实体集的主码构成主码 
- 对于边上没有箭头的n元联系集,所有参与实体集的主码属性的并集成为主码
- 对于边上有一个箭头的n元联系集,不再“箭头”侧的实体集的主码属性为模式的主码.  


#### 7.6.4.1 模式的冗余
一般情况下,连接弱实体集与其所依赖的强实体集的联系集的模式是冗余的. 

#### 7.6.4.2 模式的合并
多对一且每个“多”中的元素都要对一的时候可以合并,将联系集并到“多”中 

## 7.7 实体-联系设计问题
### 7.7.1 用实体集还是用属性
主要依赖于被建模的现实世界的企业的结构,以及被讨论的属性的相关语义

### 7.7.2 用实体集还是用联系集
当描述发生在实体间的行为时采用联系集.  

### 7.7.3 二元还是n元联系集
一个非二元的联系集总可以用一组不同的二元联系集来替代  

## 7.8 扩展的E-R特性
### 7.8.1 特化
person - student or employee  
student - graduate or undergraduate  
employee - instructor or secretary  
是否可能属于多个特化实体集还是必须属于至多一个特化实体集  
- 重叠特化 - 分开使用两个箭头
- 不相交特化 er图中使用一个箭头


### 7.8.2 概化
自底向上
![](http://picbed.yoyolikescici.cn/uPic/20220309210444.png)

### 7.8.3 属性继承
高层实体集的属性被低层实体集继承. 

### 7.8.4 概化上的约束
1. 成员资格上的约束
- 条件定义的
> 由上层的属性决定, student中的student_type
- 用户定义的
> 某个雇员三个月雇佣期后被分配到4个工作组中的一个  

2. 是否可以属于多个低层实体集
- 不相交
- 重叠


3. 完全性约束  
是否至少属于该特化/概化实体集  
- 全部概化或特化
- 部分00


### 7.8.5 聚集
一种抽象,将联系视为高层实体  

### 7.8.6 转换为关系模式
#### 7.8.6.1 概化的表示
- 为高层实体集创建一个模式,为每个低层创建一个
- 如果概化是不相交且完全的, 可以不给高层创建,只创建低层


## 7.9 数据建模的其他表示法
### 7.9.1 E-R图的其他表示法
![](http://picbed.yoyolikescici.cn/uPic/20220309213637.png)

### 7.9.2 UML


# 关系数据库设计
## 8.1 好的关系设计的特点

### 8.1.1 设计选择:更大的模式
### 8.1.2 更小的模式

### 8.2 原子域和第一范式
- 一个域是原子的,如果该域的元素被认为是不可分的单元. 则称这个模式属于第一范式.  
### 第二范式
- 非主属性完全依赖于关键字  
(确保每列都和主键直接相关)
![](http://picbed.yoyolikescici.cn/uPic/20220310143027.png)

### 第三范式
- 属性不依赖于其他非主属性  
(数据库中的一个表不包含已在其他表中已包含的非主关键字信息)  
(除主键以外的列,不存在某个列,能决定其他列)  
(确保每列都和主键列直接相关,而不是间接相关)  
![](http://picbed.yoyolikescici.cn/uPic/20220310143045.png)
### BCDF范式(鲍伊斯-科得范式,3NF改进形式)
- 在第三的基础上, 数据库表中不存在任何字段对任一候选关键字段的传递函数依赖则符合第三范式

### 8.3 使用函数依赖进行分解



# Chapter11 索引与散列
## 11.1 基本概念
- 顺序索引
- 散列索引
> 将值平局分布到若干散列桶中.一个值所属的散列桶有一个函数决定,称作散列函数. 

评价因素:
- 访问类型
- 访问时间
- 插入时间
- 删除时间
- 空间开销


## 11.2 顺序索引
- 聚集索引(主索引)
> 记录的文件按搜索码指定的顺序排列
- 非聚集索引(辅助索引)
> 索引顺序与物理存储顺序不同

### 11.2.1 稠密索引和稀疏索引
- 索引项或索引记录
> 由一个搜索码值和指向具有该搜索码值的一条或者多条记录的指针构成.  

两类顺序索引
- 稠密索引:
> 每个搜索码值都有一个索引项.
> 索引项包含搜索码值和指向具有该搜索码值的第一条数据记录的 指针.  

- 稀疏索引
> 只为某些搜索码值建立索引项.  
> 只有关系按照搜索码排列顺序存储时才能使用稀疏索引. 是<mark>聚集索引</mark> 才能用稀疏索引   

- 稠密索引更快定位,稀疏索引占空间小,插入和删除时需要的维护开销小.  


### 11.2.2 多级索引
多级索引和树结构紧密相关 

### 11.2.3 索引的更新
只考虑插入和删除就行
- 插入
  - 稠密索引
    1. 不再索引中,就插入
    2. 在的话,如果索引项中存储的是指向具有相同搜索码值的所有记录的指针,就在索引项中增加一个指向新纪录的指针
    3. 如果仅指向具有相同搜索码值的第一条记录的指针,就把待插入的记录放到具有相同搜索码值的其他记录之后. 
  - 稀疏索引
    1. 假设索引为每个块保存一个索引项. 如果系统创建一个新的块,将新块中出现的恶第一个搜索码值插入到索引中.如果这条新插入的记录含有块中的最小搜索码值,那么系统更新指向该块的索引,否则不做任何改动. 

- 删除
  - 稠密索引
    1. 如果被删除的是这个特定搜索码值的唯一记录,从索引中删除对应索引项
	2. 否则: 如果索引项存储的是指向所有具有相同搜索码值的记录的指针,系统就从索引项中删除指向被删除记录的指针
	3. 否则, 索引项存储的是指向该搜索码值的第一条记录的指针,如果被删除的记录是具有该搜索码值的第一条记录,系统就更新索引项,使其指向吓一跳记录.  
  - 稀疏索引
    1. 如果索引不包含具有被删除记录搜索码值的索引项,不必左任何修改
	2. 否则, 如果被删除的记录是具有该搜索码值的唯一记录,系统用下一个搜索码值的索引记录替换相应的索引记录,如果下一个搜索码值已经有一个索引项,则删除而不是替换该索引项. 
	3. 否则,如果该搜索码值的索引记录指向被删除的记录,系统就更新索引项,使其指向具有相同搜索码值的下一条记录. 

### 11.2.4 辅助索引
辅助索引必须是稠密索引,对每个搜索码值都有一个索引项,而且对文件中的每条记录都有一个指针.
