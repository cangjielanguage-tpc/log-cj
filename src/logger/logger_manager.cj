/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 */

/**
 * @file
 * This file defines LoggerManager class.
 */

package logger

from encoding import xml.*
from std import collection.*
from std import fs.*
from std import sync.*
import appender.*
import config.*
import utils.*

public let Logger_Appender_Factory = LoggerAppenderFactory()
public let Logger_Manager = LoggerManager("./src/resources/log4cj.xml")

/**
 * Log management class, load and parse log file to get a specific configuration item.
 */
public class LoggerManager {
    // Logger appender factory, mainly register logger appender.
    private var loggerAppenderFactory: LoggerAppenderFactory = LoggerAppenderFactory()

    // Root configuation variable.
    private var rootLogger: LoggerAppenderReference = LoggerAppenderReference()

    // Logger configuration map, mainly stores configurtion items related to logger configuration.
    private var loggerMap: HashMap<String, LoggerAppenderReference> = HashMap<String, LoggerAppenderReference>()

    /**
     * No-parameter constructor.
     */
    public init() {}

    /**
     * Constructor, load and parse xml file.
     *
     * @param xmlPath log file path.
     */
    public init(xmlPath: String) {
        initLoggerManager(xmlPath)
    }

    public func getLoggerAppenderFactory() {
        return this.loggerAppenderFactory
    }

    public func getRootLogger() {
        return this.rootLogger
    }

    public func getLoggerMap() {
        return this.loggerMap
    }

    /**
     * Get the specific logger based on the logger name.
     *
     * @param name logger name.
     * @return logger object.
     */
    public func getLogger(name: String): Logger {
        var logger = Logger(name)
        return logger
    }

    /**
     * Initialize default configurations of log file.
     *
     * @param xmlPath log file path.
     */
    private func initWithDefaultConfig(xmlPath: String) {
        var loggerConfiguration: LoggerConfiguration = loadXML(xmlPath)
        if (loggerConfiguration.getAppenders().size == 0) {
            println("can not find any appender!")
            return
        }
        initWithConfig(loggerConfiguration)
    }

    /**
     * Initialize the log configurtion obtained by loading the xml file.
     *
     * @param configuration log configuration obtained by loading the xml file.
     */
    private func initWithConfig(configuration: LoggerConfiguration) {
        this.loggerAppenderFactory = Logger_Appender_Factory.new()
        this.loggerMap = HashMap<String, LoggerAppenderReference>()
        this.rootLogger = LoggerAppenderReference(DEFAULT_LOG_LEVEL, ArrayList<LoggerAppender>())

        let enabledMap = HashMap<String, Bool>()

        // Register appenders.
        if (configuration.getAppenders().size > 0) {
            for (appender in configuration.getAppenders()) {
                enabledMap[appender.getName().toAsciiLower()] = appender.getEnabled().toAsciiLower().trimAscii() !=
                    "false"
                if (enabledMap[appender.getName().toAsciiLower()]) {
                    this.loggerAppenderFactory.registerLoggerAppender(
                        appender.getName(),
                        appender.getAppenderType(),
                        appender.getPattern(),
                        appender.getProperties()
                    )
                }
            }
        }

        // Initialize root configuration.
        let rootConfig = configuration.getRoot()

        this.rootLogger.setLevel(LogLevel.getLevelByString(rootConfig.getLevel()))

        if (rootConfig.getAppenderRefList().size > 0) {
            for (appenderRef in rootConfig.getAppenderRefList()) {
                if (enabledMap.contains(appenderRef.getRef().toAsciiLower()) && enabledMap[appenderRef.getRef().
                    toAsciiLower()]) {
                    let ap = this.loggerAppenderFactory.getAppenderByName(appenderRef.getRef().toAsciiLower())
                    this.rootLogger.getAppenderList().append(ap)
                }
            }
        }

        // Initialize logger configuration.
        if (configuration.getLogger().size > 0) {
            for (logger in configuration.getLogger()) {
                let oneLogger = LoggerAppenderReference(
                    LogLevel.getLevelByString(logger.getLevel()),
                    ArrayList<LoggerAppender>()
                )
                for (appenderRef in logger.getAppenderRefList()) {
                    if (enabledMap.contains(appenderRef.getRef().toAsciiLower()) && enabledMap[appenderRef.getRef().
                        toAsciiLower()]) {
                        let oneAppender = this.loggerAppenderFactory.getAppenderByName(
                            appenderRef.getRef().toAsciiLower())
                        oneLogger.getAppenderList().append(oneAppender)
                    }
                }
                if (oneLogger.getAppenderList().size > 0) {
                    this.loggerMap[logger.getName()] = oneLogger
                }
            }
        }
    }

