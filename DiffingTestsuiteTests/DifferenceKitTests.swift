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
    
    func testScenario10() throws {
        let input = [1, 2, 3, 4]
        let output = [1, 2, 3]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }

    func testScenario2() throws {
        let input = [1, 2, 4]
        let output = [1, 2, 3, 4]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }

    func testScenario3() throws {
        let input = [1, 2, 3, 4, 5]
        let output = [5, 4, 3, 2, 1]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }

    func testScenario4() throws {
        let input = [1, 2, 3]
        let output = [3, 2, 1]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }

    func testScenario5() throws {
        let input = [0, 1, 2, 3]
        let output = [3, 2, 1, 0]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario6() throws {
        let input = ["zero", "one", "two", "Three"]
        let output = ["three", "two", "one", "zero"]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }
    
    func testScenario7() throws {
        let input = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let output = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        let result = runDifferenceKit(start: input, end: output)
        XCTAssertEqual(output, result)
    }
}

func runDifferenceKit<T: Differentiable>(start: [T], end: [T]) -> [T] {
    let changeSet = StagedChangeset(source: start, target: end, section: 0)

    var workingSet = start

    for patch in changeSet {
        patch.elementDeleted.forEach {
            let index = $0.element
            let element = start[index]
            print("REMOVE \(element) at", index)
            workingSet.remove(at: index)
            print(workingSet)
        }

        patch.elementInserted.forEach {
            let index = $0.element
            let element = end[index]
            print("INSERT \(element) at", index)
            workingSet.insert(element, at: index)
            print(workingSet)
        }

        patch.elementUpdated.forEach {
            print("updated \($0)")
        }

        for (source, target) in patch.elementMoved {
            let from = source.element
            let to = target.element
            let element = start[from]

            print("MOVE number \(element) from", from, to, workingSet)

            // Find elementA in start at index from
            // Find indexA of elementA in working set
            // Swap indexA with to

            let elementA = start[from]
            let indexA = workingSet.firstIndex(where: {
                $0.isContentEqual(to: elementA)
            })!

            workingSet.remove(at: indexA)
            workingSet.insert(elementA, at: to)

            print(workingSet)
        }
    }

    return workingSet
}

extension Int: Differentiable {}
extension String: Differentiable {}
