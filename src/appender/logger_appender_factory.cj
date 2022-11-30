package appender

from std import collection.*
from std import sync.*

/**
 * LoggerAppender 工厂类，主要用于实现根据 名称或类型注册/获取 LoggerAppender 具体实现对象
 * */
public class LoggerAppenderFactory {
    public var appender = HashMap<String, LoggerAppender>()
    public var appenderType = HashMap<String, LoggerAppender>()
    public var typeLock: ReentrantMutex = ReentrantMutex()

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

    // 清理 appender ，重新赋值
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

    // 根据类型注册 LoggerAppender 
    public func registryType(typename: String, typeClz: LoggerAppender): LoggerAppenderFactory {
        this.typeLock.lock()
        if (typeClz is LoggerAppender) {
            this.appenderType[typename.toAsciiLower()] = typeClz
        }
        this.typeLock.unlock()
        return this
    }

    // 通过类型获取 LoggerAppender，默认返回控制台appender
    public func getInterfaceByType(typename: String): LoggerAppender {
        if (this.appenderType.contains(typename.toAsciiLower())) {
            return this.appenderType[typename.toAsciiLower()]
        }
        return ConsoleLoggerAppender()
    }

    // 通过名称获取 LoggerAppender
    public func getAppenderRefByName(name: String): LoggerAppender {
        if (this.appender.contains(name.toAsciiLower())) {
            return this.appender[name.toAsciiLower()]
        }
        return ConsoleLoggerAppender()
    }

    // 注册 LoggerAppender
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
            // todo 错误处理 应该返回空
        }
        var newObj = getInterfaceByType(typename)
        newObj.initAppender(pattern, properties)
        newObj.start()
        this.appender[appenderName] = newObj
        this.typeLock.lock()
        return this
    }
}
