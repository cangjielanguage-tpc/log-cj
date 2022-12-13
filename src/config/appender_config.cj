/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines AppenderConfig class.
 */

package config

from std import collection.ArrayList

/**
 * Appender model class of log file.
 * The configuration is similar to the following:
 * <appender enabled="true" name="file">
 * <type>file</type>
 * <pattern>[%D %T %m] [%L][%l] (%S) %M</pattern>
 * <property name="filename">test.log</property>
 * </appender>
 */
public class AppenderConfig {
    // Appender enabled status.
    private var enabled: String

    // Appender name.
    private var name: String

    // Appender Type: file or console.
    private var appenderType: String

    // Output format: mainly used to standardize the display style of output time.
    private var pattern: String

    // Appender attribute list.
    private var properties: ArrayList<AppenderProperty>

    /**
     * Constructor, initialize variables.
     */
    public init() {
        this.enabled = ""
        this.name = ""
        this.appenderType = ""
        this.pattern = ""
        this.properties = ArrayList<AppenderProperty>()
    }

    /**
     * Constructor, initialize variables.
     *
     * @param enabled appender enabled status.
     * @param name appender name.
     * @param appenderType appender type.
     * @param pattern log record output format.
     * @param properties appender properties.
     */
    public init(
        enabled: String,
        name: String,
        appenderType: String,
        pattern: String,
        properties: ArrayList<AppenderProperty>
    ) {
        this.enabled = enabled
        this.name = name
        this.appenderType = appenderType
        this.pattern = pattern
        this.properties = properties
    }

    public func getEnabled() {
        return this.enabled
    }

    public func setEnabled(enabled: String) {
        this.enabled = enabled
    }

    public func getName() {
        return this.name
    }

    public func setName(name: String) {
        this.name = name
    }

    public func getAppenderType() {
        return this.appenderType
    }

    public func setAppenderType(appenderType: String) {
        this.appenderType = appenderType
    }

    public func getPattern() {
        return this.pattern
    }

    public func setPattern(pattern: String) {
        this.pattern = pattern
    }

    public func getProperties() {
        return this.properties
    }

    public func setProperties(properties: ArrayList<AppenderProperty>) {
        this.properties = properties
    }
}
