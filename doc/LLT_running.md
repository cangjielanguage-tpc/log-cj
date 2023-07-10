
# LLT（自测用例）运行说明

## LLT文件所在位置

test/LLT下xxx_test的仓颉文件
```shell
├── doc
├── src
├── test
│   ├── LLT
│   │    ├── xxx_test.cj
│   │    ├── ...
├── resources
│   ├── log4cj.json
```

## LLT运行先决条件

### 安装python3（版本3.6.9经测试可用，可高于此版本），配置环境变量

### 将项目根目录下的gitee_gate.ctg文件中的LLT=false修改为LLT=true

```cangjie
[coverage]
LLT = true
```

### 下载[测试库](https://gitee.com/HW-PLLab/testJekins/tree/dev)，将测试库中src目录下ci_test 文件夹复制到项目根目录中


## 运行LLT

### 进入项目根目录

```cangjie
cd log4cj2
```

### 编译

```cangjie
python3 ci_test/main.py build
```
**出现`cpm build success!!`，则表示运行成功（xxx为自己机器目录）**

```cangjie
[01-16 15:22:58] INFO - >>> 清理ci_lib中缓存文件...
[01-16 15:22:58] INFO - >>> 无其他三方库依赖
[01-16 15:22:58] INFO - start build.....
[01-16 15:22:58] INFO - Building with CPM.....
[01-16 15:22:58] INFO - CMD    : cpm build
[01-16 15:22:58] INFO - FILE   : xxx/log4cj2
[01-16 15:23:17] INFO - Stdout : cpm build success
[01-16 15:23:17] INFO - cpm build success!!
```

### 运行

```cangjie
python3 ci_test/main.py test
```
**出现`TestSuiteTask: Total: 4, PASS: 4, FAIL: 0`，则表示运行成功（xxx为自己机器目录）**

