// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
package test

from log4cj import utils.*
from log4cj import config.*
from std import collection.*

main(): Int64 {
    println("测试开始")

    var res1: Bool = testLoggerConfig()
    println("testLoggerConfig = ${res1}")

    var res2: Bool = testLoggerConfigWithAttrs()
    println("testLoggerConfigWithAttrs = ${res2}")

    var res3: Bool = testLoggerConfigWithInitParams()
    println("testLoggerConfigWithInitParams = ${res3}")

    var res4: Bool = testAppenderConfig()
    println("testAppenderConfig = ${res4}")

    var res5: Bool = testAppenderConfigWithAttrs()
    println("testAppenderConfigWithAttrs = ${res5}")

    var res6: Bool = testAppenderConfigWithInitParams()
    println("testAppenderConfigWithInitParams = ${res6}")

    var res7: Bool = testAppenderProperty()
    println("testAppenderProperty = ${res7}")

    var res8: Bool = testAppenderPropertyWithAttrs()
    println("testAppenderPropertyWithAttrs = ${res8}")

    var res9: Bool = testAppenderPropertyWithInitParams()
    println("testAppenderPropertyWithInitParams = ${res9}")

    var res10: Bool = testAppenderRef()
    println("testAppenderRef = ${res10}")

    var res11: Bool = testLoggerConfiguartion()
    println("testLoggerConfiguartion = ${res11}")

    var res12: Bool = testLoggerConfiguartionWithInitParams()
    println("testLoggerConfiguartionWithInitParams = ${res12}")

    var res13: Bool = testRootLoggerConfig()
    println("testRootLoggerConfig = ${res13}")

    var res14: Bool = testRootLoggerConfigWithAttrs()
    println("testRootLoggerConfigWithAttrs = ${res14}")

    var res15: Bool = testRootLoggerConfigWithInitParams()
    println("testRootLoggerConfigWithInitParams = ${res15}")

    println("测试结束")
    if (res1 && res2 && res3 && res4) {
        return 0
    }

    if (res5 && res6 && res7 && res8) {
        return 0
    }

    if (res9 && res10 && res11 && res12) {
        return 0
    }

    if (res13 && res14 && res15) {
        return 0
    }
    return -1
}

func testLoggerConfig(): Bool {
    var logger: LoggerConfig = LoggerConfig()
    var name: String = logger.getName()
    var level: String = logger.getLevel()
    var size: Int64 = logger.getAppenderRefList().size

    if (name.equals("") && level.equals("") && size == 0) {
        return true
    }
    return false
}

func testLoggerConfigWithAttrs(): Bool {
    var logger: LoggerConfig = LoggerConfig()
    logger.setName("name")
    logger.setLevel("info")
    var list = ArrayList<AppenderRef>()
    var ref = AppenderRef("file")
    list.append(ref)
    logger.setAppenderRefList(list)
    var name: String = logger.getName()
    var level: String = logger.getLevel()
    var size: Int64 = logger.getAppenderRefList().size
    if (name.equals("name") && level.equals("info") && size == 1) {
        return true
    }
    return false
}

func testLoggerConfigWithInitParams(): Bool {
    var list = ArrayList<AppenderRef>()
    var ref = AppenderRef("file")
    list.append(ref)
    var logger: LoggerConfig = LoggerConfig("name", "info", list)
    var name: String = logger.getName()
    var level: String = logger.getLevel()
    var size: Int64 = logger.getAppenderRefList().size
    if (name.equals("name") && level.equals("info") && size == 1) {
        return true
    }
    return false
}

func testAppenderConfig(): Bool {
    var appenderConfig: AppenderConfig = AppenderConfig()
    var enabled: String = appenderConfig.getEnabled()
    var name: String = appenderConfig.getName()
    var appenderType: String = appenderConfig.getAppenderType()
    var pattern: String = appenderConfig.getPattern()
    var size: Int64 = appenderConfig.getProperties().size
    if (enabled.equals("") && name.equals("") && appenderType.equals("") && pattern.equals("") && size == 0) {
        return true
    }
    return false
}

