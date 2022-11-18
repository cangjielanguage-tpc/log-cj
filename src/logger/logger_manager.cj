package logger

from std import collection.*
from std import sync.*
from std import fs.*
from encoding import xml.*
import appender.*
import config.*
import utils.*

public let Logger_Appender_Factory = LoggerAppenderFactory()
public let Logger_Manager = LoggerManager("./log4cj2.xml")

/**
 * Log 管理类
 * */
public class LoggerManager {
    public var laf: LoggerAppenderFactory = LoggerAppenderFactory()
    public var rootLogger: LoggerAppenderReference = LoggerAppenderReference()
    public var loggerMap: HashMap<String, LoggerAppenderReference> = HashMap<String, LoggerAppenderReference>()

    public init() {}

    public init(xmlPath: String) {
        initLoggerManager(xmlPath)
    }

    /*
     * 获取 logger 对象
     * 参数 name - logger 名称
     */
    public func getLogger(name: String): Logger {
        var logger = Logger(name)
        return logger
    }

    /**
     * 初始化默认设置
     * */
    private func initWithDefaultConfig(xmlPath: String) {
        var lc = loadXML(xmlPath)
        initWithConfig(lc)
    }

    /*
     * 根据 LoggerConfiguration 对象信息，初始化 LoggerManager
     * 参数 configuration - 通过配置信息解析成的 LoggerConfiguration 对象
     */
    private func initWithConfig(configuration: LoggerConfiguration) {
        this.laf = Logger_Appender_Factory.new()
        this.loggerMap = HashMap<String, LoggerAppenderReference>()
        this.rootLogger = LoggerAppenderReference(DEFAULT_LOG_LEVEL, ArrayList<LoggerAppender>())

        let enabledMap = HashMap<String, Bool>()

        if (configuration.appender.size > 0) {
            for (appender in configuration.appender) {
                enabledMap[appender.name.toAsciiLower()] = appender.enabled.toAsciiLower().trimAscii() != "false"
                if (enabledMap[appender.name.toAsciiLower()]) {
                    this.laf.registerLoggerAppender(
                        appender.name,
                        appender.appenderType,
                        appender.pattern,
                        appender.property
                    )
                }
            }
        }

        // init root
        let rc = configuration.root

        this.rootLogger.level = LogLevel.getLevelByString(rc.level)
        this.rootLogger.appender = ArrayList<LoggerAppender>()

        if (rc.appender.size > 0) {
            for (appenderRef in rc.appender) {
                if (enabledMap.contains(appenderRef.ref.toAsciiLower()) && enabledMap[appenderRef.ref.toAsciiLower()]) {
                    let ap = this.laf.getAppenderRefByName(appenderRef.ref)
                    this.rootLogger.appender.append(ap)
                }
            }
        }

        // init logger
        if (configuration.logger.size > 0) {
            for (logger in configuration.logger) {
                let oneLogger = LoggerAppenderReference(
                    LogLevel.getLevelByString(logger.level),
                    ArrayList<LoggerAppender>()
                )
                for (appenderRef in logger.appender) {
                    if (enabledMap.contains(appenderRef.ref.toAsciiLower()) && enabledMap[appenderRef.ref.toAsciiLower()]) {
                        let ap = this.laf.getAppenderRefByName(appenderRef.ref)
                        oneLogger.appender.append(ap)
                    }
                }
                if (oneLogger.appender.size > 0) {
                    this.loggerMap[logger.name] = oneLogger
                }
            }
        }
    }

    /*
     * 根据 xml 配置信息，初始化 LoggerManager
     * 参数 xmlFile - xml配置文件名
     */
    public func initWithXML(xmlFile: String) {
        let lc = loadXMLConfigurationProperties(xmlFile)
        initWithConfig(lc)
    }

    private func initLoggerManager(xmlPath: String) {
        // 注册系统自带的 LoggerAppender()
        Logger_Appender_Factory.registryType("console", ConsoleLoggerAppender())
        Logger_Appender_Factory.registryType("file", FileLoggerAppender())

        // 初始化日志配置文件
        initWithDefaultConfig(xmlPath)
    }

