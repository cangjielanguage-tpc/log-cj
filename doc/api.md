# Log4CJ2 核心 API 介绍

## 特性

- 支持stdout、stderr等系统输出
- 支持文件系统日志输出
- 支持使用XML进行配置
- 支持日志文件切分
- 支持历史日志文件指定时间自动删除


## 目录

- appender目录
-- 包含 appender 接口，和具体实 appender 现类，如控制台实现类：`console_logger_appender.cj` ，文件实现类：`file_logger_appender.cj`

- config目录
--  实现解析 xml 配置文件的模型目录，如：`appender_config.cj`

- logger目录
-- `logger.cj` : 打印日志接口类，实现不同级别的日志打印功能
-- `logger_manager.cj`：日志管理类，管理多个 `logger` 实例，加载日志配置等

- util目录
-- 工具类，如日志级别定义，日期格式化处理等工具实现

## 接口

### LoggerAppender接口

```cangjie
    /**
     * 初始化appender
     *
     * 参数 pattern - 日志输出格式
     * 参数 property - appender属性集合
	 *
	 * 返回值 Unit
	 *
     */
    func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit

    /**
     * 写日志之前
	 * 
	 * 返回值 Unit
     */
    func start(): Unit

    /**
     * 写日志
     *
     * 参数 rec - 日志记录
	 *
	 * 返回值 Unit
     */
    func logWrite(rec: LogRecord): Unit

    /**
     * 写日志之后
	 * 
	 * 清除关于LogWrite的任何残留内容
	 * 删除LogWrite，关闭后不应调用LogWrite
	 *
	 * 返回值 Unit
     */
    func close(): Unit
```

## LoggerAppender接口实现类

### ConsoleLoggerAppender
控制台实现类的initAppender方法实现：初始化日志输出的pattern<br/>

控制台实现类的start方法实现：无需实现<br/>

控制台实现类的LogWrite方法实现：格式化打印日志到控制台<br/>

控制台实现类的close方法实现：无需实现<br/>

### FileLoggerAppender

文件实现类的initAppender方法实现：初始化日志配置文件中相关Appender的属性，例如`filename`,'maxsize'等<br/>

文件实现类的start方法实现：处理日志文件，打开文件，定义日志文件的文件名，操作日期等<br/>

文件实现类的LogWrite方法实现：<br/>

- 写日志方法采用仓颉spawn...getResult..模式处理多线程

- 判断文件是否关闭，如果关闭，则执行start方法，重新打开文件

- 进行日志文件切分的情况 
-- 比较日志文件的maxsize和当前文件的大小，当前文件大小大于maxsize，则进行切分
-- 判断文件按天归类，并且文件的操作日期和当前日期不相符，则进行切分

- 格式化日志记录，写入文件

- 重新计算当前日志的大小

文件实现类的close方法实现：对日志文件进行刷新和关闭<br/>

## LoggerAppenderFactory类

### 功能

- 根据名称或类型注册LoggerAppender
- 获取LoggerAppender的具体实现对象

### 主要方法

#### func new

```cangjie
 /**
  * 清空工厂类中相关Appender属性，获得新的工厂类对象
  *
  * 返回值 LoggerAppenderFactory
  */
 public func new(): LoggerAppenderFactory
```

#### func registryType

```cangjie
 /**
  * 根据LoggerAppender的类型和类型名称注册Appender到工厂类的appenderType属性
  *
  * 参数 typename - LoggerAppender类型名称
  * 参数 typeClz  - LoggerAppender类型
  *
  * 返回值 LoggerAppenderFactory
  */
  public func registryType(typeName: String, typeClz: LoggerAppender): LoggerAppenderFactory
```

#### func getAppenderByType

```cangjie
 /**
  * 根据LoggerAppender的类型名称获取特定类型的LoggerAppender
  *
  * 参数 typename - LoggerAppender类型名称
  *
  * 返回值 LoggerAppender
  */
  public func getAppenderByType(typeName: String): LoggerAppender
```

#### func getAppenderByName

```cangjie
 /**
  * 根据LoggerAppender的名称获取特定类型的LoggerAppender
  *
  * 参数 typename - LoggerAppender名称
  *
  * 返回值 LoggerAppender
  */
  public func getAppenderByName(name: String): LoggerAppender
```

#### func registerLoggerAppender

```cangjie
 /**
  * 根据LoggerAppender相关属性注册Appender到工厂类的剩余属性（写文件之前的准备工作）
  *
  * 参数 name       - LoggerAppender名称
  * 参数 typename   - LoggerAppender类型名称
  * 参数 pattern    - 日志输出格式
  * 参数 properties - Appender属性合集
  *
  * 返回值 LoggerAppenderFactory
  */
  public func registerLoggerAppender(
        name: String,
        typename: String,
        pattern: String,
        properties: ArrayList<AppenderProperty>
    ): LoggerAppenderFactory
```

