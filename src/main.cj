import logger.*

main(): Int64 {
    // 创建一个 Logger
    let logger = Logger_Manager.getLogger("com.hello")

    // 打印日志
    logger.all("1")
    logger.trace("2")
    logger.debug("3")
    logger.info("4")
    logger.warn("5")

    // 创建另一个 Logger
    let logger1 = Logger_Manager.getLogger("com.test1")
    logger1.error("6")
    logger1.off("7")
    return 0
}
