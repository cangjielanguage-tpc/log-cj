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
    public var enabled: String

    // appender 名称
    public var name: String

    // appender 类型：file/console
    public var appenderType: String

    // 输出格式 主要用于规范输出时间显示样式
    public var pattern: String

    // 属性列表
    public var property: ArrayList<AppenderProperty>

    public init() {
        this.enabled = ""
        this.name = ""
        this.appenderType = ""
        this.pattern = ""
        this.property = ArrayList<AppenderProperty>()
    }

    public init(
        enabled: String,
        name: String,
        appenderType: String,
        pattern: String,
        property: ArrayList<AppenderProperty>
    ) {
        this.enabled = enabled
        this.name = name
        this.appenderType = appenderType
        this.pattern = pattern
        this.property = property
    }
}
