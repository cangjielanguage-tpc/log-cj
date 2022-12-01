package logger

from std import time.*

/**
 * Log 类
 * */
public class Logger {
    // logger 名称
    private var name: String

    public init(name: String) {
        this.name = name
    }

    public func getName() {
        return this.name
    }

    /*
     * 写日志操作入口
     * 参数 level - 日志级别
     * 参数 msg - 日志信息
     */
    private func log(level: LogLevel, msg: String) {
        // 暂时没有获取文件名和行号的方法，待sdk提供
        let src = ""
        var rec = LogRecord(this.name, level, Time.now(), src, msg)

        // 考虑是否需要启动线程处理
        doLog(level, rec)
    }

    /*
     * 写日志操作
     * 参数 level - 日志级别
     * 参数 rec - LogRecord 信息
     */
    private func doLog(level: LogLevel, rec: LogRecord) {
        appendLog(level, rec, Logger_Manager.getRootLogger())

        // 若配置中除 root 外有其他日志，则进行打印
        if (Logger_Manager.getLoggerMap().size > 0) {
            for ((loggerName, loggerAppenderReference) in Logger_Manager.getLoggerMap()) {
                if (loggerName.contains(this.name)) {
                    appendLog(level, rec, loggerAppenderReference)
                }
            }
        }
    }

    /*
     * 追加日志
     * 参数 level - 日志级别
     * 参数 rec - LogRecord 信息
     * 参数 appenderRef - LoggerAppenderReference 信息
     */
    private func appendLog(level: LogLevel, rec: LogRecord, appenderRef: LoggerAppenderReference) {
        if (appenderRef.getAppenderList().size == 0) {
            return
        }
        if (level >= appenderRef.getLevel()) {
            for (appender in appenderRef.getAppenderList()) {
                appender.logWrite(rec)
            }
        }
    }

    /*
     * 打印 critical 日志
     * 参数 msg - 日志信息
     */
    public func off(msg: String) {
        log(OFF, msg)
    }

    /*
     * 打印 error 日志
     * 参数 msg - 日志信息
     */
    public func error(msg: String) {
        log(ERROR, msg)
    }

    /*
     * 打印 warn 日志
     * 参数 msg - 日志信息
     */
    public func warn(msg: String) {
        log(WARN, msg)
    }

    /*
     * 打印 info 日志
     * 参数 msg - 日志信息
     */
    public func info(msg: String) {
        log(INFO, msg)
    }

    /*
     * 打印 debug 日志
     * 参数 msg - 日志信息
     */
    public func debug(msg: String) {
        log(DEBUG, msg)
    }

    /*
     * 打印 trace 日志
     * 参数 msg - 日志信息
     */
    public func trace(msg: String) {
        log(TRACE, msg)
    }

    /*
     * 打印 fine 日志
     * 参数 msg - 日志信息
     */
    public func all(msg: String) {
        log(ALL, msg)
    }
}
