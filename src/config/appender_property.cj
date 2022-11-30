package config

/**
   配置文件对象 model ，用于解析 Appender 属性值。例如下面所示 property 字段
     <appender enabled="true" name="file">
       <type>file</type>
       <pattern>[%D %T %m] [%L][%l] (%S) %M</pattern>
       <property name="filename">test.log</property>
     </appender>
 * */
public class AppenderProperty {
    // 属性名称
    private var name: String = ""

    // 属性对应值
    private var value: String = ""

    public init(name: String, value: String) {
        this.name = name
        this.value = value
    }

    public init() {}

    public func getName() {
        return this.name
    }

    public func setName(name: String) {
        this.name = name
    }

    public func getValue() {
        return this.value
    }

    public func setValue(value: String) {
        this.value = value
    }
}
