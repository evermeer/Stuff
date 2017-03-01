//
//  TODOStuffTests.swift
//  Stuff
//
//  Created by Edwin Vermeer on 28/02/2017.
//  Copyright © 2017 evict. All rights reserved.
//

import XCTest
@testable import Stuff

class TODOStuffTests: XCTestCase {
    
    func testTODO() {
        // We need to fix something, but function can run
        TODO()
        
        TODO("An other todo, now giving some detailed info")
        
        // We need to fix this. Otherwise just fail. The tet will crash here. See the stacktrace
        TODO_
    }
    
}
