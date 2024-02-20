import XCTest
@testable import SieveCache

final class SieveCacheTests: XCTestCase {
    var cache: SieveCache<String, String>!
    
    override func setUp() {
        cache = SieveCache<String, String>(countLimit: 3)

        cache.setObject("ABC", forKey: "a")
        cache.setObject("BCD", forKey: "b")
        cache.setObject("CDE", forKey: "c")
    }
    
    func testCacheSizeLimit() throws {
        XCTAssertEqual(cache.count, 3)
        
        XCTAssertEqual(cache.object(forKey: "b"), "BCD")
        cache.setObject("DEF", forKey: "d")
        
        XCTAssertEqual(cache.count, 3)
        XCTAssertNil(cache.object(forKey: "a"))
        XCTAssertNotNil(cache.object(forKey: "b"))
    }
    
    func testCacheUpdate() {
        cache.setObject("EFG", forKey: "e")
        
        XCTAssertEqual(cache.count, 3)
        
        cache.setObject("EEE", forKey: "e")
        
        XCTAssertEqual(cache.count, 3)
        XCTAssertEqual(cache.object(forKey: "e"), "EFG")
    }

    func testCacheRemove() {
        cache.removeObject(forKey: "b")
    
        XCTAssertNil(cache.object(forKey: "b"))
        XCTAssertEqual(cache.count, 2)
        
        cache.setObject(nil, forKey: "a")

        XCTAssertNil(cache.object(forKey: "a"))
        XCTAssertEqual(cache.count, 1)
    }
    
    func testcacheRemoveAll() {
        cache.removeAllObjects()
        
        XCTAssertTrue(cache.isEmpty)
    }
    
    func testCacheSizeChange() {
        cache.countLimit = 10
        cache.setObject("DEF", forKey: "d")
        cache.setObject("EFG", forKey: "e")
        
        XCTAssertEqual(cache.count, 5)
    }
    
    func testEviction() {

        _ = cache.object(forKey: "a")
        _ = cache.object(forKey: "c")
        cache.setObject("DEF", forKey: "d")

        XCTAssertNil(cache.object(forKey: "b"))
    }
}
