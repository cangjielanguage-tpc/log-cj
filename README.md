# Log4CJ2

#### 介绍

仓颉语言实现日志打印功能，类似 log4j 三方件。

#### 软件架构

参见[Log4CJ 设计文档](./doc/Log4CJ%20Design.md)

源码目录

```shell
├── doc
├── src
│   ├── appender
│   │   ├── console_logger_appender.cj
│   │   ├── file_logger_appender.cj
│   │   ├── logger_appender.cj
│   │   ├── logger_appender_factory.cj
│   │   ├── logger_appender_reference.cj
│   │   └── appender_test.cj
│   ├── config
│   │   ├── appender_config.cj
│   │   ├── appender_property.cj
│   │   ├── appender_ref.cj
│   │   ├── logger_config.cj
│   │   ├── logger_configuration.cj
│   │   ├── root_logger_config.cj
│   │   └── config_test.cj
│   ├── logger
│   │   ├── logger.cj
│   │   ├── logger_manager.cj
│   │   └── logger_test.cj
│   └── utils
│       ├── log_level.cj
│       ├── log_record.cj
│       ├── pattern_converter.cj
│       ├── time_slice.cj
│       ├── util.cj
│       └── utils_test.cj
├── resources
│   ├── log4cj.xml
```

- `doc` 库的设计文档、提案、库的使用文档、LLT 覆盖率报告
- `src` 库源码和测试用例目录
- `resources` 资源文件目录
- `xxx_test.cj` 测试用例所在文件

#### 使用编译

参见[项目编译文件引用](./doc/quote_compiled_files.md)

#### 如何运行测试用例

参见[测试用例运行说明](./doc/test_case_running.md)

#### 使用说明

1. 打印日志

   代码示例：

```go
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

1. 代码健壮性处理

2. 多线程处理（异步写入spwan方式存在数据丢失）

3. 日志打包后压缩文件

4. 代码打包

5. UT补充(目前85.5%)

#### 参与贡献
[@zhangxyjlu](https://gitee.com/zhangxyjlu)

[@helongfei](https://gitee.com/helongfei_it)
