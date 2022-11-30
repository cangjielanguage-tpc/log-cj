package config

/**
   配置文件对象 model ，用于解析 AppenderRef。
     <root>
       <level>info</level>
       <appender-ref ref="console" />
       <appender-ref ref="logstash" />
       <appender-ref ref="file" />
     </root>
 * */
public class AppenderRef {
    // appender-ref 值
    private var ref: String = ""

    public init() {}

    public init(ref: String) {
        this.ref = ref
    }

    public func getRef() {
        return this.ref
    }
}