    /**
       该函数将xml文件解析成LoggerConfiguration对象
     * */
    private func loadXML(xmlPath: String) {
        var filePath: Path = Path(xmlPath)
        var isFileExist: Bool = File.exists(filePath)

        if (xmlPath.size == 0 || !isFileExist) {
            return loadDefaultConfiguration()
        }

        //获取appender,logger,root等元素
        var allElements: ArrayList<XmlElement> = getXmlBasicProperties(xmlPath)

        //获取appender配置
        var appenderList: ArrayList<AppenderConfig> = getAppenderConfiguration(allElements)

        //获取logger配置
        var loggerList: ArrayList<LoggerConfig> = getLoggerConfiguration(allElements)

        //获取root配置
        var root: RootLoggerConfig = getRootConfiguration(allElements)

        return LoggerConfiguration(appenderList, root, loggerList)
    }

    public func loadDefaultConfiguration() {
        let content = """
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appender enabled="true" name="console">
        <type>console</type>
        <pattern>[%D %T %m] [%L] [%l] (%S) %M</pattern>
    </appender>
    <appender enabled="true" name="file">
        <type>file</type>
        <pattern>[%D %T %m] [%L] [%l] (%S) %M</pattern>
        <property name="filename">root.log</property>
        <property name="rotate">true</property>
        <property name="maxsize">230</property>
        <property name="daily">false</property>
    </appender>
    <root>
        <level>info</level>
        <appender-ref ref="console" />
        <appender-ref ref="file" />
    </root>
</configuration>
"""
        var x: XmlParser = XmlParser()
        var elements: Option<XmlElement> = Option<XmlElement>.None
        try {
            elements = x.parse(content)
        } catch (e: XmlException) {
            throw XmlException("parse xml occur exception ${e.message}!")
        }
        var xmlElements: XmlElement = elements.getOrThrow()
        var appenderList: ArrayList<AppenderConfig> = getAppenderConfiguration(xmlElements.childrenElements)
        var loggerList: ArrayList<LoggerConfig> = getLoggerConfiguration(xmlElements.childrenElements)
        var root: RootLoggerConfig = getRootConfiguration(xmlElements.childrenElements)

        return LoggerConfiguration(appenderList, root, loggerList)
    }

    //获取appender,logger,root元素
    private func getXmlBasicProperties(xmlPath: String): ArrayList<XmlElement> {
        var filePath: Path = Path(xmlPath)
        var isFileExist: Bool = File.exists(filePath)

        //读取文件，读成String
        var allBytes: Array<Byte> = File.readFrom(filePath)
        if (allBytes.size == 0) {
            throw FSException("xml file is empty!")
        }

        var content: String = String.fromUtf8(allBytes)

        //解析文件内容，必须保证文件格式正确，否则编译失败
        var x: XmlParser = XmlParser()
        var elements: Option<XmlElement> = Option<XmlElement>.None
        try {
            elements = x.parse(content)
        } catch (e: XmlException) {
            throw XmlException("parse xml occur exception ${e.message}!")
        }
        var xmlElements: XmlElement = elements.getOrThrow()

        //获取appender,logger,root元素
        return xmlElements.childrenElements
    }

