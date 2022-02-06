//
//  CollectionDiffingTests.swift
//  DiffingTestsuiteTests
//
//  Created by Patrick Dinger on 2/6/22.
//

import XCTest

class CollectionDiffingTests: XCTestCase {
    private func runAppleCollectionDiff<T: Hashable>(start: [T], end: [T]) -> [T] {
        let patches = end.difference(from: start).inferringMoves()

        for patch in patches {
            // TODO:
        }

        return start
    }

    func testAppleCollectionDiffScenario1() throws {
        let output = [4, 4, 3, 8, 9, 5, 2, 5]
        let result = runAppleCollectionDiff(start: [7, 2, 5, 6, 9], end: output)
        XCTAssertEqual(output, result)
    }
}
