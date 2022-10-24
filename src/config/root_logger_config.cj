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
    public var level: String

    // root 日志配置 AppenderRef
    public var appender: ArrayList<AppenderRef>

    public init(level: String, appender: ArrayList<AppenderRef>) {
        this.level = level
        this.appender = appender
    }
}
