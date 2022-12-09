package utils

from std import time.*

/**
 * Log Recording Class,Record each log.
 */
public class LogRecord {
    // TAG name,Record that class/file printed
    private var tagName: String = ""

    // Log level,Default INFO
    private var level: LogLevel = DEFAULT_LOG_LEVEL

    // Time when the log record is created.
    private var createdTime: Time

    // Log source,which is used to print log location information,for example,the line where the code is located.
    private var source: String = ""

    // Log information,which is printed.
    private var message: String = ""

    /**
     * Initialize
     *
     * @param tagName tag name
     * @param level log Level
     * @param createdTime create Time
     * @param source source
     * @param message message
     */
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
