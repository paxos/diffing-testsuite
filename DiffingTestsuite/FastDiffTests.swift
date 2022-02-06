//
//  FastDiffTests.swift
//  DiffingTestsuiteTests
//
//  Created by Patrick Dinger on 2/6/22.
//

import FastDiff
import XCTest

class FastDiffTests: XCTestCase {
    private func runFastDiff<T: Diffable>(start: [T], end: [T]) -> [T] {
        var workingSet = start

        // The diff changes always relate to the initial input, not the rolling input
        let changeSet = diff(start, end)
        let patches = orderedOperation(from: changeSet)

        for patch in changeSet {
            switch patch {
            case let .add(element, index):
                print("INSERT \(element) at", index)
                workingSet.insert(element, at: index)
                print(workingSet)
            case let .delete(element, index):
                print("REMOVE \(element) at", index)
                workingSet.remove(at: index)
                print(workingSet)

            case .move(let element2, let from, let to):
                print("MOVE number \(element2) from", from, to, workingSet)
                let val = element2
                workingSet.remove(at: from)
                workingSet.insert(val, at: to)
                print(workingSet)

            case let .update(e1, e2, index):
                print("Update \(e2) at", index)
                workingSet[index] = e2
            }
        }
        return workingSet
    }

    func testScenario1() throws {
        let output = [4, 4, 3, 8, 9, 5, 2, 5]
        let result = runFastDiff(start: [7, 2, 5, 6, 9], end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario2() throws {
        let output = [4,3,2,1]
        let result = runFastDiff(start: [1,2,3,4], end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario3() throws {
        let output = [1,2,3,4,5]
        let result = runFastDiff(start: [1,2,3,5], end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario4() throws {
        let output = ["4","1","2","3"]
        let result = runFastDiff(start: ["1","2","3","4"], end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario5() throws {
        let output = ["4","1","2","3"].map { TestElement(name: $0) }
        let input = ["1","2","3","4"].map { TestElement(name: $0) }
        let result = runFastDiff(start: input, end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario6() throws {
        let input  = [1,2,3,4,5]
        let output = [5,1,2,3,4,6]
        print(input)
        let result = runFastDiff(start: input, end: output)
        XCTAssertEqual(output, result)
    }
}

struct TestElement: Diffable, Equatable {
    let name: String
    
    var diffHash: Int {
        return name.hashValue
    }

}
