package config

/**
 * Configuration file object model,which is used to parse the appender attribute value.The following is an example of the property field.
    <appender enabled="true" name="file">
        <type>file</type>
        <pattern>[%D %T %m] [%L][%l] (%S) %M</pattern>
        <property name="filename">test.log</property>
    </appender>
 */
public class AppenderProperty {
    // Attribute Name
    private var name: String = ""

    // Attribute Value
    private var value: String = ""

    /**
     * Initialization
     *
     * @param name Name
     * @param value value
     */
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
