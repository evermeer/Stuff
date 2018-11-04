//
//  Print.swift
//
//  Created by Edwin Vermeer on 29/01/2017.
//  Copyright © 2017 EVICT BV. All rights reserved.
//

import Foundation

/**
 Extending the Stuff object with print functionality
 */
public extension Stuff {
    
    /**
     Enumeration of the log levels
     */
    public enum logLevel: Int {
        // Informational loging, lowest level
        case info = 1
        // Debug loging, default level
        case debug = 2
        // Warning loging, You should take notice
        case warn = 3
        // Error loging, Something went wrong, take action
        case error = 4
        // Fatal loging, Something went seriously wrong, can't recover from it.
        case fatal = 5
        // Set the minimumLogLevel to .none to stop everything from loging
        case none = 6
        
        /**
         Get the emoticon for the log level.
         */
        public func description() -> String {
            switch self {
            case .info:
                return "❓"
            case .debug:
                return "✳️"
            case .warn:
                return "⚠️"
            case .error:
                return "🚫"
            case .fatal:
                return "🆘"
            case .none:
                return ""
            }
        }
    }
    
    /**
     Set the minimum log level. By default set to .info which is the minimum. Everything will be loged.
     */
    public static var minimumLogLevel: logLevel = .info

    /**
     The print command for writing to the output window
     */
    public static func print<T>(_ object: T, _ level: logLevel = (T.self is Error.Type ? .error : .debug), filename: String = #file, line: Int = #line, funcname: String = #function, trace: [String] = Thread.callStackSymbols)  {
        if level.rawValue >= Stuff.minimumLogLevel.rawValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
            let process = ProcessInfo.processInfo
            let threadId = Thread.current.name ?? ""
            let file = URL(string: filename)?.lastPathComponent ?? ""
            let traceOutput: String = trace.map { "\t\t\($0)" }.reduce("\n") { "\($0)\n\($1)" }
            let output: String =  object is Error ? "\((object as! Error).localizedDescription)\(traceOutput)" : "\(object)"
            Swift.print("\n\(level.description()) .\(level) ⏱ \(dateFormatter.string(from: Foundation.Date())) 📱 \(process.processName) [\(process.processIdentifier):\(threadId)] 📂 \(file)(\(line)) ⚙️ \(funcname) ➡️\r\t\(output)")
        }
    }
}
