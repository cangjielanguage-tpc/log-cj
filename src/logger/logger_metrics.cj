package logger

public let Logger_Metrics = LoggerMetrics()

/**
* log 计数类
**/
public class LoggerMetrics {
    public var logCount: Int64 = 0
    public var ignoreCount: Int64 = 0
    public var appendCount: Int64 = 0
    public var invalidCount: Int64 = 0

    public init() {}

    public init(logCount: Int64, ignoreCount: Int64, appendCount: Int64, invalidCount: Int64) {
        this.logCount = logCount
        this.ignoreCount = ignoreCount
        this.appendCount = appendCount
        this.invalidCount = invalidCount
    }
}
