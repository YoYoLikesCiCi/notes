anaconda

# 创建自己的虚拟环境

conda create -n learn python=3

```text
onda create --name <env_name> <package_names>
conda create -n python3 python=3.5 numpy pandas 
```

指定python版本



then

conda activate learn



显示list

conda env list 

conda info -e



```text
source deactivate
```



复制环境

```text
conda create --name <new_env_name> --clone <copied_env_name>
```



删除环境

```text
conda create --name <new_env_name> --clone <copied_env_name>
```



# 管理包

## 精确查找

```text
conda search --full-name <package_full_name>
```



## 模糊查找

```text
conda search <text>
```



## 获取已经安装的包信息

```
conda list

```



## 在指定环境中安装包

```
conda install --name <env_name> <package_name>

```



## 在当前环境中安装包

```
conda install <package_name>
```





## 卸载包

```
conda remove --name <env_name > <package_name>
```



卸载当前环境的包

```
conda remove <package_name>
```



## 更新包

```
conda update <package_name>
conda upgrade <package_name>
```

