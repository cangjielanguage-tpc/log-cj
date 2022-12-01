package config

from std import collection.ArrayList

/**
   配置文件对象 model ，用于解析 Appender 配置项。
     <appender enabled="true" name="file">
       <type>file</type>
       <pattern>[%D %T %m] [%L][%l] (%S) %M</pattern>
       <property name="filename">test.log</property>
     </appender>
 * */
public class AppenderConfig {
    // appender 使能状态
    private var enabled: String

    // appender 名称
    private var name: String

    // appender 类型：file/console
    private var appenderType: String

    // 输出格式 主要用于规范输出时间显示样式
    private var pattern: String

    // 属性列表
    private var properties: ArrayList<AppenderProperty>

    public init() {
        this.enabled = ""
        this.name = ""
        this.appenderType = ""
        this.pattern = ""
        this.properties = ArrayList<AppenderProperty>()
    }

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
