//3rd_party_lib:log-cj/build/logcj
//3rd_party_lib:log-cj/build/zip4cj
//3rd_party_lib:log-cj/build/charset
package test

from std import unittest.*
from std import unittest.testmacro.*
from logcj import appender.*
from logcj import config.*
from logcj import logger.*
from logcj import utils.*
from std import time.*
from std import io.*
from std import fs.*
from std import sync.*
from std import collection.*

/**
 * appender类的验证
 */
@Test
public class LogTestC {
    var flag = false

    // 验证: class LoggerConfig
    // 空值创建
    @TestCase
    public func log_test_025():Unit{
        var logger_01: LoggerConfig = LoggerConfig()
        @Expect(logger_01.getName(),"")
        @Expect(logger_01.getLevel(),"")
        @Expect(logger_01.getAppenderRefList().size,0)
    }

    // 验证: class LoggerConfig
    // 正常数据
    @TestCase
    public func log_test_026():Unit{
        var logger_02: LoggerConfig = LoggerConfig()
        logger_02.setName("name_02")
        logger_02.setLevel("info_02")
        var list_02 = ArrayList<AppenderRef>()
        var ref_02 = AppenderRef("file")
        list_02.append(ref_02)
        logger_02.setAppenderRefList(list_02)
        @Expect(logger_02.getName(),"name_02")
        @Expect(logger_02.getLevel(),"info_02")
        @Expect(logger_02.getAppenderRefList().size,1)
    }

    // 验证: class LoggerConfig
    // 带参创建
    @TestCase
    public func log_test_027():Unit{
        var list_03 = ArrayList<AppenderRef>()
        var ref_03 = AppenderRef("file")
        list_03.append(ref_03)
        var logger_03: LoggerConfig = LoggerConfig("name_03", "info_03", list_03)
        @Expect(logger_03.getName(),"name_03")
        @Expect(logger_03.getLevel(),"info_03")
        @Expect(logger_03.getAppenderRefList().size,1)
    }

    // 验证: class LoggerConfig
    // 列表参数为空  中文/特殊符号  空值设置
    @TestCase
    public func log_test_028():Unit{
        var list_04 = ArrayList<AppenderRef>()
        var logger_04: LoggerConfig = LoggerConfig("name_04", "info_04", list_04)
        @Expect(logger_04.getName(),"name_04")
        @Expect(logger_04.getLevel(),"info_04")
        @Expect(logger_04.getAppenderRefList().size,0)    
    }

    // 验证: class LoggerConfig
    // 列表参数为空  中文/特殊符号  空值设置
    @TestCase
    public func log_test_029():Unit{
        var list_05 = ArrayList<AppenderRef>()
        var ref_05 = AppenderRef("file")
        list_05.append(ref_05)
        var logger_05: LoggerConfig = LoggerConfig("中文中文", "中文中文", list_05)
        @Expect(logger_05.getName(),"中文中文")
        @Expect(logger_05.getLevel(),"中文中文")
        @Expect(logger_05.getAppenderRefList().size,1)
    }

    // 验证: class LoggerConfig
    // 列表参数为空  中文/特殊符号  空值设置
    @TestCase
    public func log_test_030():Unit{
        var list_06 = ArrayList<AppenderRef>()
        var ref_06 = AppenderRef("file")
        list_06.append(ref_06)
        var logger_06: LoggerConfig = LoggerConfig(":<'{}{:", "<%$^(()", list_06)
        @Expect(logger_06.getName(),":<'{}{:")
        @Expect(logger_06.getLevel(),"<%$^(()")
        @Expect(logger_06.getAppenderRefList().size,1)
    }

    // 验证: class LoggerConfig
    // 列表参数为空  中文/特殊符号  空值设置
    @TestCase
    public func log_test_031():Unit{
        var list_07 = ArrayList<AppenderRef>()
        var logger_07: LoggerConfig = LoggerConfig("", "", list_07)
        @Expect(logger_07.getName(),"")
        @Expect(logger_07.getLevel(),"")
        @Expect(logger_07.getAppenderRefList().size,0)
    }

    // 验证: class LoggerConfiguration
    @TestCase
    public func log_test_032():Unit{
        var config_01: LoggerConfiguration = LoggerConfiguration()
        @Expect(config_01.getAppenders().size,0)
        @Expect(config_01.getRoot().getLevel(),"INFO")
        @Expect(config_01.getLogger().size,0)
    }

