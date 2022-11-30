package config

from std import collection.ArrayList
import utils.*

/**
   日志配置，包含 appender rootlogger logger 配置
 * */
public class LoggerConfiguration {
    // 配置中解析的 appender 集合
    public var appender = ArrayList<AppenderConfig>()

    // 配置中解析的 rootLogger， 默认 INFO 级别日志
    public var root: RootLoggerConfig = RootLoggerConfig(DEFAULT_LOG_LEVEL.levelName(), ArrayList<AppenderRef>())

    // 配置中解析的自定义 logger
    public var logger = ArrayList<LoggerConfig>()

    public init(appender: ArrayList<AppenderConfig>, root: RootLoggerConfig, logger: ArrayList<LoggerConfig>) {
        this.appender = appender
        this.root = root
        this.logger = logger
    }

    public init() {}
}
