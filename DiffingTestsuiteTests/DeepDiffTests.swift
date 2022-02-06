//
//  DeepDiffTests.swift
//  DiffingTestsuiteTests
//
//  Created by Patrick Dinger on 2/6/22.
//

import XCTest
import DeepDiff

class DeepDiffTests: XCTestCase {
    
    private func runDeepDiff<T: DiffAware>(start: [T], end: [T]) -> [T] {
//        let wf = WagnerFischer<T>(reduceMove: false)
//        let patches = wf.diff(old: start, new: end)
        
        let patches = DeepDiff.diff(old: start, new: end)
        var workingSet = start
        
        for patch in patches {
            if let insert = patch.insert {
                print("INSERT \(insert.item) at", insert.index)
                workingSet.insert(insert.item, at: insert.index)
                print(workingSet)
            }
            
            if let delete = patch.delete {
                print("REMOVE \(workingSet[delete.index]) at", delete.index)
                workingSet.remove(at: delete.index)
                print(workingSet)
            }
            
            if let move = patch.move {
                print("MOVE number from", move.fromIndex, move.toIndex, workingSet)
                let val = workingSet[move.fromIndex]
//                print(val)
                workingSet.remove(at: move.fromIndex)
                workingSet.insert(val, at: move.toIndex)
                print(workingSet)
            }
            
            if let replace = patch.replace {
                print("Replace at \(replace.index) with \(replace.newItem) (replacing \(replace.oldItem))")
                workingSet[replace.index] = replace.newItem
                print(workingSet)
            }
        }
        
        return workingSet
    }

    func testDeepDiffScenario1() throws {
        let output = [4, 4, 3, 8, 9, 5, 2, 5]
        let result = runDeepDiff(start: [7, 2, 5, 6, 9], end: output)
        XCTAssertEqual(output, result)
    }

}
