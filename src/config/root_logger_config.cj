package config

from std import collection.ArrayList

/**
   配置文件对象 model ，用于解析 root 配置。
     <root>
       <level>info</level>
       <appender-ref ref="console" />
       <appender-ref ref="logstash" />
       <appender-ref ref="file" />
     </root>
 * */
public class RootLoggerConfig {
    // 日志级别
    private var level: String

    // root 日志配置 AppenderRef
    private var appenderRefList: ArrayList<AppenderRef>

    public init() {
        this.level = ""
        this.appenderRefList = ArrayList<AppenderRef>()
    }

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
