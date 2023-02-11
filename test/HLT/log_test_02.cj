//3rd_party_lib:log4cj2/build/log4cj

package test

from std import unittest.*
from std import unittest.testmacro.*
from log4cj import appender.*
from log4cj import config.*
from log4cj import logger.*
from log4cj import utils.*
from std import time.*
from std import collection.ArrayList

/**
 * config类的验证
 */
@Test
public class LogTestB {
    var flag = false

    // 验证: class AppenderConfig 
    // 空创建后获取值
    @TestCase
    public func log_test_008():Unit{
        var appenderConfig_01: AppenderConfig = AppenderConfig()
        @Expect(appenderConfig_01.getEnabled(),"")
        @Expect(appenderConfig_01.getName(),"")
        @Expect(appenderConfig_01.getAppenderType(),"")
        @Expect(appenderConfig_01.getPattern(),"")
        @Expect(appenderConfig_01.getProperties().size,0)
    }

    // 验证: class AppenderConfig 
    // 空创建后设置正常值
    @TestCase
    public func log_test_009():Unit{
        var appenderConfig_02: AppenderConfig = AppenderConfig()
        appenderConfig_02.setEnabled("true")
        appenderConfig_02.setName("appenderConfig_02")
        appenderConfig_02.setAppenderType("file")
        appenderConfig_02.setPattern("pattern")
        var properties_02: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var property_02: AppenderProperty = AppenderProperty("name_02", "value_02")
        properties_02.append(property_02)
        appenderConfig_02.setProperties(properties_02)
        @Expect(appenderConfig_02.getEnabled(),"true")
        @Expect(appenderConfig_02.getName(),"appenderConfig_02")
        @Expect(appenderConfig_02.getAppenderType(),"file")
        @Expect(appenderConfig_02.getPattern(),"pattern")
        @Expect(appenderConfig_02.getProperties().size,1)
    }

    // 验证: class AppenderConfig 
    // 带参创建
    @TestCase
    public func log_test_010():Unit{
        var properties_03: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var property_03: AppenderProperty = AppenderProperty("name_03", "value_03")
        properties_03.append(property_03)
        var appenderConfig_03: AppenderConfig = AppenderConfig("true", "config", "file", "pattern", properties_03)
        @Expect(appenderConfig_03.getEnabled(),"true")
        @Expect(appenderConfig_03.getName(),"config")
        @Expect(appenderConfig_03.getAppenderType(),"file")
        @Expect(appenderConfig_03.getPattern(),"pattern")
        @Expect(appenderConfig_03.getProperties().size,1)
    }

    // 验证: class AppenderConfig 
    // 空参创建后设置空参
    @TestCase
    public func log_test_011():Unit{
        var appenderConfig_04: AppenderConfig = AppenderConfig()
        appenderConfig_04.setEnabled("")
        appenderConfig_04.setName("")
        appenderConfig_04.setAppenderType("")
        appenderConfig_04.setPattern("")
        var properties_04: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var property_04: AppenderProperty = AppenderProperty("name_04", "value_04")
        properties_04.append(property_04)
        appenderConfig_04.setProperties(properties_04)
        @Expect(appenderConfig_04.getEnabled(),"")
        @Expect(appenderConfig_04.getName(),"")
        @Expect(appenderConfig_04.getAppenderType(),"")
        @Expect(appenderConfig_04.getPattern(),"")
        @Expect(appenderConfig_04.getProperties().size,1)
    }

    // 验证: class AppenderConfig 
    // 中文/带符号的参数设置
    @TestCase
    public func log_test_012():Unit{
        var appenderConfig_05: AppenderConfig = AppenderConfig()
        appenderConfig_05.setEnabled("^&%%")
        appenderConfig_05.setName("中文中文")
        appenderConfig_05.setAppenderType("&^@%>")
        appenderConfig_05.setPattern("+)}:<!#")
        var properties_05: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        var property_05: AppenderProperty = AppenderProperty("name_05", "value_05")
        properties_05.append(property_05)
        appenderConfig_05.setProperties(properties_05)
        @Expect(appenderConfig_05.getEnabled(),"^&%%")
        @Expect(appenderConfig_05.getName(),"中文中文")
        @Expect(appenderConfig_05.getAppenderType(),"&^@%>")
        @Expect(appenderConfig_05.getPattern(),"+)}:<!#")
        @Expect(appenderConfig_05.getProperties().size,1)
    }

