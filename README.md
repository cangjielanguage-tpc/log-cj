# Log4CJ2

#### 介绍

仓颉语言实现日志打印功能，类似 log4j 三方件。

#### 软件架构

源码目录

```shell
├── doc
├── src
│   ├── appender
│   │   ├── console_logger_appender.cj
│   │   ├── file_logger_appender.cj
│   │   ├── logger_appender.cj
│   │   ├── logger_appender_factory.cj
│   │   └── logger_appender_reference.cj
│   ├── config
│   │   ├── appender_config.cj
│   │   ├── appender_property.cj
│   │   ├── appender_ref.cj
│   │   ├── logger_config.cj
│   │   ├── logger_configuration.cj
│   │   └── root_logger_config.cj
│   ├── logger
│   │   ├── logger.cj
│   │   └── logger_manager.cj
│   └── utils
│       ├── log_level.cj
│       ├── log_record.cj
│       ├── pattern_converter.cj
│       ├── time_slice.cj
│       └── util.cj
├── log4cj.xml
├── test
│   ├── HLT
│   ├── LLT
│   └── UT
```

- `doc` 库的设计文档、提案、库的使用文档、LLT 覆盖率报告
- `src` 库源码目录
- `log4cj.xml` 日志配置文件
- `test` 测试用例，包括HLT用例、LLT 用例和UT用例 

#### 安装教程

正在开发中，未达到release版本，待更新

#### 使用说明

1. 打印日志

   代码示例：

```go
import logger.*

main(): Int64 {
    // 创建一个 Logger
    let logger = Logger_Manager.getLogger("com.hello")

    // 打印日志
    logger.info("hello")
    logger.info("hello")
    logger.error("hello")

    // 创建另一个 Logger
    let logger1 = Logger_Manager.getLogger("com.test1")
    logger1.warn("test1 waring")
    return 0
}
```

   打印结果：

```textile
[2022/10/22 23:38:08 CST 460] [INFO][com.hello] () hello
[2022/10/22 23:38:08 CST 460] [INFO][com.hello] () hello
[2022/10/22 23:38:08 CST 460] [ERROR][com.hello] () hello
[2022/10/22 23:38:08 CST 460] [WARN][com.test1] () test1 waring
```

   ()中为待实现的打印日志的具体文件执行代码行（仓颉暂未开放该api接口）

2. 注册自定义 LoggerAppender 
   
   ```go
   public class SampleLoggerAppender <: LoggerAppender {
       // 格式化打印规则字符串
       var pattern: String = ""
   
       public func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit {}
   
       public func start(): Unit {}
   
       public func logWrite(rec: LogRecord): Unit {}
   
       public func close(): Unit {}
   }
   Logger_Appender_Factory.registryType("sample", SampleLoggerAppender())
   ```

#### 待办事务

1. 错误处理逻辑

2. 多线程优化（异步写入spwan方式存在数据丢失）

3. 日志打包后压缩文件

4. 默认日志文件处理

5. 代码打包

6. UT补充

#### 参与贡献
[@zhangxyjlu](https://gitee.com/zhangxyjlu)
[@helongfei](https://gitee.com/helongfei_it)