```cangjie
[01-16 15:27:49] INFO - start clear
[01-16 15:27:49] INFO - end clear
[01-16 15:27:49] INFO - CMD    : cjc --import-path xxx/log4cj2/build/log4cj/.. -L xxx/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  config_test.cj
[01-16 15:27:49] INFO - FILE   : config_test.cj
[01-16 15:27:52] INFO - CMD    : ./main
[01-16 15:27:52] INFO - FILE   : config_test.cj
[01-16 15:27:53] INFO - Stdout : 测试开始
[01-16 15:27:53] INFO - Stdout : testLoggerConfig = true
[01-16 15:27:53] INFO - Stdout : testLoggerConfigWithAttrs = true
[01-16 15:27:53] INFO - Stdout : testLoggerConfigWithInitParams = true
[01-16 15:27:53] INFO - Stdout : testAppenderConfig = true
[01-16 15:27:53] INFO - Stdout : testAppenderConfigWithAttrs = true
[01-16 15:27:53] INFO - Stdout : testAppenderConfigWithInitParams = true
[01-16 15:27:53] INFO - Stdout : testAppenderProperty = true
[01-16 15:27:53] INFO - Stdout : testAppenderPropertyWithAttrs = true
[01-16 15:27:53] INFO - Stdout : testAppenderPropertyWithInitParams = true
[01-16 15:27:53] INFO - Stdout : testAppenderRef = true
[01-16 15:27:53] INFO - Stdout : testLoggerConfiguartion = true
[01-16 15:27:53] INFO - Stdout : testLoggerConfiguartionWithInitParams = true
[01-16 15:27:53] INFO - Stdout : testRootLoggerConfig = true
[01-16 15:27:53] INFO - Stdout : testRootLoggerConfigWithAttrs = true
[01-16 15:27:53] INFO - Stdout : testRootLoggerConfigWithInitParams = true
[01-16 15:27:53] INFO - Stdout : 测试结束
[01-16 15:27:53] INFO - return : 0
[01-16 15:27:53] INFO -  >>=============================================<<
[01-16 15:27:53] INFO -
[01-16 15:27:53] INFO - CMD    : cjc --import-path xxx/log4cj2/build/log4cj/.. -L xxx/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  appender_test.cj
[01-16 15:27:53] INFO - FILE   : appender_test.cj
[01-16 15:27:56] INFO - CMD    : ./main
[01-16 15:27:56] INFO - FILE   : appender_test.cj
[01-16 15:27:56] INFO - Stdout : 测试开始
[01-16 15:27:56] INFO - Stdout : [15:27:56 CST 2023/01/16 590] [ALL][com.test] (source) message
[01-16 15:27:56] INFO - Stdout : testConsoleLoggerAppenderWithDefaultPattern = true
[01-16 15:27:56] INFO - Stdout : [15:27:56 CST 2023/01/16] [ALL] (source) message]
[01-16 15:27:56] INFO - Stdout : testConsoleLoggerAppenderWithOtherPattern = true
[01-16 15:27:56] INFO - Stdout : testFileLoggerAppenderWithDefaultPattern = true
[01-16 15:27:56] INFO - Stdout : testFileLoggerAppenderWithOtherPattern = true
[01-16 15:27:56] INFO - Stdout : testFileLoggerAppenderWithErrorRolling = true
[01-16 15:27:56] INFO - Stdout : testFileLoggerAppenderWithRightRolling = true
[01-16 15:27:56] INFO - Stdout : AppenderType is empty, please RegistryType at first
[01-16 15:27:56] INFO - Stdout : testAppenderFactoryNoType = true
[01-16 15:27:56] INFO - Stdout : testAppenderFactorWithConsoleType = true
[01-16 15:27:56] INFO - Stdout : testAppenderFactorWithInitParams = true
[01-16 15:27:56] INFO - Stdout : testAppenderFactorNoNew = true
[01-16 15:27:56] INFO - Stdout : testAppenderReference = true
[01-16 15:27:56] INFO - Stdout : testAppenderReferenceWithInitParams = true
[01-16 15:27:56] INFO - Stdout : testAppenderReferenceWithSetter = true
[01-16 15:27:56] INFO - Stdout : 测试结束
[01-16 15:27:56] INFO - return : 0
[01-16 15:27:56] INFO -  >>=============================================<<
[01-16 15:27:56] INFO -
[01-16 15:27:56] INFO - CMD    : cjc --import-path xxx/log4cj2/build/log4cj/.. -L xxx/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  util_test.cj
[01-16 15:27:56] INFO - FILE   : util_test.cj
[01-16 15:27:57] INFO - CMD    : ./main
[01-16 15:27:57] INFO - FILE   : util_test.cj
[01-16 15:27:57] INFO - Stdout : 测试开始
[01-16 15:27:57] INFO - Stdout : testGetNumByString = true
[01-16 15:27:57] INFO - Stdout : testStrToNumBySuffix = true
[01-16 15:27:57] INFO - Stdout : testFlushLeft = true
[01-16 15:27:57] INFO - Stdout : testFormatLogRecord = true
[01-16 15:27:57] INFO - Stdout : testLogRecord = true
[01-16 15:27:57] INFO - Stdout : testLogLevel = true
[01-16 15:27:57] INFO - Stdout : testGetLevelByString = true
[01-16 15:27:57] INFO - Stdout : testTimeSlice = true
[01-16 15:27:57] INFO - Stdout : testLogLevelOperator = false
[01-16 15:27:57] INFO - Stdout : 测试结束
[01-16 15:27:57] INFO - return : 0
[01-16 15:27:57] INFO -  >>=============================================<<
[01-16 15:27:57] INFO -
[01-16 15:27:57] INFO - CMD    : cjc --import-path xxx/log4cj2/build/log4cj/.. -L xxx/log4cj2/build/log4cj -l log4cj_config -l log4cj_appender -l log4cj_logger -l log4cj_utils  logger_test.cj
[01-16 15:27:57] INFO - FILE   : logger_test.cj
[01-16 15:28:00] INFO - CMD    : ./main
[01-16 15:28:00] INFO - FILE   : logger_test.cj
[01-16 15:28:00] INFO - Stdout : 测试开始
[01-16 15:28:00] INFO - Stdout : testLoadDefaultConfig = true
[01-16 15:28:00] INFO - Stdout : testGetLogger = true
[01-16 15:28:00] INFO - Stdout : testInitLogggerManager = true
[01-16 15:28:00] INFO - Stdout : [2023/01/16 15:28:00 CST 081] [INFO] [test] () info
[01-16 15:28:00] INFO - Stdout : testPrintInfoLog = true
[01-16 15:28:00] INFO - Stdout : [2023/01/16 15:28:00 CST 082] [ERROR] [test] () error
[01-16 15:28:00] INFO - Stdout : testPrintErrorLog = true
[01-16 15:28:00] INFO - Stdout : [2023/01/16 15:28:00 CST 082] [WARN] [test] () warn
[01-16 15:28:00] INFO - Stdout : testPrintWarnLog = true
[01-16 15:28:00] INFO - Stdout : [2023/01/16 15:28:00 CST 082] [OFF] [test] () off
[01-16 15:28:00] INFO - Stdout : testPrintOffLog = true
[01-16 15:28:00] INFO - Stdout : testPrintTraceLog = true
[01-16 15:28:00] INFO - Stdout : testPrintDebugLog = true
[01-16 15:28:00] INFO - Stdout : testPrintAllLog = true
[01-16 15:28:00] INFO - Stdout : testGetAppenderFactory = true
[01-16 15:28:00] INFO - Stdout : testInitLogggerManagerWithEmptyPath = true
[01-16 15:28:00] INFO - Stdout : 测试结束
[01-16 15:28:00] INFO - return : 0
[01-16 15:28:00] INFO -  >>=============================================<<
[01-16 15:28:00] INFO -
[01-16 15:28:00] INFO -
[01-16 15:28:00] INFO -
[01-16 15:28:00] INFO -   TestSuiteTask: Total: 4, PASS: 4, FAIL: 0
```

## 生成覆盖率报告（前提：LLT运行完成）

### 进入项目根目录，执行如下命令(xxx为自己机器目录)
**-root 在root目录或者在其递归子目录能找到gcda文件**<br/>
**-e 排除不需要计算覆盖率的文件**<br/>
**-o 输出目录**<br/>

```cangjie
cjcov --root=./ -e "xxx/log4cj2/ci_test/ xxx/log4cj2/doc/ xxx/log4cj2/src/main.cj" --html-details -o html_output
```

## 查看覆盖率报告

在项目根目录下的html_output目录下打开index.html，即可查看全部文件的覆盖率以及整体覆盖率