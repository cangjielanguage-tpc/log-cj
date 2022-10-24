package logger

from std import collection.*
from std import sync.*
import appender.*
import config.*
import utils.*

public let Logger_Appender_Factory = LoggerAppenderFactory()
public let Logger_Manager = LoggerManager()

/**
 * Log 管理类
 * */
public class LoggerManager {
    public var laf: LoggerAppenderFactory = LoggerAppenderFactory()
    public var rootLogger: LoggerAppenderReference = LoggerAppenderReference()
    public var loggerMap: HashMap<String, LoggerAppenderReference> = HashMap<String, LoggerAppenderReference>()

    public init() {
        initLoggerManager()
    }

    /*
     * 获取 logger 对象
     * 参数 name - logger 名称
     */
    public func getLogger(name: String): Logger {
        var logger = Logger(name)
        return logger
    }

    /**
     * 初始化默认设置
     * */
    private func initWithDefaultConfig() {
        // TODO 默认获取项目中日志的配置文件，然后解析。
        let content = """
        <?xml version="1.0" encoding="UTF-8"?>
        <configuration>
        <appender enabled="true" name="console">
        <type>console</type>
        <pattern1>[%D %T] [%L] (%S) %M</pattern1>
        <!-- level is (:?FINEST|FINE|DEBUG|TRACE|INFO|WARNING|ERROR) -->
        </appender>
  
       <!-- 输出级别是info级别及以上的日志，下面的ref关联的两个appender没有filter设置，所以，info及以上的日志都是会输出到这2个appender的 -->
       <root>
       <level>info</level>
       <appender-ref ref="console" />
       </root>
       </configuration>
    """
        var lc = loadXML(content)
        initWithConfig(lc)
    }

    /*
     * 根据 LoggerConfiguration 对象信息，初始化 LoggerManager
     * 参数 configuration - 通过配置信息解析成的 LoggerConfiguration 对象
     */
    private func initWithConfig(configuration: LoggerConfiguration) {
        this.laf = Logger_Appender_Factory.new()
        this.loggerMap = HashMap<String, LoggerAppenderReference>()
        this.rootLogger = LoggerAppenderReference(DEFAULT_LOG_LEVEL, ArrayList<LoggerAppender>())

        let enabledMap = HashMap<String, Bool>()

        if (configuration.appender.size > 0) {
            for (appender in configuration.appender) {
                enabledMap[appender.name.toAsciiLower()] = appender.enabled.toAsciiLower().trimAscii() != "false"
                if (enabledMap[appender.name.toAsciiLower()]) {
                    this.laf.registerLoggerAppender(
                        appender.name,
                        appender.appenderType,
                        appender.pattern,
                        appender.property
                    )
                }
            }
        }

        // init root
        let rc = configuration.root

        this.rootLogger.level = LogLevel.getLevelByString(rc.level)
        this.rootLogger.appender = ArrayList<LoggerAppender>()

        if (rc.appender.size > 0) {
            for (appenderRef in rc.appender) {
                if (enabledMap.contains(appenderRef.ref.toAsciiLower()) && enabledMap[appenderRef.ref.toAsciiLower()]) {
                    let ap = this.laf.getAppenderRefByName(appenderRef.ref)
                    this.rootLogger.appender.append(ap)
                }
            }
        }

        // init logger
        if (configuration.logger.size > 0) {
            for (logger in configuration.logger) {
                let oneLogger = LoggerAppenderReference(LogLevel.getLevelByString(logger.level),
                    ArrayList<LoggerAppender>())
                for (appenderRef in logger.appender) {
                    if (enabledMap.contains(appenderRef.ref.toAsciiLower()) && enabledMap[appenderRef.ref.toAsciiLower()]) {
                        let ap = this.laf.getAppenderRefByName(appenderRef.ref)
                        oneLogger.appender.append(ap)
                    }
                }
                if (oneLogger.appender.size > 0) {
                    this.loggerMap[logger.name] = oneLogger
                }
            }
        }
    }

    /*
     * 根据 xml 配置信息，初始化 LoggerManager
     * 参数 xmlFile - xml配置文件名
     */
    public func initWithXML(xmlFile: String) {
        let lc = loadXMLConfigurationProperties(xmlFile)
        initWithConfig(lc)
    }

    private func initLoggerManager() {
        // 注册系统自带的 LoggerAppender()
        Logger_Appender_Factory.registryType("console", ConsoleLoggerAppender())
        Logger_Appender_Factory.registryType("file", FileLoggerAppender())

        // 初始化日志配置文件
        initWithDefaultConfig()
    }

    /**
       该函数将xml文件解析成LoggerConfiguration对象
       TODO 临时测试用，待具体实现
     * */
    private func loadXML(content: String) {
        let xc = LoggerConfiguration()
        let appenderConfig = AppenderConfig(
            "true",
            "file",
            "file",
            "[%D %T %m] [%L][%l] (%S) %M",
            ArrayList<AppenderProperty>()
        )
        appenderConfig.property.append(AppenderProperty("filename", "test.log"))
        xc.appender.append(appenderConfig)

        let rootAppenderRef = AppenderRef("file")
        xc.root.appender.append(rootAppenderRef)

        return xc
    }

    // TODO 临时测试用，待具体实现
    private func loadXMLConfigurationProperties(filename: String) {
        let xc = LoggerConfiguration()
        return xc
    }
}
