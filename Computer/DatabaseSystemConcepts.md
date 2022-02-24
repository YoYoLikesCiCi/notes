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
