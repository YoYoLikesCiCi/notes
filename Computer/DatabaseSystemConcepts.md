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


## 3.3 自然连接
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

3.7.3 having 
- having 修饰 group by