func testAppenderConfigWithAttrs(): Bool {
    var appenderConfig: AppenderConfig = AppenderConfig()
    appenderConfig.setEnabled("true")
    appenderConfig.setName("config")
    appenderConfig.setAppenderType("file")
    appenderConfig.setPattern("pattern")
    var properties: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
    var pro1: AppenderProperty = AppenderProperty("name1", "value1")
    properties.append(pro1)
    appenderConfig.setProperties(properties)
    var enabled: String = appenderConfig.getEnabled()
    var name: String = appenderConfig.getName()
    var appenderType: String = appenderConfig.getAppenderType()
    var pattern: String = appenderConfig.getPattern()
    var size: Int64 = appenderConfig.getProperties().size
    if (enabled.equals("true") && name.equals("config") && appenderType.equals("file") && pattern.equals("pattern") &&
        size == 1) {
        return true
    }
    return false
}

func testAppenderConfigWithInitParams(): Bool {
    var properties: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
    var pro1: AppenderProperty = AppenderProperty("name1", "value1")
    properties.append(pro1)
    var appenderConfig: AppenderConfig = AppenderConfig("true", "config", "file", "pattern", properties)
    var enabled: String = appenderConfig.getEnabled()
    var name: String = appenderConfig.getName()
    var appenderType: String = appenderConfig.getAppenderType()
    var pattern: String = appenderConfig.getPattern()
    var size: Int64 = appenderConfig.getProperties().size
    if (enabled.equals("true") && name.equals("config") && appenderType.equals("file") && pattern.equals("pattern") &&
        size == 1) {
        return true
    }
    return false
}

func testAppenderProperty(): Bool {
    var property: AppenderProperty = AppenderProperty()
    var name: String = property.getName()
    var value: String = property.getValue()
    if (name.equals("") && value.equals("")) {
        return true
    }
    return false
}

func testAppenderPropertyWithAttrs(): Bool {
    var property: AppenderProperty = AppenderProperty()
    property.setName("name")
    property.setValue("value")
    var name: String = property.getName()
    var value: String = property.getValue()
    if (name.equals("name") && value.equals("value")) {
        return true
    }
    return false
}

func testAppenderPropertyWithInitParams(): Bool {
    var property: AppenderProperty = AppenderProperty("name", "value")
    var name: String = property.getName()
    var value: String = property.getValue()
    if (name.equals("name") && value.equals("value")) {
        return true
    }
    return false
}

func testAppenderRef(): Bool {
    var ref: AppenderRef = AppenderRef()
    var ref2: AppenderRef = AppenderRef("file")
    if (ref.getRef().equals("") && ref2.getRef().equals("file")) {
        return true
    }
    return false
}

func testLoggerConfiguartion(): Bool {
    var config: LoggerConfiguration = LoggerConfiguration()
    var size: Int64 = config.getAppenders().size
    var level: String = config.getRoot().getLevel()
    var size2: Int64 = config.getLogger().size
    if (size == 0 && level.equals("INFO") && size2 == 0) {
        return true
    }
    return false
}

func testLoggerConfiguartionWithInitParams(): Bool {
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
    var size: Int64 = config.getAppenders().size
    var size2: Int64 = config.getRoot().getAppenderRefList().size
    var size3: Int64 = config.getLogger().size
    if (size == 1 && size2 == 1 && size3 == 1) {
        return true
    }
    return false
}

func testRootLoggerConfig(): Bool {
    var root: RootLoggerConfig = RootLoggerConfig()
    var level: String = root.getLevel()
    var size: Int64 = root.getAppenderRefList().size
    if (level.equals("") && size == 0) {
        return true
    }
    return false
}

func testRootLoggerConfigWithAttrs(): Bool {
    var root: RootLoggerConfig = RootLoggerConfig()
    root.setLevel("info")
    var list = ArrayList<AppenderRef>()
    var ref = AppenderRef("file")
    list.append(ref)
    root.setAppenderRefList(list)
    var level: String = root.getLevel()
    var size: Int64 = root.getAppenderRefList().size
    if (level.equals("info") && size == 1) {
        return true
    }
    return false
}

func testRootLoggerConfigWithInitParams(): Bool {
    var list = ArrayList<AppenderRef>()
    var ref = AppenderRef("file")
    list.append(ref)
    var root: RootLoggerConfig = RootLoggerConfig("info", list)
    var level: String = root.getLevel()
    var size: Int64 = root.getAppenderRefList().size
    if (level.equals("info") && size == 1) {
        return true
    }
    return false
}
