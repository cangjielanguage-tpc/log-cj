
# 测试情况说明

## 测试文件所在位置

src目录每个package下后缀为_test的仓颉文件<br/>位置原因：<br/>1.尝试新建test目录（和src同级）存放测试文件，找不到相关要测试的仓颉文件中的方法（跨包失败）<br/>2.尝试直接在src目录下新建仓颉文件，编写测试用例，可以成功<br/>3.第2种虽然也可以，为了整体代码结构规整，选择在对应的package下新建文件编写各自模块的测试用例<br/>代码结构：
```shell
├── doc
├── src
│   ├── appender
│   │   ├── ...
│   │   └── appender_test.cj
│   ├── config
│   │   ├── ...
│   │   └── config_test.cj
│   ├── logger
│   │   ├── ....
│   │   └── logger_test.cj
│   └── utils
│       ├── ...
│       └── utils_test.cj
├── resources
│   ├── log4cj.xml
```

## 测试用例运行

#### 利用cpm（仓颉包管理工具）运行

###### 单包运行
```
cd log4cj2 #log4cj2项目名
cpm test src/utils -V #-V展示运行日志

运行结果：
nittest package log4cj/utils: cjc --import-path build   --diagnostic-format=noColor --test --module-name log4cj -p "src/utils/" -o unittest/bin/log4cj_utils
unittest/bin/log4cj_utils
--------------------------------------------------------------------------------------------------
TP: log4cj/utils, time elapsed: 600390 ns, Result:
    TCS: UtilTests, time elapsed: 598656 ns, RESULT:
    [ PASSED ] CASE: testGetNumByString (28725 ns)
    [ PASSED ] CASE: testStrToNumBySuffix (24392 ns)
    [ PASSED ] CASE: testFlushLeft (8127 ns)
    [ PASSED ] CASE: testTimeSlice (479503 ns)
    [ PASSED ] CASE: testFormatLogRecord (17113 ns)
    [ PASSED ] CASE: testLogRecord (3379 ns)
    [ PASSED ] CASE: testLogLevel (29424 ns)
Summary: TOTAL: 7
    PASSED: 7, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------

cpm test --verbose success

```
###### 整包运行（模块级别）

