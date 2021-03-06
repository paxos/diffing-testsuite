//
//  DiffingTestsuiteTests.swift
//  DiffingTestsuiteTests
//
//  Created by Patrick Dinger on 2/5/22.
//

import Differ
@testable import DiffingTestsuite
import XCTest

func moves(start: [Int], end: [Int], diff: CollectionDifference<Int>) -> [Int] {
    var workingSet = start

    for change in diff {
        switch change {
        case let .insert(offset, element, associatedWith):
            if let from = associatedWith {
                print("MOVE", from, offset)
                let val = workingSet[from]
                workingSet.remove(at: from)
                workingSet.insert(val, at: offset)
            } else {
                print("INSERT", offset)
                workingSet.insert(element, at: offset)
            }
        case let .remove(offset, _, associatedWith):
            // If it is a MOVE it was already recorded in .insert
            if associatedWith == nil {
                print("REMOVE", offset)
                workingSet.remove(at: offset)
            }
        }
    }

    return workingSet
}



class DiffingTestsuiteTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample1() throws {
        let start = [18, 19, 11]
        let target = [11, 19]

        let diff = target.difference(from: start).inferringMoves()

        let result = moves(start: start, end: target, diff: diff)
        XCTAssertEqual(result, target)
    }

//    func testExample2() throws {
//        let start = [18, 18, 19, 11]
//        let target = [11, 19]
//
//        let diff = target.difference(from: start).inferringMoves()
//
//        let result = moves(start: start, end: target, diff: diff)
//        XCTAssertEqual(result, target)
//    }

    // Differ

  
}
