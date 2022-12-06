package config

from std import collection.ArrayList

/**
 * Configuration file object model,which is used to parse the appender configuration item.
    <appender enabled="true" name="file">
        <type>file</type>
        <pattern>[%D %T %m] [%L][%l] (%S) %M</pattern>
        <property name="filename">test.log</property>
    </appender>
 * */
public class AppenderConfig {
    // appender Enabled Status
    private var enabled: String

    // appender Name
    private var name: String

    // appender Type:file/console
    private var appenderType: String

    // Output Format:Mainly used to standardize the display style of output time
    private var pattern: String

    // Attribute List
    private var properties: ArrayList<AppenderProperty>

    /**
     * Initialize
     */
    public init() {
        this.enabled = ""
        this.name = ""
        this.appenderType = ""
        this.pattern = ""
        this.properties = ArrayList<AppenderProperty>()
    }

    /**
     * Initialization AppenderConfig
     *
     * @param enabled Enabled
     * @param name Name
     * @param appenderType appender type
     * @param pattern pattern
     * @param properties properties
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
