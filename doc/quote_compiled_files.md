# 项目编译文件引用

#### 编译（cpm build）

##### 配置项

```
Usage:
  cpm build [flag]

Available flags:
  -h, --help                    查看帮助
  -s, --serial                  串行编译（默认并行编译）
  -i, --incremental             增量编译（默认全量编译）
  -V, --verbose                 展示编译日志
  -g                            生成debug版本的目标文件
  --coverage                    生成覆盖率信息（默认不开启）
  --condition="cfg1, cfg2"      按条件透传module.json文件中的命令
  --target=<value>              交叉编译代码到目标平台
  -o <name>, --output=<name>    指定输出可执行文件的名称
```
##### IDE编译

适配你所用的IDE,运行程序入口（main.cj）之后自动编译，生成和src目录同级的build目录<br/>
有些IDE还没有适用的仓颉插件，建议选择命令行编译，目前已适用的有vscode插件

##### 命令行编译

同IDE编译，编译完成会生成和src目录同级的build目录

```
cpm clean  #清理临时文件
cpm check  #检查模块依赖关系
cpm build -V -o log4cj #编译打包,指定可执行文件名为log4cj

```
**注意** 以上命令执行完，编译日志的最后一个单词均是success，则表示命令执行成功

##### 编译完成文件所在（命令行编译所得）

编译完成，会生产build目录，bin目录中会存放生成的最终可执行文件，不指定文件名，默认就是main<br/>
log4cj目录下会生成.cjo和.a文件（或者.so文件），生成.a或者.so取决于你的module.json中配置的output_type,默认是.a<br/>
log4cj目录的名字取决于module.json中配置的name<br/>
appender、config、logger、utils均为本项目src目录下的package

```shell
├── doc
├── src
├── build
│    ├── bin
│    │    ├── log4cj(文件)
│    ├── log4cj（目录）
│    │    ├── appender.cjo
│    │    ├── liblog4cj_appender.a
│    │    ├── config.cjo
│    │    ├── liblog4cj_config.a
│    │    ├── logger.cjo
│    │    ├── liblog4cj_logger.a
│    │    ├── utils.cjo
│    │    ├── liblog4cj_utils.a
├── test
├── main.cj
├── module.json

```

#### 引用

##### 拷贝log4cj目录

拷贝上述build目录下的log4cj整个目录（目录以及文件）到调用项目的目录中，保持和调用项目的src目录同级


##### 更改调用项目的module.json文件

更改package_requires字段的值，此字段是map类型，类似如下，如果原来此字段存在值，则续添，反之，则复制以下代码框中{}里的内容即可
```
	"package_requires": {
		"log4cj/log4cj_appender":"./log4cj/appender.cjo",
		"log4cj/log4cj_config":"./log4cj/config.cjo",
		"log4cj/log4cj_logger":"./log4cj/logger.cjo",
		"log4cj/log4cj_utils":"./log4cj/utils.cjo"
	}
```

##### 修改依赖关系

修改命令：cpm update<br/>
手动执行cpm update的原因：update用来将module.json里的内容更新到module-resolve.json,当module-resolve.json不存在是，将会生成该文件<br/>
module-resolve.json里存放的是项目中模块之间的依赖关系

##### 如何调用引入的依赖

在需要引入的仓颉（.cj）文件中，引入log4j相关依赖，写法如下
```
from log4cj import appender.*
from log4cj import config.*
from log4cj import logger.*
from log4cj import utils.*

let logger = Logger_Manager.getLogger("com.test")

func xxx(){ 
    logger.warn("test waring")
}
```

##### 运行
运行完程序，查看项目中对应的.log文件（和src目录同级）中有没有你写入的内容


















