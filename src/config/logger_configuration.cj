package config

from std import collection.ArrayList
import utils.*

/**
 * Log Congiguration,Containing appender rootlogger logger Congiguration.
 */
public class LoggerConfiguration {
    // Resolved in the configuration appender gathers
    private var appenders = ArrayList<AppenderConfig>()

    // Resolved in the configuration rootLogger,default INFO lever log.
    private var root: RootLoggerConfig = RootLoggerConfig(DEFAULT_LOG_LEVEL.levelName(), ArrayList<AppenderRef>())

    // Configuration Resolved Customization logger
    private var logger = ArrayList<LoggerConfig>()

    /**
     * Initialization AppenderConfig,RootLoggerConfig,LoggerConfig
     *
     * @param appenders configuration file object list
     * @param root root configuration
     * @param logger log model list
     */
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
