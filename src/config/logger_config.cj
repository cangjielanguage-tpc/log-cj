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
    public var name: String

    // 日志级别
    public var level: String

    // AppenderRef 集合
    public var appender: ArrayList<AppenderRef>

    public init(name: String, level: String, appender: ArrayList<AppenderRef>) {
        this.name = name
        this.level = level
        this.appender = appender
    }
}
