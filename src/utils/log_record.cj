package utils

from std import time.*

/**
 * 日志记录类，主要记录每一条日志信息
 * */
public class LogRecord {
    // TAG 名称，记录哪个类/文件打印的
    private var tagName: String = ""

    // 日志级别，默认 INFO
    private var level: LogLevel = DEFAULT_LOG_LEVEL

    // 该条日志记录创建时间
    private var createdTime: Time

    // 日志源，用于打印日志打印位置信息，如所在代码行
    private var source: String = ""

    // 日志信息，具体打印信息
    private var message: String = ""

    public init(tagName: String, level: LogLevel, createdTime: Time, source: String, message: String) {
        this.tagName = tagName
        this.level = level
        this.createdTime = createdTime
        this.source = source
        this.message = message
    }

    public init(createdTime: Time) {
        this.createdTime = createdTime
    }

    public func getTagName() {
        return this.tagName
    }

    public func getLevel() {
        return this.level
    }

    public func getSource() {
        return this.source
    }

    public func getMessage() {
        return this.message
    }

    public func getCreatedTime() {
        return this.createdTime
    }
}
