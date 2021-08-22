#### 主键

在关系数据库中，一张表中的每一行数据被称为一条记录。一条记录就是由多个字段组成的。每一条记录都包含若干定义好的字段。同一个表的所有记录都有相同的字段定义。

==对于关系表，有个很重要的约束，就是任意两条记录不能重复。不能重复不是指两条记录不完全相同，而是指**能够通过某个字段唯一区分出不同的记录，这个字段被称为*主键***。==

作为主键最好是完全业务无关的字段，我们一般把这个字段命名为`id`。常见的可作为`id`字段的类型有：

1.  自增整数类型：数据库会在插入数据时自动为每一条记录分配一个自增整数，这样我们就完全不用担心主键重复，也不用自己预先生成主键；==（常用）==
2.  全局唯一GUID类型：使用一种全局唯一的字符串作为主键，类似`8f55d96b-8acc-4636-8cb8-76bf8abc2f57`。GUID算法通过网卡MAC地址、时间戳和随机数保证任意计算机在任意时间生成的字符串都是不同的，大部分编程语言都内置了GUID算法，可以自己预算出主键。

<font color = "darkorange">还可以使用多个字段都设置为主键，叫做联合主键。只要被设为主键的列不完全相同就行，一般不用</font>

```sql
CREATE TABLE `test` (`id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY , ` `用来防止与sql的关键字重名
```

###### 例子

==id即是主键，用来唯一标识一个学生==

|  id  | name |  class   | ...  |
| :--: | :--: | :------: | ---- |
|  1   | wang | 小学一班 |      |
|  2   |  li  | 小学二班 |      |
|  3   | zhao | 小学一班 |      |

#### 外键

在关系数据库中，一张表中的一条记录的某个字段可能与另一个表的一条记录相关联。可以通过定义外键约束来定义二者之间的关联。

==在插入数据时，如果另一个表并没有id为xx的记录，另一个表就不能插入一条外键为xx的记录==

<font color="red">**由于外键会降低数据库的性能，所以一般并不设置外键约束，自己知道就行了，仅靠应用程序的逻辑来保证正确性**</font>

```sql
ALTER TABLE students
ADD CONSTRAINT fk_class_id		// 外键约束的名字可以随便定义
FOREIGN KEY (class_id)			// 指定class_id为外键
REFERENCES classes (id);		// 建立students-->class_id与classes-->id之间的外键约束

ALTER TABLE students
DROP FOREIGN KEY fk_class_id;		// 删除外键约束，并不删除列
```

###### 例子

**学生表**

|  id  | name | class_id | ...  |
| :--: | :--: | :------: | ---- |
|  1   | wang |   101    |      |
|  2   |  li  |   102    |      |
|  3   | zhao |   101    |      |

==class_id即是外键，通过class_id可以关联班级表的班级信息==

**班级表**

|  id  | class_name | class_teacher | ...  |
| :--: | :--------: | :-----------: | ---- |
| 101  |  小学一班  |      hua      |      |
| 102  |  小学二班  |      ba       |      |
| 103  |  小学三班  |     shan      |      |

由于老师的信息可能比较多，不只有姓名这一项，所以可以另创建一个表

**多对多**

==通过一个中介表，可以实现多对多关系==

**学生表**

|  id  | name | class_id | ...  |
| :--: | :--: | :------: | ---- |
|  1   | wang |   101    |      |
|  2   |  li  |   102    |      |
|  3   | zhao |   101    |      |

==class_id即是外键，通过class_id可以关联班级表的班级信息==

**班级表**

|  id  | class_name | teacher_id | ...  |
| :--: | :--------: | :--------: | ---- |
| 101  |  小学一班  |   111011   |      |
| 102  |  小学二班  |   111012   |      |
| 103  |  小学三班  |   111013   |      |

**老师表**


|   id   | name | gender | ...  |
| :----: | :--: | :----: | ---- |
| 111011 | hua  |   M    |      |
| 111012 |  ba  |   F    |      |
| 111013 | shan |   M    |      |

#### 索引

在关系数据库中，如果有上万甚至上亿条记录，在查找记录的时候，想要获得非常快的速度，就需要使用索引。

**索引是关系数据库中对某一列或多个列的值进行预排序的数据结构**。通过使用索引，可以让数据库系统不必扫描整个表，而是直接定位到符合条件的记录，这样就大大加快了查询速度。

```sql
ALTER TABLE students
ADD INDEX idx_score (score);			// 更具score列创建名为idx_score的索引，索引名是任意的

