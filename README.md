# 开源文档

个人总结的开源文档,这些文档也是为了方便自身使用,我的这个文档,是按一定的目录结构的规范来的,使用的平台大多数是liunx服务器下的文档。

这些文档一旦发现不合理或者错误则会马上修改,这个只作参考。

## 规范的目录结构

一切都非一些依赖包都是基于绿色的方式安装,也就是可以通过源码或者编译版,并安装到规范到目录结构。

### 源码下载存放目录

    /usr/local/src
 
 例子:
 
    /usr/local/src/java/jdk
    /usr/local/src/java/jre
    /usr/local/src/mysql
    
### 程序安装目录

    /usr/local/etc
    
例子:
    
    /usr/local/etc/java/jdk/1.6.0_45
    /usr/local/etc/java/jdk/1.7.0_80
    /usr/local/etc/java/jdk/1.8.0_92
    /usr/local/etc/java/jre/1.6.0_45
    /usr/local/etc/java/jre/1.7.0_80
    /usr/local/etc/java/jre/1.8.0_92
    /usr/local/etc/mysql/5.7.11
    /usr/local/etc/mysql/5.7.12
    
### 数据存放目录
 
   /usr/local/data
   
例子:

    /usr/local/data/mysql/5.7.11
    /usr/local/data/mysql/5.7.12
    /usr/local/data/mongodb/3.2.6
    /usr/local/data/redis/3.2.0
    /usr/local/data/maven
    /usr/local/data/npm
    /usr/local/data/npm-cache
    
对于数据目录划分版本号疑问。

这个对于一般使用到,进行版本号划分可以对数据升级很好,如果安装新版本,则把原本到数据复制,就算升级出错,那样可以保证原来到存在,这个还是看自己到选择。

1.  [安装记录](./安装记录/安装记录指南说明.md)