```
cd log4cj2
cpm test -V

运行结果：
unittest package log4cj/config: cjc --import-path build  -L build/log4cj -llog4cj_utils  --diagnostic-format=noColor --test --module-name log4cj -p "/home/helongfei/workspace/log4cj2/src/config" -o unittest/bin/log4cj_config
unittest package log4cj/appender: cjc --import-path build  -L build/log4cj -llog4cj_config -L build/log4cj -llog4cj_utils  --diagnostic-format=noColor --test --module-name log4cj -p "/home/helongfei/workspace/log4cj2/src/appender" -o unittest/bin/log4cj_appender
unittest package log4cj/default: cjc --import-path build  -L build/log4cj -llog4cj_logger -L build/log4cj -llog4cj_appender -L build/log4cj -llog4cj_config -L build/log4cj -llog4cj_utils  --diagnostic-format=noColor --test --module-name log4cj -p "/home/helongfei/workspace/log4cj2/src" -o unittest/bin/log4cj_default
unittest package log4cj/utils: cjc --import-path build   --diagnostic-format=noColor --test --module-name log4cj -p "/home/helongfei/workspace/log4cj2/src/utils" -o unittest/bin/log4cj_utils
unittest/bin/log4cj_default
can not find any logger in xml file!
--------------------------------------------------------------------------------------------------
TP: log4cj/default, time elapsed: 374 ns, Result:
Summary: TOTAL: 0
    PASSED: 0, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------

unittest package log4cj/logger: cjc --import-path build  -L build/log4cj -llog4cj_appender -L build/log4cj -llog4cj_config -L build/log4cj -llog4cj_utils  --diagnostic-format=noColor --test --module-name log4cj -p "/home/helongfei/workspace/log4cj2/src/logger" -o unittest/bin/log4cj_logger
unittest/bin/log4cj_utils
--------------------------------------------------------------------------------------------------
TP: log4cj/utils, time elapsed: 615681 ns, Result:
    TCS: UtilTests, time elapsed: 613808 ns, RESULT:
    [ PASSED ] CASE: testGetNumByString (44021 ns)
    [ PASSED ] CASE: testStrToNumBySuffix (24149 ns)
    [ PASSED ] CASE: testFlushLeft (8579 ns)
    [ PASSED ] CASE: testTimeSlice (477543 ns)
    [ PASSED ] CASE: testFormatLogRecord (17370 ns)
    [ PASSED ] CASE: testLogRecord (3241 ns)
    [ PASSED ] CASE: testLogLevel (28676 ns)
Summary: TOTAL: 7
    PASSED: 7, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------

unittest/bin/log4cj_config
--------------------------------------------------------------------------------------------------
TP: log4cj/config, time elapsed: 194461 ns, Result:
    TCS: ConfigTests, time elapsed: 192270 ns, RESULT:
    [ PASSED ] CASE: testLoggerConfig (23447 ns)
    [ PASSED ] CASE: testLoggerConfigWithAttrs (27552 ns)
    [ PASSED ] CASE: testLoggerConfigWithInitParams (6263 ns)
    [ PASSED ] CASE: testAppenderConfig (12120 ns)
    [ PASSED ] CASE: testAppenderConfigWithAttrs (12949 ns)
    [ PASSED ] CASE: testAppenderConfigWithInitParams (14921 ns)
    [ PASSED ] CASE: testAppenderProperty (2896 ns)
    [ PASSED ] CASE: testAppenderPropertyWithAttrs (3164 ns)
    [ PASSED ] CASE: testAppenderPropertyWithInitParams (4568 ns)
    [ PASSED ] CASE: testAppenderRef (2911 ns)
    [ PASSED ] CASE: testLoggerConfiguartion (8497 ns)
    [ PASSED ] CASE: testLoggerConfiguartionWithInitParams (17462 ns)
    [ PASSED ] CASE: testRootLoggerConfig (7641 ns)
    [ PASSED ] CASE: testRootLoggerConfigWithAttrs (4576 ns)
    [ PASSED ] CASE: testRootLoggerConfigWithInitParams (5418 ns)
Summary: TOTAL: 15
    PASSED: 15, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------

unittest/bin/log4cj_appender
[14:30:28 CST 2022/12/07 615] [ALL][com.test] (source) message
[14:30:28 CST 2022/12/07] [ALL] (source) message]
AppenderType is empty, please RegistryType at first
--------------------------------------------------------------------------------------------------
TP: log4cj/appender, time elapsed: 4176973 ns, Result:
    TCS: AppenderTests, time elapsed: 4174631 ns, RESULT:
    [ PASSED ] CASE: testConsoleLoggerAppenderWithDefaultPattern (539967 ns)
    [ PASSED ] CASE: testConsoleLoggerAppenderWithOtherPattern (22061 ns)
    [ PASSED ] CASE: testFileLoggerAppenderWithDefaultPattern (322786 ns)
    [ PASSED ] CASE: testFileLoggerAppenderWithOtherPattern (246456 ns)
    [ PASSED ] CASE: testFileLoggerAppenderWithErrorRolling (2188904 ns)
    [ PASSED ] CASE: testFileLoggerAppenderWithRightRolling (552453 ns)
    [ PASSED ] CASE: testAppenderFactoryNoType (21590 ns)
    [ PASSED ] CASE: testAppenderFactorWithConsoleType (48168 ns)
    [ PASSED ] CASE: testAppenderFactorWithInitParams (102318 ns)
    [ PASSED ] CASE: testAppenderFactorNoNew (53762 ns)
    [ PASSED ] CASE: testAppenderReference (8557 ns)
    [ PASSED ] CASE: testAppenderReferenceWithInitParams (24507 ns)
    [ PASSED ] CASE: testAppenderReferenceWithSetter (22174 ns)
Summary: TOTAL: 13
    PASSED: 13, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------

unittest/bin/log4cj_logger
can not find any logger in xml file!
can not find any logger in xml file!
[2022/12/07 14:30:35 CST 549] [INFO] [test] () info
[2022/12/07 14:30:35 CST 550] [ERROR] [test] () error
[2022/12/07 14:30:35 CST 550] [WARN] [test] () warn
[2022/12/07 14:30:35 CST 551] [OFF] [test] () off
[2022/12/07 14:30:35 CST 551] [DEBUG] [test] () debug
[2022/12/07 14:30:35 CST 552] [TRACE] [test] () trace
[2022/12/07 14:30:35 CST 552] [ALL] [test] () all msg
--------------------------------------------------------------------------------------------------
TP: log4cj/logger, time elapsed: 3430156 ns, Result:
    TCS: LoggerTests, time elapsed: 3427731 ns, RESULT:
    [ PASSED ] CASE: testLoadDefaultConfig (87439 ns)
    [ PASSED ] CASE: testGetLogger (1806 ns)
    [ PASSED ] CASE: testInitLogggerManager (243796 ns)
    [ PASSED ] CASE: testPrintInfoLog (827134 ns)
    [ PASSED ] CASE: testPrintErrorLog (239574 ns)
    [ PASSED ] CASE: testPrintWarnLog (476510 ns)
    [ PASSED ] CASE: testPrintOffLog (435796 ns)
    [ PASSED ] CASE: testPrintDebugLog (500002 ns)
    [ PASSED ] CASE: testPrintTraceLog (320567 ns)
    [ PASSED ] CASE: testPrintAllLog (279050 ns)
Summary: TOTAL: 10
    PASSED: 10, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------
cpm test --verbose success

```
## 生成测试报告

#### 利用命令行生成