    // 验证: class LoggerConfiguration
    @TestCase
    public func log_test_033():Unit{
        var properties_02: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var property_02: AppenderProperty = AppenderProperty("name_02", "value_02")
        properties_02.append(property_02)
        var appenders_02 = ArrayList<AppenderConfig>()
        var appenderConfig_02: AppenderConfig = AppenderConfig("true", "config", "file", "pattern", properties_02)
        appenders_02.append(appenderConfig_02)

        var refList_02: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
        var ref_02: AppenderRef = AppenderRef("file")
        refList_02.append(ref_02)
        var root_02: RootLoggerConfig = RootLoggerConfig("INFO", refList_02)

        var logger_02: LoggerConfig = LoggerConfig("name", "info", refList_02)
        var loggerList_02 = ArrayList<LoggerConfig>()
        loggerList_02.append(logger_02)

        var config_02: LoggerConfiguration = LoggerConfiguration(appenders_02, root_02, loggerList_02)
        @Expect(config_02.getAppenders().size,1)
        @Expect(config_02.getRoot().getAppenderRefList().size,1)
        @Expect(config_02.getLogger().size,1)
    }

    // 验证: class LoggerConfiguration
    @TestCase
    public func log_test_034():Unit{
        var appenders_03 = ArrayList<AppenderConfig>()
        var refList_03: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
        var root_03: RootLoggerConfig = RootLoggerConfig("INFO", refList_03)
        var loggerList_03 = ArrayList<LoggerConfig>()
        var config_03: LoggerConfiguration = LoggerConfiguration(appenders_03, root_03, loggerList_03)
        @Expect(config_03.getAppenders().size,0)
        @Expect(config_03.getRoot().getAppenderRefList().size,0)
        @Expect(config_03.getLogger().size,0)
    }

    // 验证: class RootLoggerConfig
    @TestCase
    public func log_test_035():Unit{
        var root_01: RootLoggerConfig = RootLoggerConfig()
        @Expect(root_01.getLevel(),"")
        @Expect(root_01.getAppenderRefList().size,0)
    }

    // 验证: class RootLoggerConfig
    @TestCase
    public func log_test_036():Unit{
        var root_02: RootLoggerConfig = RootLoggerConfig()
        root_02.setLevel("info")
        var list_02 = ArrayList<AppenderRef>()
        var ref_02 = AppenderRef("file")
        list_02.append(ref_02)
        root_02.setAppenderRefList(list_02)
        @Expect(root_02.getLevel(),"info")
        @Expect(root_02.getAppenderRefList().size,1)
    }

    // 验证: class RootLoggerConfig
    @TestCase
    public func log_test_037():Unit{
        var list_03 = ArrayList<AppenderRef>()
        var ref_03 = AppenderRef("file")
        list_03.append(ref_03)
        var root_03: RootLoggerConfig = RootLoggerConfig("info", list_03)
        @Expect(root_03.getLevel(),"info")
        @Expect(root_03.getAppenderRefList().size,1)       
    }

    // 验证: class RootLoggerConfig
    @TestCase
    public func log_test_038():Unit{
        var list_04 = ArrayList<AppenderRef>()
        var root_04: RootLoggerConfig = RootLoggerConfig("info", list_04)
        @Expect(root_04.getLevel(),"info")
        @Expect(root_04.getAppenderRefList().size,0)
    }

    // 验证: class RootLoggerConfig
    @TestCase
    public func log_test_039():Unit{
        var list_05 = ArrayList<AppenderRef>()
        var ref_05 = AppenderRef("file")
        list_05.append(ref_05)
        var root_05: RootLoggerConfig = RootLoggerConfig("", list_05)
        @Expect(root_05.getLevel(),"")
        @Expect(root_05.getAppenderRefList().size,1)
    }

    // 验证: class RootLoggerConfig
    @TestCase
    public func log_test_040():Unit{
        var list_06 = ArrayList<AppenderRef>()
        var ref_06 = AppenderRef("file")
        list_06.append(ref_06)
        var root_06: RootLoggerConfig = RootLoggerConfig("中文", list_06)
        @Expect(root_06.getLevel(),"中文")
        @Expect(root_06.getAppenderRefList().size,1)
    }

    // 验证: class RootLoggerConfig
    @TestCase
    public func log_test_041():Unit{
        var list_07 = ArrayList<AppenderRef>()
        var ref_07 = AppenderRef("file")
        list_07.append(ref_07)
        var root_07: RootLoggerConfig = RootLoggerConfig("?><}{*&^&$", list_07)
        @Expect(root_07.getLevel(),"?><}{*&^&$")
        @Expect(root_07.getAppenderRefList().size,1)
    }
}