    //获取file appender元素配置
    private func getAppenderConfiguration(allElements: ArrayList<XmlElement>): ArrayList<AppenderConfig> {
        var configList: ArrayList<AppenderConfig> = ArrayList<AppenderConfig>()
        var propertyList: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()

        for (element in allElements where element.name.equals("appender")) {
            let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
            let allAttrs: ArrayList<XmlAttr> = element.attributes
            var appender: AppenderConfig = AppenderConfig()
            for (attr in allAttrs) {
                if (attr.name.equals("enabled")) {
                    appender.enabled = attr.content
                }
                if (attr.name.equals("name")) {
                    appender.name = attr.content
                }
            }
            for (childrenElement in allChildrenElements) {
                if (childrenElement.name.equals("type")) {
                    appender.appenderType = childrenElement.content
                }
                if (childrenElement.name.equals("pattern")) {
                    appender.pattern = childrenElement.content
                }
                if (allAttrs.toString().contains("name=\"file\"") && childrenElement.name.equals("property") &&
                    childrenElement.attributes.toString().contains("filename")) {
                    var property: AppenderProperty = AppenderProperty()
                    property.name = "filename"
                    property.value = childrenElement.content
                    propertyList.append(property)
                    appender.property = propertyList
                }
                if (allAttrs.toString().contains("name=\"file\"") && childrenElement.name.equals("property") &&
                    childrenElement.attributes.toString().contains("maxsize")) {
                    var property: AppenderProperty = AppenderProperty()
                    property.name = "maxSize"
                    property.value = childrenElement.content
                    propertyList.append(property)
                    appender.property = propertyList
                }
                if (allAttrs.toString().contains("name=\"file\"") && childrenElement.name.equals("property") &&
                    childrenElement.attributes.toString().contains("rotate")) {
                    var property: AppenderProperty = AppenderProperty()
                    property.name = "rotate"
                    property.value = childrenElement.content
                    propertyList.append(property)
                    appender.property = propertyList
                }
                if (allAttrs.toString().contains("name=\"file\"") && childrenElement.name.equals("property") &&
                    childrenElement.attributes.toString().contains("daily")) {
                    var property: AppenderProperty = AppenderProperty()
                    property.name = "daily"
                    property.value = childrenElement.content
                    propertyList.append(property)
                    appender.property = propertyList
                }
            }
            configList.append(appender)
        }
        return configList
    }

    //获取logger元素配置
    private func getLoggerConfiguration(allElements: ArrayList<XmlElement>): ArrayList<LoggerConfig> {
        var loggerList: ArrayList<LoggerConfig> = ArrayList<LoggerConfig>()
        var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
        for (element in allElements where element.name.equals("logger")) {
            let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
            let allAttrs: ArrayList<XmlAttr> = element.attributes
            var logger: LoggerConfig = LoggerConfig()
            for (attr in allAttrs) {
                if (attr.name.equals("name")) {
                    logger.name = attr.content
                }
            }
            for (childrenElement in allChildrenElements) {
                if (childrenElement.name.equals("level")) {
                    logger.level = childrenElement.content
                }
                if (allAttrs.toString().contains("name=\"Demo\"")) {
                    let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                    for (childrenAttr in allChildrenAttrs where allChildrenAttrs.size != 0) {
                        var appenderRef: AppenderRef = AppenderRef()
                        if (childrenAttr.name.equals("ref")) {
                            appenderRef.ref = childrenAttr.content
                        }
                        refList.append(appenderRef)
                        logger.appender = refList
                    }
                }
            }
            loggerList.append(logger)
        }

        //refList去重
        return loggerList
    }

    //获取root元素配置
    private func getRootConfiguration(allElements: ArrayList<XmlElement>): RootLoggerConfig {
        var root: RootLoggerConfig = RootLoggerConfig()
        var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
        for (element in allElements where element.name.equals("root")) {
            let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
            for (childrenElement in allChildrenElements) {
                if (childrenElement.name.equals("level")) {
                    root.level = childrenElement.content
                }

                let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                for (childrenAttr in allChildrenAttrs where allChildrenAttrs.size != 0) {
                    var appenderRef: AppenderRef = AppenderRef()
                    if (childrenAttr.name.equals("ref")) {
                        appenderRef.ref = childrenAttr.content
                    }
                    refList.append(appenderRef)
                    root.appender = refList
                }
            }
        }
        return root
    }

    // TODO 临时测试用，待具体实现
    private func loadXMLConfigurationProperties(filename: String) {
        let xc = LoggerConfiguration()
        return xc
    }
}
