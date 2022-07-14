1.  第一类型
```sql
create table first_types(
    first_type_name text primary key not null
);
```
默认 1
2. 账本
默认个人账本
```sql
create table Ledgers(
    ledger_name text primary key not null
);
```


3. person
默认self
```sql 
create table people(
    person_name text primary key not null,
    person_value decimal(10,2) not null default 0.0
);
```
借贷需要：
``` sql
create table Debts(
    debt_id integer primary key autoincrement,
    finished integer default 0 not null
)
```
4. account
```sql
create table Accounts(
    account_Name text primary key not null ,
    ledger_Name text not null,
    credit_Amount DECIMAL(10,2) not null default 0,
    balance decimal(10,2) not null default 0,
    first_Type_name text not null,

    type integer not null default 0 check (type >= 0 ) ,
    foreign key(ledger_Name) references Ledgers(ledger_name) on delete restrict on update cascade,
    foreign key(first_Type_name) references FirstTypes(first_Type_name) on delete restrict on update cascade
    );
    
```

默认： 现金 账户
5. record
```sql
create table Records(
    record_id integer primary key not null ,
    value decimal(10,2) not null default 0 ,
    from_Account text not null ,
    to_Account text not null ,
    person_name text default 'Self' ,
    record_Time text not null ,
    debt_id integer default 0,
    note text default "",
    foreign key(from_Account) references Accounts(account_Name) on delete restrict on update cascade,
    foreign key(to_Account) references Accounts(account_Name) on delete restrict on update cascade,
    foreign key(person_name) references People(person_Name) on delete restrict on update cascade
)
```