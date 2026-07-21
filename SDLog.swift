import Foundation

/// 日志级别，用于区分不同严重程度的日志信息。
public enum SDLogLevel: String {
    /// 调试信息，通常用于开发阶段排查问题。
    case debug = "DEBUG"
    /// 一般信息，用于记录应用的正常运行状态。
    case info = "INFO"
    /// 警告信息，表示出现了需要关注但不影响继续运行的情况。
    case warning = "WARNING"
    /// 错误信息，表示操作失败或发生异常。
    case error = "ERROR"

    /// 当前日志级别对应的显示图标。
    public var icon: String {
        switch self {
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        }
    }
}

/// 一个轻量级日志工具，将格式化日志同时输出到控制台和本地文件。
///
/// 文件写入操作在串行队列中异步执行，避免多线程同时写入造成内容错乱。
public final class SDLog: @unchecked Sendable {
    /// 静态日志方法共用的默认实例。
    private static let shared = SDLog()

    /// 日志文件的本地地址。
    private let logFileURL: URL
    /// 保证日志按调用顺序写入文件的串行队列。
    private let queue = DispatchQueue(label: "com.sdlog.file.queue")

    /// 创建日志记录器。
    ///
    /// - Parameters:
    ///   - fileManager: 用于获取日志保存目录的文件管理器。
    ///   - fileName: 日志文件名，默认是 `SDLog.log`。
    public init(fileManager: FileManager = .default, fileName: String = "SDLog.log") {
        self.logFileURL = SDLog.makeLogFileURL(fileManager: fileManager, fileName: fileName)
    }

    /// 记录一条调试日志。
    ///
    /// - Parameters:
    ///   - message: 要记录的日志内容。
    ///   - file: 调用位置的源文件路径，默认自动获取。
    ///   - function: 调用位置的函数名，默认自动获取。
    ///   - line: 调用位置的行号，默认自动获取。
    public static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.write(.debug, message, file: file, function: function, line: line)
    }

    /// 记录一条普通信息日志。
    ///
    /// 参数说明与 ``debug(_:file:function:line:)`` 相同。
    public static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.write(.info, message, file: file, function: function, line: line)
    }

    /// 记录一条警告日志。
    ///
    /// 参数说明与 ``debug(_:file:function:line:)`` 相同。
    public static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.write(.warning, message, file: file, function: function, line: line)
    }

    /// 记录一条错误日志。
    ///
    /// 参数说明与 ``debug(_:file:function:line:)`` 相同。
    public static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.write(.error, message, file: file, function: function, line: line)
    }

    /// 使用指定级别记录一条日志。
    ///
    /// - Parameters:
    ///   - level: 日志级别。
    ///   - message: 要记录的日志内容。
    ///   - file: 调用位置的源文件路径，默认自动获取。
    ///   - function: 调用位置的函数名，默认自动获取。
    ///   - line: 调用位置的行号，默认自动获取。
    public static func log(_ level: SDLogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        shared.write(level, message, file: file, function: function, line: line)
    }

    /// 返回默认日志文件的本地地址。
    public static func currentLogFileURL() -> URL {
        shared.logFileURL
    }

    /// 格式化日志内容，并将其输出到控制台及日志文件。
    private func write(_ level: SDLogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let timestamp = SDLog.makeTimestamp()
        let output = "[\(timestamp)] \(level.icon) [\(level.rawValue)] \(fileName):\(line) \(function) - \(message)"

        print(output)
        appendToFile(output)
    }

    /// 在串行队列中将文本追加到日志文件末尾。
    private func appendToFile(_ text: String) {
        queue.async { [logFileURL] in
            let line = text + "\n"
            guard let data = line.data(using: .utf8) else {
                return
            }

            let fileManager = FileManager.default
            let directory = logFileURL.deletingLastPathComponent()
            if !fileManager.fileExists(atPath: directory.path) {
                try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            }

            if !fileManager.fileExists(atPath: logFileURL.path) {
                fileManager.createFile(atPath: logFileURL.path, contents: nil)
            }

            guard let handle = try? FileHandle(forWritingTo: logFileURL) else {
                return
            }

            defer {
                handle.closeFile()
            }

            handle.seekToEndOfFile()
            handle.write(data)
        }
    }

    /// 生成精确到毫秒的当前时间字符串。
    private static func makeTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }

    /// 生成日志文件地址；无法取得 Documents 目录时使用临时目录。
    private static func makeLogFileURL(fileManager: FileManager, fileName: String) -> URL {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let baseURL = documentsURL ?? fileManager.temporaryDirectory
        return baseURL.appendingPathComponent(fileName)
    }
}