ALTER TABLE students
ADD INDEX idx_score (score, name);	// 如果根据多个列，可以用逗号隔开
```

##### 唯一索引

在设计关系数据表的时候，看上去唯一的列，例如身份证号、邮箱地址等，因为他们具有业务含义，因此不宜作为主键。

但是，这些列根据业务要求，又具有唯一性约束：即不能出现两条记录存储了同一个身份证号。这个时候，就可以给该列添加一个唯一索引。例如，我们假设`students`表的`name`不能重复：

```sql
ALTER TABLE students
ADD UNIQUE INDEX uni_name (name);		// 通过UNIQUE关键字我们就添加了一个唯一索引。
```

也可以只对某一列添加一个唯一约束而不创建唯一索引：

```sql
ALTER TABLE students
ADD CONSTRAINT uni_name UNIQUE (name);
```

#### 查询

<font color="red">由\=\=\=\=\=隔开的都是简便写法</font>

##### 条件查询

```sql
SELECT * FROM <表名>;		// 从表中查询出所有的数据			SELECT 100+200;可以计算100+200，不用了解
SELECT 列名, 列名...  FROM <表名>;			// 从表中查询出来指定的列
SELECT * FROM <表名> WHERE <条件表达式>； 	// 根据条件查询所有的数据		id >= 20 and id <= 80 可写为 id between 20 and 80===========
SELECT * FROM <表名> WHERE <条件表达式> AND <条件表达式>;   // 多个条件可以通过AND来连接
SELECT * FROM <表名> WHERE <条件表达式> OR <条件表达式>;		// 满足任意一个条件的记录		
SELECT * FROM <表名> WHERE NOT <条件表达式>;		//不符合该条件的记录   NOT id = 2  也可以写为  id <> 2 或者  id != 2意思相同============
有多个条件时，可以使用()来确定优先级
SELECT * FROM <表名> WHERE 字段 LIKE 正则表达式;  // 可以根据正则表达式匹配记录 
```

##### 投影查询

==使用*只能查询出记录的所有列，而有时我们只需要某几列==

```sql
SELECT 列名, 列名...  FROM <表名>;			// 从表中查询出来指定的列
SELECT 列1 as 别名1, 列2 as 别名2, 列3 as 别名3 FROM 表名；		// 加as给列起一个别名，不加as也可以用空格隔开
SELECT 列1 别名1, 列2 别名2, 列3 别名3 FROM 表名；		// 给指定查询的列起一个别名，查询出来的结果以别名显式 =====================
```

##### 排序

==使用ORDER BY关键字来根据某一列进行排序，ASC为升序，默认为升序；DESC为降序==

```sql
SELECT 列名, 列名... FROM 表名 ORDER BY 列名;		// 根据某一列进行升序排序 ，默认是升序的  升序关键字ASC，降序关键字DESC
SELECT 列名, 列名... FROM 表名 ORDER BY 列名 DESC;		// 根据某一列进行降序排序
```

##### 分页查询

==使用LIMIT限制查询个数，使用OFFSET设置偏移个数，即跳过多少个，OFFSET必须结合LIMIT使用，而LIMIT可单独使用==

OFFSET超过记录总数，会返回空，因为无数据可查询

```sql
SELECT 列名, 列名... FROM 表名 ORDER BY 列名 LIMIT M;	// 只查询前M个
SELECT 列名, 列名... FROM 表名 ORDER BY 列名 LIMIT M OFFSET N;	// 跳过前N个，再查询M个，不足M时，有几条查询几条
SELECT 列名, 列名... FROM 表名 ORDER BY 列名 LIMIT M， N;		// 同上一句，格式不同而已======================================
```

##### 聚合查询

```sql
SELECT COUNT(*) FROM 表名;   // 聚合函数COUNT()可以得到查询出来的记录总数， *也可以写为某一列
SELECT COUNT(*) 别名 FROM 表名;		// 为记录总数起一个别名
SELECT COUNT(*) 别名 FROM 表名 WHERE <条件表达式>;		// 根据条件表达式查询出来的记录总数
```

| SUM     | 计算某一列的合计值，该列必须为数值类型 |
| ------- | -------------------------------------- |
| AVG     | 计算某一列的平均值，该列必须为数值类型 |
| MAX     | 计算某一列的最大值                     |
| MIN     | 计算某一列的最小值                     |
| FLOOR   | 对数据进行向下取整                     |
| CEILING | 对数据进行向上取整                     |

==如果没有匹配到记录，COUNT()会返回0，而其他会返回NULL==

**使用GROUP BY进行分组**

**group by只能使用聚合函数或者查询分组的列，不能查询其他列，因为分组的列是相同的，其他列虽然在一组但不一定相同**

例如：查询每一个班级学生的个数，不可能使用条件查询一个班级一个班级使用COUNT来计算总数，可以根据class_id进行分组再计算

`SELECT COUNT(*) FROM 表名 GROUP BY class_id  // 根据class_id分组统计每个class_id的总数` 

