/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

package config

from std import unittest.*
from std import unittest.testmacro.*

@Test
public class ConfigTests {
    @TestCase
    func testLoggerConfig(): Unit {
        var logger: LoggerConfig = LoggerConfig()
        @Assert(logger.getName(),"")
        @Assert(logger.getLevel(),"")
        @Assert(logger.getAppenderRefList().size,0)
    }

    @TestCase
    func testLoggerConfigWithAttrs(): Unit {
        var logger: LoggerConfig = LoggerConfig()
        logger.setName("name")
        logger.setLevel("info")
        var list = ArrayList<AppenderRef>()
        var ref = AppenderRef("file")
        list.append(ref)
        logger.setAppenderRefList(list)
        @Assert(logger.getName(),"name")
        @Assert(logger.getLevel(),"info")
        @Assert(logger.getAppenderRefList().size,1)
    }

    @TestCase
    func testLoggerConfigWithInitParams(): Unit {
        var list = ArrayList<AppenderRef>()
        var ref = AppenderRef("file")
        list.append(ref)
        var logger: LoggerConfig = LoggerConfig("name", "info", list)
        @Assert(logger.getName(),"name")
        @Assert(logger.getLevel(),"info")
        @Assert(logger.getAppenderRefList().size,1)
    }
    @TestCase
    func testAppenderConfig(): Unit {
        var appenderConfig: AppenderConfig = AppenderConfig()
        @Assert(appenderConfig.getEnabled(),"")
        @Assert(appenderConfig.getName(),"")
        @Assert(appenderConfig.getAppenderType(),"")
        @Assert(appenderConfig.getPattern(),"")
        @Assert(appenderConfig.getProperties().size,0)
    }

    @TestCase
    func testAppenderConfigWithAttrs(): Unit {
        var appenderConfig: AppenderConfig = AppenderConfig()
        appenderConfig.setEnabled("true")
        appenderConfig.setName("config")
        appenderConfig.setAppenderType("file")
        appenderConfig.setPattern("pattern")
        var properties: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var pro1: AppenderProperty = AppenderProperty("name1", "value1")
        properties.append(pro1)
        appenderConfig.setProperties(properties)
        @Assert(appenderConfig.getEnabled(),"true")
        @Assert(appenderConfig.getName(),"config")
        @Assert(appenderConfig.getAppenderType(),"file")
        @Assert(appenderConfig.getPattern(),"pattern")
        @Assert(appenderConfig.getProperties().size,1)
    }

    @TestCase
    func testAppenderConfigWithInitParams(): Unit {
        var properties: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var pro1: AppenderProperty = AppenderProperty("name1", "value1")
        properties.append(pro1)
        var appenderConfig: AppenderConfig = AppenderConfig("true", "config", "file", "pattern", properties)
        @Assert(appenderConfig.getEnabled(),"true")
        @Assert(appenderConfig.getName(),"config")
        @Assert(appenderConfig.getAppenderType(),"file")
        @Assert(appenderConfig.getPattern(),"pattern")
        @Assert(appenderConfig.getProperties().size,1)
    }

    @TestCase
    func testAppenderProperty(): Unit {
        var property: AppenderProperty = AppenderProperty()
        @Assert(property.getName(),"")
        @Assert(property.getValue(),"")
    }

    @TestCase
    func testAppenderPropertyWithAttrs(): Unit {
        var property: AppenderProperty = AppenderProperty()
        property.setName("name")
        property.setValue("value")
        @Assert(property.getName(),"name")
        @Assert(property.getValue(),"value")
    }

    @TestCase
    func testAppenderPropertyWithInitParams(): Unit {
        var property: AppenderProperty = AppenderProperty("name", "value")
        @Assert(property.getName(),"name")
        @Assert(property.getValue(),"value")
    }

    @TestCase
    func testAppenderRef(): Unit {
        var ref: AppenderRef = AppenderRef()
        @Assert(ref.getRef(),"")
        var ref2: AppenderRef = AppenderRef("file")
        @Assert(ref2.getRef(),"file")
    }

    @TestCase
    func testLoggerConfiguartion(): Unit {
        var config: LoggerConfiguration = LoggerConfiguration()
        @Assert(config.getAppenders().size,0)
        @Assert(config.getRoot().getLevel(),"INFO")
        @Assert(config.getLogger().size,0)
    }

    @TestCase
    func testLoggerConfiguartionWithInitParams(): Unit {
        var appenders = ArrayList<AppenderConfig>()
        var properties: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var pro1: AppenderProperty = AppenderProperty("name1", "value1")
        properties.append(pro1)
        var appenderConfig: AppenderConfig = AppenderConfig("true", "config", "file", "pattern", properties)
        appenders.append(appenderConfig)

        var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
        var ref: AppenderRef = AppenderRef("file")
        refList.append(ref)
        var root: RootLoggerConfig = RootLoggerConfig("INFO", refList)

        var logger: LoggerConfig = LoggerConfig("name", "info", refList)
        var loggerList = ArrayList<LoggerConfig>()
        loggerList.append(logger)

        var config: LoggerConfiguration = LoggerConfiguration(appenders, root, loggerList)
        @Assert(config.getAppenders().size,1)
        @Assert(config.getRoot().getAppenderRefList().size,1)
        @Assert(config.getLogger().size,1)
    }

    @TestCase
    func testRootLoggerConfig(): Unit {
        var root: RootLoggerConfig = RootLoggerConfig()
        @Assert(root.getLevel(),"")
        @Assert(root.getAppenderRefList().size,0)
    }

    @TestCase
    func testRootLoggerConfigWithAttrs(): Unit {
        var root: RootLoggerConfig = RootLoggerConfig()
        root.setLevel("info")
        var list = ArrayList<AppenderRef>()
        var ref = AppenderRef("file")
        list.append(ref)
        root.setAppenderRefList(list)
        @Assert(root.getLevel(),"info")
        @Assert(root.getAppenderRefList().size,1)
    }

    @TestCase
    func testRootLoggerConfigWithInitParams(): Unit {
        var list = ArrayList<AppenderRef>()
        var ref = AppenderRef("file")
        list.append(ref)
        var root: RootLoggerConfig = RootLoggerConfig("info", list)
        @Assert(root.getLevel(),"info")
        @Assert(root.getAppenderRefList().size,1)
    }
}
