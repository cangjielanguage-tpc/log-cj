package appender

/**
 * LoggerAppender Reference Model Class
 * */
public class LoggerAppenderReference {
    //Log level default info
    private var level: LogLevel = DEFAULT_LOG_LEVEL

    //appender List
    private var appenderList: ArrayList<LoggerAppender> = ArrayList<LoggerAppender>()

    /**
     * Initialization
     *
     * @param level Log Level
     * @param appender Initialization Appender Attribute list
     */
    public init(level: LogLevel, appenderList: ArrayList<LoggerAppender>) {
        this.level = level
        this.appenderList = appenderList
    }

    public init() {}

    public func getAppenderList() {
        return this.appenderList
    }

    public func setAppenderList(appenderList: ArrayList<LoggerAppender>) {
        this.appenderList = appenderList
    }

    public func getLevel() {
        return this.level
    }

    public func setLevel(level: LogLevel) {
        this.level = level
    }
}
