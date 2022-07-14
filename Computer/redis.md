# 基本操作
## 启动关闭
安装的位置：  
/usr/local/Cellar/  
redis配置文件：  
/usr/local/etc/redis.conf  

```
brew services start redis
redis-server /usr/local/etc/redis.conf  
reids-server
redis-cli  //启动客户端

redis-cli shutdown 

```

## 远程连接
```
$ redis-cli -h host -p post -a password

```


# 二、数据类型
## 1. 字符串
最基本的类型，最大能存储512MB

```
set runoob "菜鸟教程"
get runoob 
```
## 2. Hash
一个键值（key，value）组合  
redis 是一个string类型的field 和value的映射表， 特别适合用于存储对象。
每个hash可以存储2^32-1 个键值对， 40多亿
```
hmset runoob field1 "hello" field2 "world"
hget runoob field1
hget runoob field  
```


## list
简单的字符串列表，可以添加元素到头部（左边）或者尾部（右边）

```
lpush runoob redis
lpush runoob mogodb
lpush runooob rabbitmq
lrange runoob 0 10  

```

## set 
string 类型的无序集合
通过哈希表实现，各种操作复杂度都是O（1）
```
sadd key member  
sadd key rabbitmq
smembers key
```

## zset 
string类型的有序集合
每个元素都会管理一个double类型的分数，通过分数为集合中的成员进行从小到大的排序。 
zset成员唯一，但分数可以重复
```
zadd key score member  

zadd runoob 0 redis
zadd runoob 0 mongodb
zadd runoob 0 rabbitmq
zadd runoob 0 rabbitmq
zrangebyscore runoob 0 1000

```

# 三、键命令

| 命令 | 释义 |
|- |-  |
| DEL key | 该命令用于在 key 存在时删除 key。| 
| DUMP key  | 序列化给定 key ，并返回被序列化的值。|
| EXISTS key | 检查给定 key 是否存在。|
| EXPIRE key seconds |为给定 key 设置过期时间，以秒计。|
| EXPIREAT key timestamp |EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间。 不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp)。|
|PEXPIRE key milliseconds |设置 key 的过期时间以毫秒计。|
|PEXPIREAT key milliseconds-timestamp |设置 key 过期时间的时间戳(unix timestamp) 以毫秒计|
|KEYS pattern |查找所有符合给定模式( pattern)的 key 。|
| MOVE key db |将当前数据库的 key 移动到给定的数据库 db 当中。|
| PERSIST key |移除 key 的过期时间，key 将持久保持。|
|PTTL key |以毫秒为单位返回 key 的剩余的过期时间。|
|TTL key |以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)。|
|RANDOMKEY | 从当前数据库中随机返回一个 key 。|
|RENAME key newkey |修改 key 的名称|
|RENAMENX key newkey |仅当 newkey 不存在时，将 key 改名为 newkey 。
|SCAN cursor [MATCH pattern] [COUNT count] |迭代数据库中的数据库键。|
|TYPE key |返回 key 所储存的值的类型。| 