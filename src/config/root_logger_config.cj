package config

from std import collection.ArrayList

/**
 * Configuration file object model,Used to parse the root configuration.
    <root>
        <level>info</level>
        <appender-ref ref="console" />
        <appender-ref ref="logstash" />
        <appender-ref ref="file" />
    </root>
 */
public class RootLoggerConfig {
    // log level
    private var level: String

    // root log  configuration AppenderRef
    private var appenderRefList: ArrayList<AppenderRef>

    public init() {
        this.level = ""
        this.appenderRefList = ArrayList<AppenderRef>()
    }

    /**
     * Initialization appenderRefList 
     *
     * @param level level
     * @param appenderRefList appenderRef list
     */
    public init(level: String, appenderRefList: ArrayList<AppenderRef>) {
        this.level = level
        this.appenderRefList = appenderRefList
    }

    public func getLevel() {
        return this.level
    }

    public func setLevel(level: String) {
        this.level = level
    }

    public func getAppenderRefList() {
        return this.appenderRefList
    }

    public func setAppenderRefList(appenderRefList: ArrayList<AppenderRef>) {
        this.appenderRefList = appenderRefList
    }
}
