//
//  DifferenceKitTests.swift
//  DiffingTestsuiteTests
//
//  Created by Patrick Dinger on 2/6/22.
//

import DifferenceKit
import XCTest

class DifferenceKitTests: XCTestCase {
    func testScenario1() throws {
        let input = [7, 2, 5, 6, 9]
        let output = [4, 4, 3, 8, 9, 5, 2, 5]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario2() throws {
        let input = [1,2,4]
        let output = [1,2,3,4]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }
}

func runDifferenceKit<T: Differentiable>(start: [T], end: [T]) -> [T] {
    let changeSet = StagedChangeset(source: start, target: end)

    var workingSet = start

    for patch in changeSet {
        patch.elementInserted.forEach {
            let index = $0.element
            let element = end[index]
            print("INSERT \(element) at", index)
            workingSet.insert(element, at: index)
            print(workingSet)
        }
        patch.elementDeleted.forEach {
            let index = $0.element
            let element = start[index]
            print("REMOVE \(element) at", index)
            workingSet.remove(at: index)
            print(workingSet)
        }
        patch.elementMoved.forEach {
            let from = $0.source.element
            let to = $0.target.element
            let element = start[from]

            print("MOVE number \(element) from", from, to, workingSet)
            let val = element
            workingSet.remove(at: from)
            workingSet.insert(val, at: to)
            print(workingSet)
        }
        patch.elementUpdated.forEach {
            print("updated \($0)")
        }
    }

    return workingSet
}

extension Int: Differentiable {}
