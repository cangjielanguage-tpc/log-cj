/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines LoggerAppenderFactory class.
 */

package appender

from std import collection.*
from std import sync.*

/**
 * LoggerAppender factory class, mainly used to register or get the specific implementation object of LoggerAppender according to name or type.
 */
public class LoggerAppenderFactory {
    private var appender = HashMap<String, LoggerAppender>()
    private var appenderType = HashMap<String, LoggerAppender>()
    private var typeLock: ReentrantMutex = ReentrantMutex()

    /**
     * Constructor, initialize variables.
     */
    public init(
        appender: HashMap<String, LoggerAppender>,
        appenderType: HashMap<String, LoggerAppender>,
        typeLock: ReentrantMutex
    ) {
        this.appender = appender
        this.appenderType = appenderType
        this.typeLock = typeLock
    }

    /**
     * No-parameter constructor.
     */
    public init() {}

    /**
     * Clear logger appender.
     *
     * @return new object of this class.
     */
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

    /**
     * Register logger appender.
     *
     * @param typeName logger appender type name.
     * @param typeClz logger appender type class.
     * @return new object of this class.
     */
    public func registryType(typeName: String, typeClz: LoggerAppender): LoggerAppenderFactory {
        this.typeLock.lock()
        if (typeClz is LoggerAppender) {
            this.appenderType[typeName.toAsciiLower()] = typeClz
        }
        this.typeLock.unlock()
        return this
    }

    /**
     * Get logger appender by type name.
     *
     * @param typeName appender logger type name.
     * @return implementation class of LoggerAppender. if typeName doesn't meet the condtion, return console appender logger.
     */
    public func getAppenderByType(typeName: String): LoggerAppender {
        if (this.appenderType.contains(typeName.toAsciiLower())) {
            return this.appenderType[typeName.toAsciiLower()]
        }
        return ConsoleLoggerAppender()
    }

    /**
     * Get logger appender by name.
     *
     * @param name  appender name.
     * @return implementation class of LoggerAppender. if typeName doesn't meet the condtion, return console appender logger.
     */
    public func getAppenderByName(name: String): LoggerAppender {
        if (this.appender.contains(name.toAsciiLower())) {
            return this.appender[name.toAsciiLower()]
        }
        return ConsoleLoggerAppender()
    }

    /**
     * Register logger appender.
     *
     * @param name  appender name.
     * @param typename  appender type name
     * @param pattern  log pattern.
     * @param properties appender preperties.
     * @return new object of this class.
     */
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

            //Error handling should return null
            return LoggerAppenderFactory()
        }
        var newObj = getAppenderByType(typename)
        newObj.initAppender(pattern, properties)
        newObj.start()
        this.appender[appenderName] = newObj
        this.typeLock.lock()
        return this
    }
}
