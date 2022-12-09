package config

/**
 * This is a custom logger model
     additivity defaulty is true,Inherit parent class root logger
     This log is generated in the logger of the root user,Configuration false,Do not inherit,Go your own way.
     appender-ref what is the output destination of this logger,ref is associated with the above declaration,one file,one console
     <logger name="Sample">
       <level>info</level>
       <appender-ref ref="file" />
       <appender-ref ref="console" />
     </logger>
 */
public class LoggerConfig {
    // logger name
    private var name: String

    // log level
    private var level: String

    // AppenderRef list
    private var appenderRefList: ArrayList<AppenderRef>

    public init() {
        this.name = ""
        this.level = ""
        this.appenderRefList = ArrayList<AppenderRef>()
    }

    /**
     * Initialization AppenderRefList
     *
     * @param name name
     * @param level level
     * @param appenderRefList appenderRef list
     */
    public init(name: String, level: String, appenderRefList: ArrayList<AppenderRef>) {
        this.name = name
        this.level = level
        this.appenderRefList = appenderRefList
    }

    public func getName() {
        return this.name
    }

    public func setName(name: String) {
        this.name = name
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
