package test

func getQueryResult(pattern: String, rec: LogRecord, fileName: String, tag!: String = ""): Bool {
    var curDir: Directory = Directory(".")
    var fileList: ArrayList<FileInfo> = curDir.fileList()
    for (f in fileList) {
        if (f.isFile() && f.path.toString().contains(fileName)) {
            var allBytes: Array<Byte> = File.readFrom(f.path.toString())
            var content: String = String.fromUtf8(allBytes)
            var time: String = rec.getCreatedTime().toString()[11..19]
            var tagName = rec.getTagName()
            var level = rec.getLevel().levelName()
            var source = rec.getSource()
            var message = rec.getMessage()
            if (pattern.size == 0 && content.contains(time) && content.contains(tagName) && content.contains(level) &&
                content.contains(source) && content.contains(message)) {
                return true
            } else {
                println("message wrong = ${tag}")
                if (tag == "log_test_046") {
                    println("content = ${content}")
                    println("pattern.size = ${pattern.size}, time = ${time}, tagName = ${tagName}, level = ${level}, source = ${source}, message = ${message}")
                    println("contains(time)=${content.contains(time)}")
                    println("contains(tagName)=${content.contains(tagName)}")
                    println("contains(level)=${content.contains(level)}")
                    println("contains(source)=${content.contains(source)}")
                    println("contains(message)=${content.contains(message)}")
                }
            }
            if (pattern.size != 0 && !pattern.contains("%l") && content.contains(time) && content.contains(level) &&
                content.contains(source) && content.contains(message)) {
                return true
            }
        } else {
            println("can not find ${fileName}")
        }
    }
    return false
}