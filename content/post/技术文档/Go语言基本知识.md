---
Categories: ["技术文档"]
Tags: ["golang"]
date: 2016-12-06T16:32:00+08:00
title: Go语言基本知识
---

生成本地go doc文档
> godoc -http=:8080

> 干净、可读的代码和简洁性是 Go 追求的主要目标
> 统一的代码风格


### Linux上安装Go
如果你能够自己下载并编译Go的源代码是非常有教育意义的，你可以根据这个页面找到安装指南和下载地址:[Download the Go distribution][1]
#### 源码编译安装步骤
1、设置Go环境变量
> export GOROOT=$HOME/go

为了确保相关文件在文件系统的任何地方都能被调用，还需要设置
> export PATH=$PATH:$GOROOT/bin

在开发Go项目时，还需要一个环境变量来保存你的工作目录
> export GOPATH=$HOME/gopro

$GOPATH可以包含多个工作目录，取决于你的个人情况。如果你设置了多个工作目录，那么当你之后使用 go get(远程包安装命令) 时远程包将会被安装在第一个工作目录的src下面。

> source /etc/profile

2、安装C工具
Go的工具链是用C语言编写的，因此在安装Go之前需要你先安装相关的C工具。
> yum install bison ed gawk gcc libc6-dev make -y 

3、获取Go源代码
从官方页面或国内镜像 下载Go的源码到你的计算机上，然后将解压后的目录 go 通过命令移动到 $GOROOT 所指向的位置
> wget https://storage.googleapis.com/golang/go1.6.src.tar.gz
tar -zxvf go1.6.src.tar.gz
mv go $GOROOT

4、构建Go
> cd $GOROOT/src
> ./all.bash


报错如下

    ##### Building Go bootstrap tool.
    cmd/dist
    ERROR: Cannot find /root/go1.4/bin/go.
    Set $GOROOT_BOOTSTRAP to a working Go tree >= Go 1.4.

因为 Go 1.5 及之后版本彻底告别了 C 代码，用 Go 构建的 Go，构建 Go 1.n（n≥5）需要用 Go 1.4，并且将环境变量 GOROOT_BOOTSTRAP 指向 Go 1.4（注意，将 GOROOT_BOOTSTRAP 指向 GOROOT 是行不通滴），具体的可以参见https://golang.org/s/go15bootstrap。因为环境中没有安装Go 1.4，所以源码编译安装暂且不执行了。

#### 安装配置GO
1、设置Go环境变量
> export GOROOT=$HOME/go

为了确保相关文件在文件系统的任何地方都能被调用，还需要设置
> export PATH=$PATH:$GOROOT/bin

在开发Go项目时，还需要一个环境变量来保存你的工作目录
> export GOPATH=$HOME/gopro

$GOPATH可以包含多个工作目录，取决于你的个人情况。如果你设置了多个工作目录，那么当你之后使用 go get(远程包安装命令) 时远程包将会被安装在第一个工作目录的src下面。

> source /etc/profile

2、安装Go
> wget https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
> tar zxvf go1.6.linux-amd64.tar.gz
> mv go $GOROOT

3、验证
> go env
> go version

4、hello world
> cd /vagrant/gopro/src
vim helloworld.go

    package main
    import "fmt"
    func main() {
        fmt.Println("Hello,world.你好，世界!")
    }

> go run helloworld.go


### 工作区和GOPATH
工作区是放置Go源码文件的目录
一般情况下,Go源码文件都需要存放到工作区中
但是对于**命令源码文件**来说，这不是必须的

每一个工作区的结构都类似下图所示
/vagrant/golib:
    src/
    pkg/
    bin/

**src目录**
用于存放源码文件
以代码包为组织形式

**pkg目录**
用于存放归档文件(名称以.a为后缀的文件)
所有归档文件都会被存放到该目录下的平台相关目录中，同样以代码包为组织形式

**平台相关目录**
两个隐含的Go语言环境变量:GOOS和GOARCH
以$GOOS_$GOARCH为命名方式，如:linux_amd64

> <工作区目录>/pkg/<平台相关目录>/<一级代码包>/<二级代码包>/<末级代码包>.a

**bin目录**
用于存放当前工作区中的Go程序的可执行文件
有两种情况存在的时候，bin目录变的无意义：
 1. 当环境变量GOBIN已有有效设置时，该目录会变的无意义
 2. 当GOPATH的值中包含多个工作区的路径时，必须设置GOBIN,否则无法成功安装Go程序的可执行文件

### 源码文件的分类和含义
**Go源码文件**
名称以.go为后缀，内容以Go语言代码组织的文件
多个Go源码文件是需要用代码包组织起来的

**分三类**
命令源码文件、库源码文件
测试源码文件

**命令源码文件**
声明自己属于main代码包、包含无参数声明和结果声明的main函数
被安装后，相应的可执行文件会被存放到GOBIN指向的目录或<当前工作区目录>/bin下
命令源码文件是Go程序的入口，但不建议把程序都写在一个文件中
> 注意：同一个代码包中强烈不建议直接包含多个命令源码文件

**库源码文件**
不具备命令源码文件的那两个特征的源码文件
被安装后，相应的归档文件会被存放到<当前工作区目录>/pkg/<平台相关目录>下

