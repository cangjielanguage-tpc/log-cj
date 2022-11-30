package appender

import utils.*

/**
   LoggerAppender 的具体实现类，实现控制台打印日志
 * */
public class ConsoleLoggerAppender <: LoggerAppender {
    // 格式化打印规则字符串
    var pattern: String = ""

    public func initAppender(pattern: String, property: ArrayList<AppenderProperty>): Unit {
        if (pattern.size == 0) {
            this.pattern = "[%T %D %m] [%L][%l] (%S) %M"
        } else {
            this.pattern = pattern
        }
    }

    public func start(): Unit {}

    public func logWrite(rec: LogRecord): Unit {
        print(getDefaultPatternConvert().formatLogRecord(pattern, rec))
    }

    public func close(): Unit {}
}
