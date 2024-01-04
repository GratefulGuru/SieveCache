import XCTest
@testable import SIEVE_cache

final class SIEVE_cacheTests: XCTestCase {
    var cache: SieveCache<String, String>!
    
    override func setUp() {
        cache = SieveCache<String, String>(capacity: 3)

        cache.setValue("ABC", forKey: "a")
        cache.setValue("BCD", forKey: "b")
        cache.setValue("CDE", forKey: "c")
    }
    
    func testCacheUpdate() throws {
        XCTAssertEqual(cache.size, 3)
        
        XCTAssertEqual(cache.value(forKey: "b"), "BCD")
        cache.setValue("DEF", forKey: "d")
        
        XCTAssertEqual(cache.size, 3)
        XCTAssertNil(cache.value(forKey: "a"))
        XCTAssertNotNil(cache.value(forKey: "b"))
    }
    
    func testEviction() {
        _ = cache.value(forKey: "a")
        _ = cache.value(forKey: "c")
        cache.setValue("DEF", forKey: "d")

        XCTAssertNil(cache.value(forKey: "b"))
    }
    
    func testRemoval() {
        cache.removeValue(forKey: "a")
        
        XCTAssertEqual(cache.size, 2)
    }
}
