/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines LoggerAppenderReference class.
 */

package appender

/**
 * LoggerAppender reference model class.
 */
public class LoggerAppenderReference {
    //Log level default info.
    private var level: LogLevel = DEFAULT_LOG_LEVEL

    //Appender list.
    private var appenderList: ArrayList<LoggerAppender> = ArrayList<LoggerAppender>()

    /**
     * Constructor, initialize variables.
     *
     * @param level log level.
     * @param appender appender list.
     */
    public init(level: LogLevel, appenderList: ArrayList<LoggerAppender>) {
        this.level = level
        this.appenderList = appenderList
    }

    /**
     * No-parameter constructor.
     */
    public init() {}

    public func getAppenderList() {
        return this.appenderList
    }

    public func setAppenderList(appenderList: ArrayList<LoggerAppender>) {
        this.appenderList = appenderList
    }

    public func getLevel() {
        return this.level
    }

    public func setLevel(level: LogLevel) {
        this.level = level
    }
}
