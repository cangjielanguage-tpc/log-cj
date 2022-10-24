package utils

from std import time.*

/**
 * 日志记录类，主要记录每一条日志信息
 * */
public class LogRecord {
    // TAG 名称，记录哪个类/文件打印的
    public var tagName: String = ""

    // 日志级别，默认 INFO
    public var level: LogLevel = DEFAULT_LOG_LEVEL

    // 该条日志记录创建时间
    public var created: Time

    // 日志源，用于打印日志打印位置信息，如所在代码行
    public var source: String = ""

    // 日志信息，具体打印信息
    public var message: String = ""

    public init(tagName: String, level: LogLevel, created: Time, source: String, message: String) {
        this.tagName = tagName
        this.level = level
        this.created = created
        this.source = source
        this.message = message
    }

    public init(created: Time) {
        this.created = created
    }
}