`SELECT class_id, gender, COUNT(*) as `sum` FROM 表名 GROUP BY class_id, gender // 根据class_id gender进行分组`	联合分组就是在第一个条件列分组的基础上再进行第二个条件列的分组

`SELECT class_id, count(*) from 表名 group by class_id, score>89 //  根据class_id分组，再class_id分组的基础上再进行score>89的分组（score>89的一组,score<=89的一组）`

##### 多表查询

`SELECT * FROM 表1, 表2;`	一次查询两个表的数据，也可以设置查询指定列和指定列的别名，并且可以指定表的别名

`SELECT s.name as sname, s.score, c.name FROM students s, classes c WHERE s.score > 80`	s.name必须要制定别名，否则会与c.name重名不显示

==结果集的列数表1和表2的列数之和，行数是表1和表2的行数之积。==

##### 连接查询

###### 内连接

`表1 INNER JOIN  表2 ON 连接条件`		一般连接条件都是逻辑上的外键

注意INNER JOIN查询的写法是：

1. 先确定主表，仍然使用`FROM <表1>`的语法；
2. 再确定需要连接的表，使用`INNER JOIN <表2>`的语法；
3. 然后确定连接条件，使用`ON <条件...>`，这里的条件是`s.class_id = c.id`，表示`students`表的`class_id`列与`classes`表的`id`列相同的行需要连接；
4. 可选：加上`WHERE`子句、`ORDER BY`等子句。

###### 外连接

LEFT OUTER JOIN以左表为主，右表没有的项就为NULL，右表多余的项就不显示。RIGHT OUTER JOIN以右表为主，左表没有的项就为NULL，左表多余的项就不显示

###### 总结

INNER JOIN只返回同时存在于两张表的行数据，由于`students`表的`class_id`包含1，2，3，`classes`表的`id`包含1，2，3，4，所以，INNER JOIN根据条件`s.class_id = c.id`返回的结果集仅包含1，2，3。

RIGHT OUTER JOIN返回右表都存在的行。如果某一行仅在右表存在，那么结果集就会以`NULL`填充剩下的字段。

LEFT OUTER JOIN则返回左表都存在的行。如果我们给students表增加一行，并添加class_id=5，由于classes表并不存在id=5的行，所以，LEFT OUTER JOIN的结果会增加一行，对应的`class_name`是`NULL`：

使用FULL OUTER  JOIN，它会把两张表的所有记录全部选择出来，并且，自动把对方不存在的列填充为NULL：

![](C:\Users\Administrator\Pictures\sql连接查询.PNG)

#### 插入