## LoggerManager类

### 功能

- 解析日志配置文件得到配置项
- 解析默认配置
- 注册`ConsoleLoggerAppender`，`FileLoggerAppender`

### 主要方法

#### 初始化LoggerManager类

```cangjie
 /**
  * 初始化LoggerManager，通过内置路径得到日志配置项，并且注册ConsoleLoggerAppender，FileLoggerAppender
  *
  *
  * 参数 xmlPath - 配置文件路径
  */
 public init(xmlPath: String)
```

#### func loadDefaultConfiguration

```cangjie
 /**
  * 初始化过程中如果日志配置文件路径不正确或者内容为空，则加载默认配置
  *
  *
  * 返回值 LoggerConfiguration
  */
  public func loadDefaultConfiguration(): LoggerConfiguration
```

## Logger类

### 功能

- 打印不同级别的日志信息到Console，File

### 主要方法

#### func off

```cangjie
 /**
  * 打印off级别日志
  *
  * 参数 msg - 日志记录消息
  * 
  */
 public func off(msg: String): Unit
```

#### func error

```cangjie
 /**
  * 打印error级别日志
  *
  * 参数 msg - 日志记录消息
  * 
  */
 public func error(msg: String): Unit
```

#### func warn

```cangjie
 /**
  * 打印warn级别日志
  *
  * 参数 msg - 日志记录消息
  * 
  */
 public func warn(msg: String): Unit
```

#### func info

```cangjie
 /**
  * 打印info级别日志
  *
  * 参数 msg - 日志记录消息
  * 
  */
 public func info(msg: String): Unit
```

#### func debug

```cangjie
 /**
  * 打印debug级别日志
  *
  * 参数 msg - 日志记录消息
  * 
  */
 public func warn(msg: String): Unit
```

#### func trace

```cangjie
 /**
  * 打印trace级别日志
  *
  * 参数 msg - 日志记录消息
  * 
  */
 public func trace(msg: String): Unit
```

#### func all

```cangjie
 /**
  * 打印all级别日志
  *
  * 参数 msg - 日志记录消息
  * 
  */
 public func all(msg: String): Unit
```

## 日志级别

### 等级关系

- ALL<TRACE<DEBUG<INFO<WARN<ERROR<OFF

### 日志输出说明

#### Console

- 控制台输出和文件输出保持一致

#### File

- 文件输出受配置文件中root和logger节点的level影响
- 举例说明：例如配置level为info，文件则输出info，warn，error，off级别的日志


## 使用示例

### 配置文件

```cangjie
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appender enabled="true" name="console">
        <type>console</type>
        <pattern>[%D %T %m] [%L] [%l] (%S) %M</pattern>
    </appender>
    <appender enabled="true" name="file">
        <type>file</type>
        <pattern>[%D %T %m] [%L] [%l] (%S) %M</pattern>
        <property name="filename">root.log</property>
        <property name="rotate">true</property>
        <property name="maxsize">400</property>
        <property name="daily">false</property>
    </appender>
    <root>
        <level>info</level>
        <appender-ref ref="console" />
        <appender-ref ref="file" />
    </root>
</configuration>
```

### 示例代码

```cangjie
import logger.*

main(): Int64 {
    // Create a logger.
    let logger = Logger_Manager.getLogger("com.hello")

    // Print logs.
    logger.all("1")
    logger.trace("2")
    logger.debug("3")
    logger.info("4")
    logger.warn("5")

    // Create another logger.
    let logger1 = Logger_Manager.getLogger("com.test1")
    logger1.error("6")
    logger1.off("7")
    return 0
}
```
### 运行结果

#### 控制台输出

```cangjie
[Start]: run cpm build... 

[Execute Time - 1/13/2023, 10:11:27 AM]
cpm build success

[Execute Time - 1/13/2023, 10:11:27 AM]
[Execute Result]
can not find any logger in xml file!
[2023/01/13 10:11:27 CST 929] [INFO] [com.hello] () 4
[2023/01/13 10:11:27 CST 930] [WARN] [com.hello] () 5
[2023/01/13 10:11:27 CST 930] [ERROR] [com.test1] () 6
[2023/01/13 10:11:27 CST 930] [OFF] [com.test1] () 7
```

#### 日志文件输出

```cangjie
[2023/01/13 10:11:27 CST 929] [INFO] [com.hello] () 4
[2023/01/13 10:11:27 CST 930] [WARN] [com.hello] () 5
[2023/01/13 10:11:27 CST 930] [ERROR] [com.test1] () 6
[2023/01/13 10:11:27 CST 930] [OFF] [com.test1] () 7
```