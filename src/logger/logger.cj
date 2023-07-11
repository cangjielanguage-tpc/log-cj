/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines Logger class.
 */

package logger

from std import time.*

/**
 * Logger class, recording and outputting logs.
 */
public class Logger {
    // Logger name.
    private var name: String

    public init(name: String) {
        this.name = name
    }

    public func getName(): String {
        return this.name
    }

    /**
     * Entry for writing logs.
     *
     * @param level log level.
     * @param msg log information.
     */
    public func log(level: LogLevel, msg: String): Unit {
        // Currently, the method of obtaining the file name and line number is not available. Wait for the SDK to provide the method.
        let src = ""
        var rec = LogRecord(this.name, level, DateTime.now(), src, msg)

        // Consider whether thread processing needs to be started.
        doLog(level, rec)
    }

    /**
     * Writing Logs.
     *
     * @param level log level.
     * @param rec log record.
     */
    private func doLog(level: LogLevel, rec: LogRecord): Unit {
        appendLog(level, rec, Logger_Manager.getRootLogger())

        // If there are logs other than root in the configuration, to Print.
        if (Logger_Manager.getLoggerNameArr().size > 0 && Logger_Manager.getLoggerAttrArr().size > 0) {
            var i: Int64 = 0
            while (i < Logger_Manager.getLoggerNameArr().size) {
                var mapString: String = Logger_Manager.getLoggerNameArr().toArray().toString()
                if (mapString.contains(this.name)) {
                    var j: Int64 = 0
                    var values: Array<LoggerAppenderReference> = Logger_Manager.getLoggerAttrArr().toArray()
                    while (j < values.size) {
                        appendLog(level, rec, values.get(j).getOrThrow())
                        j++
                    }
                }
                i++
            }
        }
    }

    /**
     * Append log.
     *
     * @param level log level.
     * @param rec log record.
     * @param appenderRef log appender-ref.
     */
    private func appendLog(level: LogLevel, rec: LogRecord, appenderRef: LoggerAppenderReference): Unit {
        if (appenderRef.getAppenderList().size == 0) {
            return
        }

        if (level >= appenderRef.getLevel()) {
            var i: Int64 = 0
            while (i < appenderRef.getAppenderList().size) {
                var appender: LoggerAppender = appenderRef.getAppenderList().get(i).getOrThrow()
                appender.logWrite(rec)
                i++
            }
        }
    }

    /**
     * Print critical log.
     *
     * @param msg log information.
     */
    public func off(msg: String): Unit {
        log(OFF, msg)
    }

    /**
     * Print fatal log.
     *
     * @param msg log information.
     */
    public func fatal(msg: String): Unit {
        log(FATAL, msg)
    }

    /**
     * Print error log.
     *
     * @param msg log information.
     */
    public func error(msg: String): Unit {
        log(ERROR, msg)
    }

    /**
     * Print warn log.
     *
     * @param msg log information.
     */
    public func warn(msg: String): Unit {
        log(WARN, msg)
    }

    /**
     * Print info log.
     *
     * @param msg log inoformation.
     */
    public func info(msg: String): Unit {
        log(INFO, msg)
    }

    /**
     * Print debug log.
     *
     * @param msg log inoformation.
     */
    public func debug(msg: String): Unit {
        log(DEBUG, msg)
    }

    /**
     * Print trace log.
     *
     * @param msg log information.
     */
    public func trace(msg: String): Unit {
        log(TRACE, msg)
    }

    /**
     * Print fine log.
     *
     * @param msg log information.
     */
    public func all(msg: String): Unit {
        log(ALL, msg)
    }
}