`INSERT INTO <表名> (字段1, 字段2, ...) VALUES (值1, 值2, ...);`		对于自增主键，不用手动赋值，对于有默认值的字段也可以不赋值

`INSERT INTO <表名> (字段1, 字段2, ...) VALUES (值1, 值2, ...),(值1, 值2, ...),(值1, 值2, ...),(值1, 值2, ...) ...; 可以一次性插入多组值`

#### 更新

`UPDATE <表名> SET 字段1=值1, 字段2=值2, ... WHERE ...;`

`UPDATE <表名> SET 字段1=值1, 字段2=值2, ...  WHERE 条件表达式;` 可以一次更新多条记录  ==条件表达式可以是 id>=5 AND id<=7，这样一次可以更新多个记录==

+ 也可以使用表达式：`UPDATE students SET score=score+10 WHERE gender='M';` 把女同学的分数增加10 ==SET 字段 = 该字段+xxx，表示这个字段在原有基础上增加xxx==

#### 删除

`DELETE FROM <表名> WHERE ...;`

`DELETE FROM <表名> WHERE 条件表达式; 可以一次性删除满足条件的多行`

无外键：相当于没有任何关联数据

有外键：

- 创建外键时定义了ON DELETE CASCADE：关联数据被自动删除
- 没有定义ON DELETE CASCADE：有关联数据时报错

#### 表操作

###### 创建表

```sql
CREATE DATABASE 数据库;	// 创建数据库
DROP DATABASE 数据库;		// 删除数据库，将会删除所有数据表
USE 数据库;						// 切换数据库
SHOW DATABASES; 			// 显示所有的数据库
SHOW TABLES;					// 显示所有的数据表
DESC 表名; 						// 查看表的详细信息
SHOW CREATE TABLE 表名;		// 可以查看创建某个表的sql语句
DROP TABLE 表名;				// 删除某个表

ALTER TABLE 表名 ADD COLUMN 列名 VARCHAR(10) NOT NULL;		// 给某个表添加一列
ALTER TABLE 表名 CHANGE COLUMN 列名 新列名 VARCHAR(20) NOT NULL;		// 修改某一列的名字和类型
ALTER TABLE 表名 DROP COLUMN 列名;
```



**创建一个表**

```sql
CREATE TABLE `admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `createtime` datetime NOT NULL,
  `isdelete` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8
```

#### 实用操作

###### 插入或替换

==当数据表中有记录就删除这条记录，插入新的记录；如果没有记录，就直接插入==

`REPLACE INTO 表名 (id， 列名， 列名 ...) VALUES (值1， 值2，值3 ...);`   当id=值1的记录存在时，就替换新的值，如果不存在就直接插入

相当于：

`SELECT * FROM 表名 WHERE id = 值1`		先查看是否有这一条记录

如果有记录： `DELETE * FROM 表名 WHERE id = 值1`		先删除这一列

没有记录就直接插入：`INSERT INTO 表名 (id， 列名， 列名 ...) VALUES (值1， 值2，值3 ...);`     再插入新的记录

###### 插入或更新

==如果本条记录已经存在，就修改记录==<font color='darkorange'>与上面不同的是，更新不会改变主键，而删除后插入会改变主键</font>

`INSERT INTO 表名 (id， 列名， 列名 ...) VALUES (值1， 值2，值3 ...) ON DUPLICATE KEY UPDATE 列1=值1，列2=值2....;`

相当于：

`SELECT * FROM 表名 WHERE id = 值1`		先查看是否有这一条记录

如果有记录： `UPDATE 表名 SET  列1=值1，列2=值2.... WHERE id = xxx `		直接修改这一列

没有记录就直接插入：`INSERT INTO 表名 (id， 列名， 列名 ...) VALUES (值1， 值2，值3 ...);`     插入新的记录

###### 插入或忽略

==如果插入时，这条记录已经存在，就什么也不干==

`INSERT IGNORE INTO 表名 (id， 列名， 列名 ...) VALUES (值1， 值2，值3 ...);`

相当于：

`SELECT * FROM 表名 WHERE id = 值1`		先查看是否有这一条记录

如果有记录： 什么也不干

没有记录就直接插入：`INSERT INTO 表名 (id， 列名， 列名 ...) VALUES (值1， 值2，值3 ...);`     插入新的记录

###### 快照

==将本表的符合条件的数据复制一份到新表中==

`CREATE table 表名 SELECT* FROM 表名 WHERE 条件表达式`

**新创建的表结构和`SELECT`使用的表结构完全一致**

###### 写入查询结果集

==将查询出来的数据直接插入到另一个表中==

```sql
INSERT INTO 要插入的表1 (列名, 列名 ...) SELECT 列名, 列名(也可以是聚合函数) FROM 要查询的表名2;
```

**确保`INSERT`语句的列和`SELECT`语句的列能一一对应**

#### 事务

在执行SQL语句的时候，某些业务要求，一系列操作必须全部执行，而不能仅执行一部分。如果失败要撤销已经执行的部分操作。特别针对转账等操作

**这种把多条语句作为一个整体进行操作的功能，被称为数据库*事务*。==数据库事务可以确保该事务范围内的所有操作都可以全部成功或者全部失败。如果事务失败，那么效果就和没有执行这些SQL一样，不会对数据库数据有任何改动。==**

```sql
语法：
使用BEGIN开启一个事务
使用COMMIT提交一个事务，COMMIT是指提交事务，即试图把事务内的所有SQL所做的修改永久保存。如果COMMIT语句执行失败了，整个事务也会失败。
使用ROLLBACK将事务回滚

