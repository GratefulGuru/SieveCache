//
//  SIEVEPerformanceTests.swift
//  
//
//  Created by Christian Wolf Johannsen on 04/01/2024.
//

import XCTest
@testable import SIEVE_cache

final class SIEVEPerformanceTests: XCTestCase {
    let iterations = 10000
    
    func testInsertionPerformance() throws {
        measure {
            let cache = SieveCache<Int, Int>()
            for i in 0 ..< iterations {
                cache.setValue(i, forKey: i)
            }
        }
    }

    func testLookupPerformance() {
        let cache = SieveCache<Int, Int>()
        for i in 0 ..< iterations {
            cache.setValue(i, forKey: i)
        }
        measure {
            for i in 0 ..< iterations {
                _ = cache.value(forKey: i)
            }
        }
    }

    func testRemovalPerformance() {
        let cache = SieveCache<Int, Int>()
        for i in 0 ..< iterations {
            cache.setValue(i, forKey: i)
        }
        measure {
            for i in 0 ..< iterations {
                _ = cache.removeValue(forKey: i)
            }
        }
    }

    func testOverflowInsertionPerformance() {
        measure {
            let cache = SieveCache<Int, Int>(capacity: iterations/10)
            for i in 0 ..< iterations {
                cache.setValue(i, forKey: i)
            }
        }
    }

}