    // 验证: class AppenderConfig 
    // 空参创建后设置列表参数为空
    @TestCase
    public func log_test_013():Unit{
        var appenderConfig_06: AppenderConfig = AppenderConfig()
        appenderConfig_06.setEnabled("false")
        appenderConfig_06.setName("appenderConfig_06")
        appenderConfig_06.setAppenderType("file")
        appenderConfig_06.setPattern("pattern")
        var properties_06: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
        appenderConfig_06.setProperties(properties_06)
        @Expect(appenderConfig_06.getEnabled(),"false")
        @Expect(appenderConfig_06.getName(),"appenderConfig_06")
        @Expect(appenderConfig_06.getAppenderType(),"file")
        @Expect(appenderConfig_06.getPattern(),"pattern")
        @Expect(appenderConfig_06.getProperties().size,0)
    }

    // 验证: class AppenderProperty
    @TestCase
    public func log_test_014():Unit{
        var property_01: AppenderProperty = AppenderProperty()
        @Expect(property_01.getName(),"")
        @Expect(property_01.getValue(),"")
    }

    // 验证: class AppenderProperty
    @TestCase
    public func log_test_015():Unit{
        var property_02: AppenderProperty = AppenderProperty()
        property_02.setName("name_02")
        property_02.setValue("value_02")
        @Expect(property_02.getName(),"name_02")
        @Expect(property_02.getValue(),"value_02")
    }

    // 验证: class AppenderProperty
    @TestCase
    public func log_test_016():Unit{
        var property_03: AppenderProperty = AppenderProperty("name_03", "value_03")
        @Expect(property_03.getName(),"name_03")
        @Expect(property_03.getValue(),"value_03")
    }

    // 验证: class AppenderProperty
    @TestCase
    public func log_test_017():Unit{
        var property_04: AppenderProperty = AppenderProperty()
        property_04.setName("中文中文")
        property_04.setValue("中文中文")
        @Expect(property_04.getName(),"中文中文")
        @Expect(property_04.getValue(),"中文中文")
    }

    // 验证: class AppenderProperty
    @TestCase
    public func log_test_018():Unit{
        var property_05: AppenderProperty = AppenderProperty()
        property_05.setName("￥#……%&……（&:{}》《")
        property_05.setValue("{}*(&##:>?)}")
        @Expect(property_05.getName(),"￥#……%&……（&:{}》《")
        @Expect(property_05.getValue(),"{}*(&##:>?)}")
    }

    // 验证: class AppenderProperty
    @TestCase
    public func log_test_019():Unit{
        var property_06: AppenderProperty = AppenderProperty()
        property_06.setName("")
        property_06.setValue("")
        @Expect(property_06.getName(),"")
        @Expect(property_06.getValue(),"")
    }

    // 验证: class AppenderRef
    @TestCase
    public func log_test_020():Unit{
        var ref_01: AppenderRef = AppenderRef()
        @Expect(ref_01.getRef(),"")
    }

    // 验证: class AppenderRef
    @TestCase
    public func log_test_021():Unit{
        var ref_02: AppenderRef = AppenderRef("file")
        @Expect(ref_02.getRef(),"file")
    }

    // 验证: class AppenderRef
    @TestCase
    public func log_test_022():Unit{
        var ref_03: AppenderRef = AppenderRef("")
        @Expect(ref_03.getRef(),"")
    }

    // 验证: class AppenderRef
    @TestCase
    public func log_test_023():Unit{
        var ref_04: AppenderRef = AppenderRef("中文中文")
        @Expect(ref_04.getRef(),"中文中文")
    }

    // 验证: class AppenderRef
    @TestCase
    public func log_test_024():Unit{
        var ref_05: AppenderRef = AppenderRef("{}*(&##:>?)}")
        @Expect(ref_05.getRef(),"{}*(&##:>?)}")
    }
}