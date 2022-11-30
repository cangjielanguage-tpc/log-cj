package config

from std import collection.ArrayList
import utils.*

/**
   日志配置，包含 appender rootlogger logger 配置
 * */
public class LoggerConfiguration {
    // 配置中解析的 appender 集合
    private var appenders = ArrayList<AppenderConfig>()

    // 配置中解析的 rootLogger， 默认 INFO 级别日志
    private var root: RootLoggerConfig = RootLoggerConfig(DEFAULT_LOG_LEVEL.levelName(), ArrayList<AppenderRef>())

    // 配置中解析的自定义 logger
    private var logger = ArrayList<LoggerConfig>()

    public init(appenders: ArrayList<AppenderConfig>, root: RootLoggerConfig, logger: ArrayList<LoggerConfig>) {
        this.appenders = appenders
        this.root = root
        this.logger = logger
    }

    public init() {}

    public func getAppenders() {
        return this.appenders
    }

    public func getRoot() {
        return this.root
    }

    public func getLogger() {
        return this.logger
    }
}
