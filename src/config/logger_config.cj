package config

/**
   这个就是自定义的一个logger mmodel
   additivity 这个默认是true，即继承父类 root logger
   也就是说，你的这个日志也会在root的logger里面输出的，配置false，就是不继承，各走各的。
   appender-ref 也就是说这个logger的输出目的地是哪里，ref就是关联到上面声明的一个file，一个console
   <logger name="Sample">
     <level>info</level>
     <appender-ref ref="file" />
     <appender-ref ref="console" />
   </logger>
 * */
public class LoggerConfig {
    // logger 名称
    private var name: String

    // 日志级别
    private var level: String

    // AppenderRef 集合
    private var appenderRefList: ArrayList<AppenderRef>

    public init() {
        this.name = ""
        this.level = ""
        this.appenderRefList = ArrayList<AppenderRef>()
    }

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