    private func initLoggerManager(xmlPath: String) {
        // Register the LoggerAppender provided by the system.
        Logger_Appender_Factory.registryType("console", ConsoleLoggerAppender())
        Logger_Appender_Factory.registryType("file", FileLoggerAppender())

        // Initialize the log configuration file.
        initWithDefaultConfig(xmlPath)
    }

    /**
     * This function is used to parse the XML file into the LoggerConfiguration object.
     *
     * @param xmlPath log file path.
     * @return logger configuration object.
     */
    private func loadXML(xmlPath: String) {
        var filePath: Path = Path(xmlPath)
        var isFileExist: Bool = File.exists(filePath)
        if (xmlPath.size == 0 || !isFileExist) {
            return loadDefaultConfiguration()
        }

        // Get elements such as appender, logger, root and so on.
        var allElements: ArrayList<XmlElement> = getXmlBasicProperties(xmlPath)
        if (allElements.size == 0) {
            println("can not find any element in xml file!")
            return LoggerConfiguration()
        }

        // Get appender configuration.
        var appenderList: ArrayList<AppenderConfig> = getAppenderConfiguration(allElements)
        if (appenderList.size == 0) {
            println("can not find any appender in xml file!")
            return LoggerConfiguration()
        }

        // Get logger configuration.
        var loggerList: ArrayList<LoggerConfig> = getLoggerConfiguration(allElements)
        if (loggerList.size == 0) {
            println("can not find any logger in xml file!")
        }

        // Get root configuration.
        var root: RootLoggerConfig = getRootConfiguration(allElements)
        if (root.getLevel().size == 0 || root.getAppenderRefList().size == 0) {
            println("root configuration has mistakes!")
            return LoggerConfiguration()
        }

        return LoggerConfiguration(appenderList, root, loggerList)
    }

