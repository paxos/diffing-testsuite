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

func differ(start: [Int], end: [Int]) -> [Int] {
    let patches = Differ.extendedPatch(from: start, to: end)
    var workingSet = start

    for patch in patches {
        switch patch {
        case let .insertion(index: index, element: element):
            print("INSERT \(element) at", index, workingSet)
            workingSet.insert(element, at: index)
        case let .deletion(index: index):
            print("REMOVE \(workingSet[index]) at", index, workingSet)
            workingSet.remove(at: index)
        case let .move(from: from, to: to):
            print("MOVE number \(workingSet[from]) from", from, to, workingSet)
            let val = workingSet[from]
            workingSet.remove(at: from)
            workingSet.insert(val, at: to)
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
    func testExample3() throws {
        let start = [18, 19, 11]
        let target = [11, 19]

        let result = differ(start: start, end: target)
        XCTAssertEqual(result, target)
    }

    func testExample4() throws {
        let start = [18, 18, 19, 11]
        let target = [11, 19]

        let result = differ(start: start, end: target)
        XCTAssertEqual(result, target)
    }

    func testDifferRandom() throws {
        let NUMBER_OF_TESTS = 10000
        let MAX_SIZE = 25
        let MAX_NUMBER = 10

        var testPairs: [[[Int]]] = []

        for _ in 1 ... NUMBER_OF_TESTS {
            let b = [makeArray(maxSize: MAX_SIZE, maxNumber: MAX_NUMBER), makeArray(maxSize: MAX_SIZE, maxNumber: MAX_NUMBER)]
            testPairs.append(b)
        }

        // Run tests
        testPairs.forEach { testPair in
            let input = testPair[0]
            let output = testPair[1]

            print("-------------------------------------")
            print("Input: \(input), Output: \(output)")

            let result = differ(start: input, end: output)
            print("Result: \(result)")

            XCTAssertEqual(output, result)
        }
    }

    func makeArray(maxSize: Int, maxNumber: Int) -> [Int] {
        return Array(repeating: 0, count: Int.random(in: 0 ... maxSize)).map { _ in Int.random(in: 0 ... maxNumber) }
    }
}
