//
//  PrintStuffTests.swift
//  Stuff
//
//  Created by Edwin Vermeer on 13/02/2017.
//  Copyright © 2017 evict. All rights reserved.
//

import XCTest
@testable import Stuff

class PrintStuffTests: XCTestCase {
    
    func testPrint() {
        Stuff.print("Just as the standard print but now with detailed information")
        Stuff.print("Now it's a warning", .warn)
        Stuff.print("Or even an error", .error)

        Stuff.minimumLogLevel = .error
        Stuff.print("Now you won't see normal log output")
        Stuff.print("Only errors are shown", .error)

        Stuff.minimumLogLevel = .none
        Stuff.print("Or if it's disabled you won't see any log", .error)
    }
    
}
