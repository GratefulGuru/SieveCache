//
//  SIEVEPerformanceTests.swift
//  
//
//  Created by Christian Wolf Johannsen on 04/01/2024.
//

import XCTest
@testable import SieveCache

final class SievePerformanceTests: XCTestCase {
    let iterations = 10_000
    
    func testInsertionPerformance() throws {
        measure {
            let cache = SieveCache<Int, Int>()
            for i in 0 ..< iterations {
                cache.setObject(i, forKey: i)
            }
        }
    }

    func testLookupPerformance() {
        let cache = SieveCache<Int, Int>()
        for i in 0 ..< iterations {
            cache.setObject(i, forKey: i)
        }
        measure {
            for i in 0 ..< iterations {
                _ = cache.object(forKey: i)
            }
        }
    }

    func testRemovalPerformance() {
        let cache = SieveCache<Int, Int>()
        for i in 0 ..< iterations {
            cache.setObject(i, forKey: i)
        }
        measure {
            for i in 0 ..< iterations {
                _ = cache.removeObject(forKey: i)
            }
        }
    }

    func testOverflowInsertionPerformance() {
        measure {
            let cache = SieveCache<Int, Int>(countLimit: iterations/10)
            for i in 0 ..< iterations {
                cache.setObject(i, forKey: i)
            }
        }
    }

}