例如：
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;			// 将所有的转账操作都作为一个事务
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

###### 隔离级别

| Isolation Level  | 脏读（Dirty Read） | 不可重复读（Non Repeatable Read） | 幻读（Phantom Read） |
| :--------------- | :----------------- | :-------------------------------- | :------------------- |
| Read Uncommitted | Yes                | Yes                               | Yes                  |
| Read Committed   | -                  | Yes                               | Yes                  |
| Repeatable Read  | -                  | -                                 | Yes                  |
| Serializable     | -                  | -                                 | -                    |

###### Read Uncommitted

Read Uncommitted是隔离级别最低的一种事务级别。在这种隔离级别下，一个事务会读到另一个事务更新后但未提交的数据，如果另一个事务回滚，那么当前事务读到的数据就是脏数据，这就是脏读（Dirty Read）。

==也就是说。一个事务执行过程中在没有commit事务之前更改的数据是可以被另一个事务的执行过程得到的==

==但是由于第一个事务并未commit，所以可能出现回滚的现象，此时，第二个事务拿到的数据就是脏数据==

###### Read Committed

在Read Committed隔离级别下，一个事务可能会遇到不可重复读（Non Repeatable Read）的问题。

不可重复读是指，在一个事务内，多次读同一数据，在这个事务还没有结束时，如果另一个事务恰好修改了这个数据，那么，在第一个事务中，两次读取的数据就可能不一致。

==一个事务执行过程中先查询到了数据，还没有commit时，另一个事务修改了数据并提交了事务，此时若第一个事务还要去查询数据必定会得到被第二个事务修改后的数据，所以，不要在Read Committed隔离级别下重复查询一个数据，会造成数据不一致==

###### Repeatable Read

在Repeatable Read隔离级别下，一个事务可能会遇到幻读（Phantom Read）的问题。

幻读是指，在一个事务中，第一次查询某条记录，发现没有，但是，当试图更新这条不存在的记录时，竟然能成功，并且，再次读取同一条记录，它就神奇地出现了。

==第一个事务去查询某条记录时可能不存在，但是当它修改时，可能会有另一个事务在此之前插入了这条数据，所以修改时就可以修改==

###### Serializable

Serializable是最严格的隔离级别。在Serializable隔离级别下，所有事务按照次序依次执行，因此，脏读、不可重复读、幻读都不会出现。

虽然Serializable隔离级别下的事务具有最高的安全性，但是，由于事务是串行执行，所以效率会大大下降，应用程序的性能会急剧降低。如果没有特别重要的情景，一般都不会使用Serializable隔离级别。