**测试源码文件**
不具备命令源码文件的那两个特征的源码文件
名称以_test.go为后缀
其中至少有一个函数的名称以Test或Benchmark为前缀
并且，该函数接受一个类型为*testing.T 或*testing.B 的参数
功能测试函数
    func TestFind(t *testing.T) {
    
    }

基准测试函数

    func BenchmarkFind(b *testing.B) {
    
    }

### 代码包的相关知识
**代码包的作用**
编译和归档Go程序的最基本单位
代码划分、集结和依赖的有效组织，也是权限控制的辅助手段

**代码包的规则**
一个代码包实际上就是一个由导入路径代表的目录
> 导入路径即<工作区目录>/src 或<工作区目录>/pkg/<平台相关目录>之下的某段子路径
例如:代码包hypermind.cn可以对应于
/vagrant/golib/src/hypermind.cn目录（其中,/vagrant/golib是一个工作区目录）

**代码包的声明**
每个源码文件必须声明其所属的代码包
同一个代码包中的所有源码文件声明的代码包应该是相同的

**代码包声明与代码包导入路径的区别**
代码包声明语句中的包名称应该是该代码包的导入路径的最右子路径,
例如:
hypermind.cn/pkgtool

则源码文件中的声明语句
package pkgtool

**代码包的导入**
代码包导入语句中使用的包名称应该与其导入路径一致，例如
flag
fmt
strings

import (
"flag"
"fmt"
"strings"
)

**代码包的导入方法**
带别名的导入
import str "strings"  
str.HasPrefix("abc","a") 

本地化的导入
import . "strings"
HasPrefix("abc","a")

仅仅初始化
import _ "strings"
仅执行代码包中的初始化函数

**代码包的初始化**
代码包初始化函数即：无参数声明和结果声明的init函数
init函数可以被声明在任何文件中，且可以有多个
init函数的执行时机----单一代码包内
> 首先对所有全局变量进行求值----> 执行所有init函数

init函数的执行时机---- 不同代码包之间
> 执行被导入的代码包中的init函数 ----> 执行导入它的那个代码包的init函数

init函数的执行时机----所有涉及到的代码包
先于main函数执行，且只会被执行一次

### Go命令基础
**go run 命令**
用于运行命令源码文件
只能接受一个命令源码文件以及若干个库源码文件作为文件参数
其内部操作步骤是：先编译源码文件再运行

**ds命令与pds命令**
ds命令的源码文件: goc2p/src/helper/ds/showds.go
> ds命令的功能用于显示指定目录的目录结构

pds命令的源码文件:goc2p/src/helper/pds/showpds.go
> pds命令的功能用于显示指定代码包的依赖关系


    cd /vagrant/goc2p/src/helper/ds/
    go run showds.go
    go run showds.go -p /vagrant/goc2p/src/helper

**go run 常用标记的使用**

 -a:强制编译相关代码，不论它们的编译结果是否已是最新的
 -n:打印编译过程中所需运行的命令，但不真正执行它们
 -p n:并行编译，其中n为并行的数量
 -v:列出被编译的代码包的名称
 -a -v:列出所有被编译的代码包的名称
 -work:显示编译时创建的临时工作目录的路径，并且不删除它
 -x: 打印编译过程中所需运行的命令，并真正执行它们

**go build 命令**
用于编译源码文件或代码包
编译非命令源码文件不会产生任何结果文件
编译命令源码文件会在该命令的执行目录中生成一个可执行文件
执行该命令且不追加任何参数时，它会试图把当前工作目录作为代码包并编译
执行该命令且以代码包的导入路径作为参数时，该代码包及其依赖会被编译
执行该命令且以若干源码文件作为参数时，只有这些文件会被编译

>  cd /vagrant/goc2p/src/helper/ds/
> go build pkgtool  #没有在pkgtool目录下，也可以编译代码包

**go install 命令**
用于编译并安装代码包或源码文件
安装代码包会在当前工作区的pkg/<平台相关目录>下生成归档文件
安装命令源码文件会在当前工作区的bin目录或$GOBIN目录下生成可执行文件
>  cd /vagrant/goc2p/src/helper/ds
> go install  #可执行文件生成在哪里？ls $GOBIN
> ls $GOBIN

> go install pkgtool  #代码包的归档文件被安装在哪里？ ls /vagrant/goc2p/pkg/linux_amd64
>  ls /vagrant/goc2p/pkg/linux_amd64
> ds -p /vagrant/goc2p/pkg

**go get 命令**
用于从远程代码库中下载并安装代码包
支持的代码版本控制系统有:Git、Mercuial(hg)、SVN、Bazaar
指定的代码包会被下载到$GOPATH中包含的第一个工作区的src目录中

> go get github.com/vmware/harbor
> ds -p /vagrant/golib/src or ls /vagrant/golib/src/github.com/vmware

有些命令的更多细节及更多命令，请参看《Go命令教程》
https;//github.com/hyper-carrot/go_command_tutorial

### 值类型和引用类型

引用类型
 - 指针
 - slices
 - maps
 - channel

值类型
 - 基本类型
 - 数组
 - 结构

  [1]: http://golang.org/doc/install