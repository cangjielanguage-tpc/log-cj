package appender

from std import collection.*
from std import sync.*

/**
 * Obtains the loggerAppender implementation object by name or type registration
 * */
public class LoggerAppenderFactory {
    private var appender = HashMap<String, LoggerAppender>()
    private var appenderType = HashMap<String, LoggerAppender>()
    private var typeLock: ReentrantMutex = ReentrantMutex()

    /**
     * Initialization LoggerAppender
     */
    public init(
        appender: HashMap<String, LoggerAppender>,
        appenderType: HashMap<String, LoggerAppender>,
        typeLock: ReentrantMutex
    ) {
        this.appender = appender
        this.appenderType = appenderType
        this.typeLock = typeLock
    }

    public init() {}

    /**
     * Cleanup appender,Reassign Value
     *
     * return this method
     */
    public func new(): LoggerAppenderFactory {
        this.typeLock.lock()
        if (this.appender.size > 0) {
            for ((k, v) in this.appender) {
                v.close()
            }
        }
        this.appender = HashMap<String, LoggerAppender>()
        this.typeLock.unlock()
        return this
    }

    /**
     * Register LoggerAppender
     *
     * @param typename type name
     * @param typeClz type
     *
     * return this method
     */
    public func registryType(typename: String, typeClz: LoggerAppender): LoggerAppenderFactory {
        this.typeLock.lock()
        if (typeClz is LoggerAppender) {
            this.appenderType[typename.toAsciiLower()] = typeClz
        }
        this.typeLock.unlock()
        return this
    }

    /**
     * Get LoggerAppender by type
     *
     * @param typename type name
     *
     * Get LoggerAppender according to the type. The default is ConsoleLoggerAppender
     */
    public func getAppenderByType(typename: String): LoggerAppender {
        if (this.appenderType.contains(typename.toAsciiLower())) {
            return this.appenderType[typename.toAsciiLower()]
        }
        return ConsoleLoggerAppender()
    }

    /**
     * Get LoggerAppender by name
     *
     * @param name  name
     *
     * return print logs
     */
    public func getAppenderByName(name: String): LoggerAppender {
        if (this.appender.contains(name.toAsciiLower())) {
            return this.appender[name.toAsciiLower()]
        }
        return ConsoleLoggerAppender()
    }

    /**
     * Register LoggerAppender
     *
     * @param name  name
     * @param typename  type name
     * @param pattern  pattern
     * @param properties Appender Attribute List
     *
     * return this method
     */
    public func registerLoggerAppender(
        name: String,
        typename: String,
        pattern: String,
        properties: ArrayList<AppenderProperty>
    ) {
        this.typeLock.lock()
        var appenderName = name.toAsciiLower()
        if (this.appenderType.size == 0) {
            println("AppenderType is empty, please RegistryType at first")
        }
        var newObj = getAppenderByType(typename)
        newObj.initAppender(pattern, properties)
        newObj.start()
        this.appender[appenderName] = newObj
        this.typeLock.lock()
        return this
    }
}
