
path
``` python

from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('polls/', include('polls.urls')),
    path('admin/', admin.site.urls),
]
```
path 四个参数，2个必须
- route：
    匹配URL的准则（类似正则表达式），不会匹配get和post参数或命名
	
- view： 
    调用这个视图函数

- kwargs：
    任意关键字作为字典
	
- name:
    为url取名
	
	
	