    /**
     * Parse the built-in log configuration.
     *
     * @return logger configuration object.
     */
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
    <property name="maxsize">20M</property>
    <property name="daily">false</property>
  </appender>
  <root>
    <level>info</level>
    <appender-ref ref="console"/>
    <appender-ref ref="file"/>
  </root>
</configuration>
        """
        var x: XmlParser = XmlParser()
        var elements: Option<XmlElement> = x.parse(content)
        var xmlElements: XmlElement = elements.getOrThrow()
        var appenderList: ArrayList<AppenderConfig> = getAppenderConfiguration(xmlElements.childrenElements)
        var loggerList: ArrayList<LoggerConfig> = getLoggerConfiguration(xmlElements.childrenElements)
        var root: RootLoggerConfig = getRootConfiguration(xmlElements.childrenElements)

        return LoggerConfiguration(appenderList, root, loggerList)
    }

    /**
     * Get configuration items by parsing xml file.
     *
     * @param xmlPath log file path.
     * @return configuration element list.
     */
    private func getXmlBasicProperties(xmlPath: String): ArrayList<XmlElement> {
        var filePath: Path = Path(xmlPath)

        // Read a file as a string.
        var allBytes: Array<Byte> = File.readFrom(filePath)
        if (allBytes.size == 0) {
            println("xml file is empty!")
            return ArrayList<XmlElement>()
        }

        var content: String = String.fromUtf8(allBytes)

        // Parse the file content, Ensure that the file format is correct. Otherwise, the compilation fails.
        var x: XmlParser = XmlParser()
        var elements: Option<XmlElement> = Option<XmlElement>.None
        try {
            elements = x.parse(content)
        } catch (e: XmlException) {
            println("parse xml occur exception ${e.message}!")
            return ArrayList<XmlElement>()
        }
        try {
            elements.getOrThrow()
        } catch (e: NoneValueException) {
            println("get xml element occur exception ${e.message}!")
            return ArrayList<XmlElement>()
        }
        var xmlElements: XmlElement = elements.getOrThrow()
        var childrenElements: ArrayList<XmlElement> = xmlElements.childrenElements
        if (childrenElements.size == 0) {
            println("xml children element is empty!")
            return ArrayList<XmlElement>()
        }
        return childrenElements
    }

    /**
     * Get appender configuarations.
     *
     * @param allElements basic configuration elements by parsing xml file.
     * @return appender configuration list.
     */
    private func getAppenderConfiguration(allElements: ArrayList<XmlElement>): ArrayList<AppenderConfig> {
        var configList: ArrayList<AppenderConfig> = ArrayList<AppenderConfig>()

        for (element in allElements where element.name.toAsciiLower().equals("appender")) {
            let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
            let allAttrs: ArrayList<XmlAttr> = element.attributes
            var appender: AppenderConfig = AppenderConfig()
            var propertyList: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
            for (attr in allAttrs) {
                if (attr.name.toAsciiLower().equals("enabled")) {
                    appender.setEnabled(attr.content)
                }
                if (attr.name.toAsciiLower().equals("name")) {
                    appender.setName(attr.content)
                }
            }
            for (childrenElement in allChildrenElements) {
                if (childrenElement.name.toAsciiLower().equals("type")) {
                    appender.setAppenderType(childrenElement.content)
                }
                if (childrenElement.name.toAsciiLower().equals("pattern")) {
                    appender.setPattern(childrenElement.content)
                } else {
                    let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                    for (childrenAttr in allChildrenAttrs where allChildrenAttrs.size != 0) {
                        var property: AppenderProperty = AppenderProperty(childrenAttr.content, childrenElement.content)
                        propertyList.append(property)
                    }
                    appender.setProperties(propertyList)
                }
            }
            configList.append(appender)
        }
        return configList
    }

    /**
     * Get logger configuarations.
     *
     * @param allElements basic configuration elements by parsing xml file.
     * @return logger configuration list.
     */
    private func getLoggerConfiguration(allElements: ArrayList<XmlElement>): ArrayList<LoggerConfig> {
        var loggerList: ArrayList<LoggerConfig> = ArrayList<LoggerConfig>()

        for (element in allElements where element.name.equals("logger")) {
            let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
            let allAttrs: ArrayList<XmlAttr> = element.attributes
            var logger: LoggerConfig = LoggerConfig()
            var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
            for (attr in allAttrs) {
                if (attr.name.toAsciiLower().equals("name")) {
                    logger.setName(attr.content)
                }
            }
            for (childrenElement in allChildrenElements) {
                if (childrenElement.name.toAsciiLower().equals("level")) {
                    logger.setLevel(childrenElement.content)
                } else {
                    let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                    for (childrenAttr in allChildrenAttrs where allChildrenAttrs.size != 0) {
                        var appenderRef: AppenderRef = AppenderRef()
                        if (childrenAttr.name.toAsciiLower().equals("ref")) {
                            refList.append(AppenderRef(childrenAttr.content))
                        }
                    }
                    logger.setAppenderRefList(refList)
                }
            }
            loggerList.append(logger)
        }

        return loggerList
    }

    /**
     * Get root configuarations.
     *
     * @param allElements basic configuration elements by parsing xml file.
     * @return root configuration list.
     */
    private func getRootConfiguration(allElements: ArrayList<XmlElement>): RootLoggerConfig {
        var root: RootLoggerConfig = RootLoggerConfig()
        var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
        for (element in allElements where element.name.equals("root")) {
            let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
            for (childrenElement in allChildrenElements) {
                if (childrenElement.name.toAsciiLower().equals("level")) {
                    root.setLevel(childrenElement.content)
                } else {
                    let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                    for (childrenAttr in allChildrenAttrs where allChildrenAttrs.size != 0) {
                        var appenderRef: AppenderRef = AppenderRef()
                        if (childrenAttr.name.equals("ref")) {
                            refList.append(AppenderRef(childrenAttr.content))
                        }
                    }
                    root.setAppenderRefList(refList)
                }
            }
        }
        return root
    }
}