```
cd log4cj2 #log4cj2项目名
cpm test --coverage 
cjcov --root=./ --html-details -o html_output #html_output可以自定义

运行结果：
会在当前项目目录下，生成html_output目录，在html_output目录下会生成html文件，总的覆盖率报告文件名固定为index.html

html_output目录文件如下：
观察整体覆盖率，打开index.html即可
观察具体的仓颉文件覆盖率，打开src_xxx_xxx.cj.html即可
├── doc
├── html_output
│   ├── cj_covlogs
│   │   ├── cjcov.log
│   │   ├── gcov_parse.log
│   ├── index.html
│   ├── src_appender_xxx.cj.html
│   ├── ...
│   ├── src_config_xxx.cj.html
│   ├── ....
│   ├── src_log_xxx.cj.html
│   ├── ...
│   ├── src_utils_xxx.cj.html
│   ├── ...
├── src
├── resources
```

#### 利用VScode插件生成
###### 生成单个文件覆盖率测试报告
选中Vscode左侧资源管理器中打开的项目src下的某个仓颉文件，右键，选择[Cangjie]Coverage，等待【输出】内容显示generate html success.查看项目中，发现会生成output目录，此目录下即测试报告放置的位置
```
output目录文件如下：
观察整体覆盖率(选中的单个文件)，打开index.html即可
观察具体的仓颉文件(选中的单个文件)覆盖率，打开src_xxx_xxx.cj.html即可
├── doc
├── html_output
│   ├── cj_covlogs
│   │   ├── cjcov.log
│   │   ├── gcov_parse.log
│   ├── index.html
│   ├── src_xxx_xxx.cj.html
├── src
├── resources
```
###### 生成某个模块（package）覆盖率测试报告
选中Vscode左侧资源管理器中打开的项目src下的某个package，右键，选择[Cangjie]Coverage，等待【输出】内容显示generate html success.查看项目中，发现会生成output目录，此目录下即测试报告放置的位置
```
output目录文件如下：
观察整体覆盖率(选中的package)，打开index.html即可
观察具体的仓颉文件(选中的package下某个文件)覆盖率，打开src_xxx_xxx.cj.html即可
├── doc
├── html_output
│   ├── cj_covlogs
│   │   ├── cjcov.log
│   │   ├── gcov_parse.log
│   ├── index.html
│   ├── src_xxx_xxx.cj.html
│   ├── ...
├── src
├── resources
```

###### 生成整个项目（src）覆盖率测试报告
选中Vscode左侧资源管理器中打开的项目src目录，右键，选择[Cangjie]Coverage，等待【输出】内容显示generate html success.查看项目中，发现会生成output目录，此目录下即测试报告放置的位置
```
output目录文件如下：
观察整体覆盖率(选中的src)，打开index.html即可
观察具体的仓颉文件(src下某个文件)覆盖率，打开src_xxx_xxx.cj.html即可
├── doc
├── html_output
│   ├── cj_covlogs
│   │   ├── cjcov.log
│   │   ├── gcov_parse.log
│   ├── index.html
│   ├── src_xxx_xxx.cj.html
│   ├── ...
├── src
├── resources
```

## 其他测试用例运行方式尝试以及问题所在
#### 利用cjc（仓颉编译器）运行

###### 以utils模块下的具体测试文件为例运行命令，依赖本模块下其他文件的方法不可运行
```
cd src/utils
cjc utils_test.cj --test

运行结果：
`error: undeclared identifier 'xxx'`
```

###### 以utils模块为例运行命令（-p 整包编译），不依赖其他模块下文件的方法可运行

utils包可以运行成功，因为utils包下仓颉文件中的方法不依赖其他包下任何仓颉文件的任何方法
```
cd src
cjc -p utils --test
运行完上述命令，会在src生成一个可执行文件main
./main
运行结果：
TP: utils, time elapsed: 618358 ns, Result:
    TCS: UtilTests, time elapsed: 616563 ns, RESULT:
    [ PASSED ] CASE: testGetNumByString (24528 ns)
    [ PASSED ] CASE: testStrToNumBySuffix (27097 ns)
    [ PASSED ] CASE: testFlushLeft (10152 ns)
    [ PASSED ] CASE: testTimeSlice (497387 ns)
    [ PASSED ] CASE: testFormatLogRecord (16797 ns)
    [ PASSED ] CASE: testLogRecord (3225 ns)
    [ PASSED ] CASE: testLogLevel (29372 ns)
Summary: TOTAL: 7
    PASSED: 7, SKIPPED: 0, ERROR: 0
    FAILED: 0
```
###### 以logger模块为例运行命令（-p 整包编译），依赖其他模块下文件的方法不可运行

logger包运行不成功，因为logger包下仓颉文件中的方法依赖其他包下仓颉文件的方法
```
cd src
cjc -p logger --test

运行结果：
error: package 'appender' is a dependency of package 'logger', and the parent path of the module which package 'appender' belongs to should be listed in environmental variable CANGJIE_PATH
```
## 建议
1.测试用例所在仓颉文件，按照项目已有package分类归置<br/>
2.运行测试用例采用cpm test方式<br/>
3.生成测试报告采用界面操作生成（vscode仓颉插件）方式<br/>
