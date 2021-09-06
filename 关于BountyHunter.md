---
title: 关于BountyHunter
date: 2021-06-14 15:20:06
tags: 
- 软件开发
categories: 
- 九阴真经
---

## 复式记账：
- 正数 ：费用 expenses   - 各种消费
- 正数： 资产 assets   - 现金、存款
- 正数： 负债 liabilities  - 信用卡、房贷、车贷等等
- income 收入 - 工资奖金
- equity 权益 - 净资产，存放记账开始前已经有的权益
- assets 资产

垫付、报销
```beancount
2019-09-30 * "出门吃饭"
    Assets:Cash            -200 CNY
    Expenses:Eating          50 CNY
    Assets:Receivables      150 CNY

2019-09-30 * "朋友A付款"
    Assets:Receivables      -50 CNY
    Assets:Cash              50 CNY
```

多重记账
分开金额
备注里添加总额，时间一致
id一致


借贷时就是新建一个账户


卖出折旧：
点击折旧按钮，修改支出内容为 ** + 使用折旧
金额改为支出金额-二手价，同时原账户平帐支出到收入账户


参考资料：
1. https://blog.zsxsoft.com/post/41
2. https://byvoid.com/zhs/blog/beancount-bookkeeping-2/
3. https://byvoid.com/zhs/blog/beancount-bookkeeping-3/
4. 