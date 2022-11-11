import logger.*

main(): Int64 {
    // 创建一个 Logger
    let logger = Logger_Manager.getLogger("com.hello")

    // 打印日志
    logger.all("all")
    logger.trace("trace")
    logger.debug("debug")
    logger.info("info")
    logger.warn("warn")

    // 创建另一个 Logger
    let logger1 = Logger_Manager.getLogger("com.test1")
    logger1.error("error")
    logger1.off("off")
    return 0
}
