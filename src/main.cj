import logger.*
from std import time.*

main(): Int64 {
    // 创建一个 Logger
    let logger = Logger_Manager.getLogger("com.hello")
    
    // 打印日志
    logger.info("hello")
    logger.info("hello")
    logger.error("hello")
    
    // 创建另一个 Logger
    let logger1 = Logger_Manager.getLogger("com.test1")
    logger1.warn("test1 waring")
    
    //测试异步写入
    let begin = Time.now()
    let logger2 = Logger_Manager.getLogger("com.test2")
    for (i in 0..30) {
        logger2.warn("test2 waring")
    }
    sleep(1000 * 1000 * 1000)
    let end = Time.now()
    println("time taken: ${end-begin}")
    return 0
}
