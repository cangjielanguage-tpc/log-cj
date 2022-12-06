package config

/**
 * Configuration file object model,which is used parse AppenderRef.
    <root>
        <level>info</level>
        <appender-ref ref="console" />
        <appender-ref ref="logstash" />
        <appender-ref ref="file" />
    </root>
 * */
public class AppenderRef {
    // appender-ref value
    private var ref: String = ""

    public init() {}

    public init(ref: String) {
        this.ref = ref
    }

    public func getRef() {
        return this.ref
    }
}
