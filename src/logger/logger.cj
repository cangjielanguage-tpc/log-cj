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

    public func getName() {
        return this.name
    }

    /**
     * Entry for writing logs.
     *
     * @param level log level.
     * @param msg log information.
     */
    private func log(level: LogLevel, msg: String) {
        // Currently, the method of obtaining the file name and line number is not available. Wait for the SDK to provide the method.
        let src = ""
        var rec = LogRecord(this.name, level, Time.now(), src, msg)

        // Consider whether thread processing needs to be started.
        doLog(level, rec)
    }

    /**
     * Writing Logs.
     *
     * @param level log level.
     * @param rec log record.
     */
    private func doLog(level: LogLevel, rec: LogRecord) {
        appendLog(level, rec, Logger_Manager.getRootLogger())

        // If there are logs other than root in the configuration, to Print.
        if (Logger_Manager.getLoggerMap().size > 0) {
            for ((loggerName, loggerAppenderReference) in Logger_Manager.getLoggerMap()) {
                if (loggerName.contains(this.name)) {
                    appendLog(level, rec, loggerAppenderReference)
                }
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

    /**
     * Print critical log.
     *
     * @param msg log information.
     */
    public func off(msg: String) {
        log(OFF, msg)
    }

    /**
     * Print error log.
     *
     * @param msg log information.
     */
    public func error(msg: String) {
        log(ERROR, msg)
    }

    /**
     * Print warn log.
     *
     * @param msg log information.
     */
    public func warn(msg: String) {
        log(WARN, msg)
    }

    /**
     * Print info log.
     *
     * @param msg log inoformation.
     */
    public func info(msg: String) {
        log(INFO, msg)
    }

    /**
     * Print debug log.
     *
     * @param msg log inoformation.
     */
    public func debug(msg: String) {
        log(DEBUG, msg)
    }

    /**
     * Print trace log.
     *
     * @param msg log information.
     */
    public func trace(msg: String) {
        log(TRACE, msg)
    }

    /**
     * Print fine log.
     *
     * @param msg log information.
     */
    public func all(msg: String) {
        log(ALL, msg)
    }
}
