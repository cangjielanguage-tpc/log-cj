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
from std import os.posix.*
from std import sync.*
import appender.*
import config.*
import utils.*

public let Logger_Appender_Factory = LoggerAppenderFactory()
public let Logger_Manager = LoggerManager("${getcwd()}/src/resources/log4cj.xml")

/**
 * Log management class, load and parse log file to get a specific configuration item.
 */
public class LoggerManager {
    // Logger appender factory, mainly register logger appender.
    private var loggerAppenderFactory: LoggerAppenderFactory = LoggerAppenderFactory()

    // Root configuation variable.
    private var rootLogger: LoggerAppenderReference = LoggerAppenderReference()

    // Logger configuration map, mainly stores configurtion items related to logger configuration.
    private var loggerNameArr: ArrayList<String> = ArrayList<String>()
    private var loggerAttrArr: ArrayList<LoggerAppenderReference> = ArrayList<LoggerAppenderReference>()

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

    public func getLoggerAppenderFactory(): LoggerAppenderFactory {
        return this.loggerAppenderFactory
    }

    public func getRootLogger(): LoggerAppenderReference {
        return this.rootLogger
    }

    public func getLoggerNameArr(): ArrayList<String> {
        return this.loggerNameArr
    }

    public func getLoggerAttrArr(): ArrayList<LoggerAppenderReference> {
        return this.loggerAttrArr
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
    private func initWithDefaultConfig(xmlPath: String): Unit {
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
    private func initWithConfig(configuration: LoggerConfiguration): Unit {
        this.loggerAppenderFactory = Logger_Appender_Factory.new()

        this.loggerNameArr = ArrayList<String>()
        this.loggerAttrArr = ArrayList<LoggerAppenderReference>()
        this.rootLogger = LoggerAppenderReference(DEFAULT_LOG_LEVEL, ArrayList<LoggerAppender>())

        var nameArr: ArrayList<String> = ArrayList<String>()
        var enabledArr: ArrayList<String> = ArrayList<String>()

        // Register appenders.
        if (configuration.getAppenders().size > 0) {
            var i: Int64 = 0
            var appenders: ArrayList<AppenderConfig> = configuration.getAppenders()
            while (i < appenders.size) {
                nameArr.append(appenders.get(i).getOrThrow().getName().toAsciiLower())
                enabledArr.append(appenders.get(i).getOrThrow().getEnabled().toAsciiLower().trimAscii())
                if (!nameArr.get(i).getOrThrow().isEmpty() && enabledArr.get(i).getOrThrow().equals("true")) {
                    this.loggerAppenderFactory.registerLoggerAppender(
                        appenders.get(i).getOrThrow().getName(),
                        appenders.get(i).getOrThrow().getAppenderType(),
                        appenders.get(i).getOrThrow().getPattern(),
                        appenders.get(i).getOrThrow().getProperties()
                    )
                }
                i++
            }
        }

        // Initialize root configuration.
        let rootConfig = configuration.getRoot()

        this.rootLogger.setLevel(LogLevel.getLevelByString(rootConfig.getLevel()))

        if (rootConfig.getAppenderRefList().size > 0) {
            var j: Int64 = 0
            var appenderRefList: ArrayList<AppenderRef> = rootConfig.getAppenderRefList()
            while (j < appenderRefList.size) {
                var appenderRef = appenderRefList.get(j).getOrThrow()
                var index: Int64 = 0
                while (index < nameArr.size) {
                    if (nameArr.get(index).getOrThrow().equals(appenderRef.getRef().toAsciiLower()) &&
                        enabledArr.get(index).getOrThrow().equals("true")) {
                        let ap = this.loggerAppenderFactory.getAppenderByName(appenderRef.getRef().toAsciiLower())
                        this.rootLogger.getAppenderList().append(ap)
                    }
                    index++
                }
                j++
            }
        }

        // Initialize logger configuration.
        if (configuration.getLogger().size > 0) {
            var k: Int64 = 0
            var loggers: ArrayList<LoggerConfig> = configuration.getLogger()
            while (k < loggers.size) {
                var logger: LoggerConfig = loggers.get(k).getOrThrow()
                let oneLogger = LoggerAppenderReference(
                    LogLevel.getLevelByString(logger.getLevel()),
                    ArrayList<LoggerAppender>()
                )
                var m: Int64 = 0
                while (m < logger.getAppenderRefList().size) {
                    var appenderRef: AppenderRef = logger.getAppenderRefList().get(m).getOrThrow()
                    var index: Int64 = 0
                    while (index < nameArr.size) {
                        if (nameArr.get(index).getOrThrow().equals(appenderRef.getRef().toAsciiLower()) &&
                            enabledArr.get(index).getOrThrow().equals("true")) {
                            let oneAppender = this.loggerAppenderFactory.getAppenderByName(
                                appenderRef.getRef().toAsciiLower())
                            oneLogger.getAppenderList().append(oneAppender)
                        }
                        index++
                    }
                    m++
                }
                if (oneLogger.getAppenderList().size > 0) {
                    this.loggerNameArr.append(logger.getName())
                    this.loggerAttrArr.append(oneLogger)
                }
                k++
            }
        }
    }

    private func initLoggerManager(xmlPath: String): Unit {
        // Register the LoggerAppender provided by the system.
        // Logger_Appender_Factory.registryType("console", ConsoleLoggerAppender())
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
    private func loadXML(xmlPath: String): LoggerConfiguration {
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
    public func loadDefaultConfiguration(): LoggerConfiguration {
        var defaultXml: File = File("${getcwd()}/src/resources/default.xml", OpenOption.Open(true, true))
        var contentArray: Array<Byte> = File.readFrom(defaultXml.info.path)
        var content: String = String.fromUtf8(contentArray)
        var x: XmlParser = XmlParser()
        var elements: Option<XmlElement> = x.parse(content)
        var xmlElements: XmlElement = elements.getOrThrow()
        var appenderList: ArrayList<AppenderConfig> = getAppenderConfiguration(xmlElements.childrenElements)
        var loggerList: ArrayList<LoggerConfig> = getLoggerConfiguration(xmlElements.childrenElements)
        var root: RootLoggerConfig = getRootConfiguration(xmlElements.childrenElements)
        defaultXml.close()
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

        var i: Int64 = 0
        while (i < allElements.size) {
            var element: XmlElement = allElements.get(i).getOrThrow()
            if (element.name.toAsciiLower().equals("appender")) {
                let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
                let allAttrs: ArrayList<XmlAttr> = element.attributes
                var appender: AppenderConfig = AppenderConfig()
                var propertyList: ArrayList<AppenderProperty> = ArrayList<AppenderProperty>()
                var j: Int64 = 0
                while (j < allAttrs.size) {
                    var attr: XmlAttr = allAttrs.get(j).getOrThrow()
                    if (attr.name.toAsciiLower().equals("enabled")) {
                        appender.setEnabled(attr.content)
                    }
                    if (attr.name.toAsciiLower().equals("name")) {
                        appender.setName(attr.content)
                    }
                    j++
                }
                var k: Int64 = 0
                while (k < allChildrenElements.size) {
                    var childrenElement: XmlElement = allChildrenElements.get(k).getOrThrow()
                    if (childrenElement.name.toAsciiLower().equals("type")) {
                        appender.setAppenderType(childrenElement.content)
                    }
                    if (childrenElement.name.toAsciiLower().equals("pattern")) {
                        appender.setPattern(childrenElement.content)
                    } else {
                        let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                        var m: Int64 = 0
                        while (allChildrenAttrs.size != 0 && m < allChildrenAttrs.size) {
                            var childrenAttr: XmlAttr = allChildrenAttrs.get(m).getOrThrow()
                            var property: AppenderProperty = AppenderProperty(
                                childrenAttr.content,
                                childrenElement.content
                            )
                            propertyList.append(property)
                            m++
                        }
                        appender.setProperties(propertyList)
                    }
                    k++
                }
                configList.append(appender)
            }
            i++
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
        var i: Int64 = 0
        while (i < allElements.size) {
            var element: XmlElement = allElements.get(i).getOrThrow()
            if (element.name.toAsciiLower().equals("logger")) {
                let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
                let allAttrs: ArrayList<XmlAttr> = element.attributes
                var logger: LoggerConfig = LoggerConfig()
                var refList: ArrayList<AppenderRef> = ArrayList<AppenderRef>()
                var j: Int64 = 0
                while (j < allAttrs.size) {
                    var attr: XmlAttr = allAttrs.get(j).getOrThrow()
                    if (attr.name.toAsciiLower().equals("name")) {
                        logger.setName(attr.content)
                    }
                    j++
                }
                var k: Int64 = 0
                while (k < allChildrenElements.size) {
                    var childrenElement: XmlElement = allChildrenElements.get(k).getOrThrow()
                    if (childrenElement.name.toAsciiLower().equals("level")) {
                        logger.setLevel(childrenElement.content)
                    } else {
                        let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                        var m: Int64 = 0
                        while (allChildrenAttrs.size != 0 && m < allChildrenAttrs.size) {
                            var childrenAttr: XmlAttr = allChildrenAttrs.get(m).getOrThrow()
                            if (childrenAttr.name.toAsciiLower().equals("ref")) {
                                refList.append(AppenderRef(childrenAttr.content))
                            }
                            m++
                        }
                        logger.setAppenderRefList(refList)
                    }
                    k++
                }
                loggerList.append(logger)
            }
            i++
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
        var i: Int64 = 0
        while (i < allElements.size) {
            var element: XmlElement = allElements.get(i).getOrThrow()
            if (element.name.toAsciiLower().equals("root")) {
                let allChildrenElements: ArrayList<XmlElement> = element.childrenElements
                var j: Int64 = 0
                while (j < allChildrenElements.size) {
                    var childrenElement: XmlElement = allChildrenElements.get(j).getOrThrow()
                    if (childrenElement.name.toAsciiLower().equals("level")) {
                        root.setLevel(childrenElement.content)
                    } else {
                        let allChildrenAttrs: ArrayList<XmlAttr> = childrenElement.attributes
                        var k: Int64 = 0
                        while (allChildrenAttrs.size != 0 && k < allChildrenAttrs.size) {
                            var childrenAttr: XmlAttr = allChildrenAttrs.get(k).getOrThrow()
                            var appenderRef: AppenderRef = AppenderRef()
                            if (childrenAttr.name.equals("ref")) {
                                refList.append(AppenderRef(childrenAttr.content))
                            }
                            k++
                        }
                        root.setAppenderRefList(refList)
                    }
                    j++
                }
            }
            i++
        }
        return root
    }
}
