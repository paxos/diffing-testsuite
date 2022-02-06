//
//  DifferMassTests.swift
//  DiffingTestsuiteTests
//
//  Created by Patrick Dinger on 2/6/22.
//

import Differ
import XCTest

typealias ExtendedSortingFunction = (ExtendedDiff.Element, ExtendedDiff.Element) -> Bool

class DifferMassTests: XCTestCase {
    private func makeArray(maxSize: Int, maxNumber: Int) -> [Int] {
        return Array(repeating: 0, count: Int.random(in: 0 ... maxSize)).map { _ in Int.random(in: 0 ... maxNumber) }
    }

    private func runDiffer<T: Equatable>(start: [T], end: [T]) -> [T] {
        let diffPatch = start.extendedDiff(end).patch(from: start, to: end)
        let patches = Differ.extendedPatch(from: start, to: end)
        var workingSet = start

        for patch in patches {
            switch patch {
            case .insertion(index: let index, element: let element):
//                print("INSERT \(element) at", index)
                workingSet.insert(element, at: index)
//                print(workingSet)
            case .deletion(index: let index):
//                print("REMOVE \(workingSet[index]) at", index)
                workingSet.remove(at: index)
//                print(workingSet)
            case .move(from: let from, to: let to):
                if from >= workingSet.count || to >= workingSet.count {
                    print("Out of bounds for \(start) -> \(end) ")
                } else {
//                    print("MOVE number from", from, to, workingSet)
                    let val = workingSet[from]
//                    print(val)
                    workingSet.remove(at: from)
                    workingSet.insert(val, at: to)
//                    print(workingSet)
                }
            }
        }

        return workingSet
    }

    //    func testExample3() throws {
    //        let start = [18, 19, 11]
    //        let target = [11, 19]
    //
    //        let result = differ(start: start, end: target)
    //        XCTAssertEqual(result, target)
    //    }
    //
    //    func testExample4() throws {
    //        let start = [18, 18, 19, 11]
    //        let target = [11, 19]
    //
    //        let result = differ(start: start, end: target)
    //        XCTAssertEqual(result, target)
    //    }

    func testDifferScenario1() throws {
        let output = [4, 4, 3, 8, 9, 5, 2, 5]
        let result = runDiffer(start: [7, 2, 5, 6, 9], end: output)
        XCTAssertEqual(output, result)
    }

    func testDifferScenario1AsString() throws {
        let output = ["4", "4", "3", "8", "9", "5", "2", "5"]
        let result = runDiffer(start: ["7", "2", "5", "6", "9"], end: output)
        XCTAssertEqual(output, result)
    }

    func testDifferRandom() throws {
        let NUMBER_OF_TESTS = 100000
        let MAX_SIZE = 10
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

//            print("-------------------------------------")
//            print("Input: \(input), Output: \(output)")

            let result = runDiffer(start: input, end: output)
//            print("Result: \(result)")

//            XCTAssertEqual(output, result)
        }
    }
}
