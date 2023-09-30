import XCTest
@testable import LRUCache

final class LRUCacheTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testImplement() throws {
        let cache = LRUCache<Int, String>(cap: 3)!
        cache.put("1", forKey: 1)
        cache.put("2", forKey: 2)
        cache.put("3", forKey: 3)
        cache.put("4", forKey: 4)
        
        XCTAssert(cache.pop(forKey: 2) == "2")
        XCTAssert(cache.pop(forKey: 2) == nil)
        XCTAssert(cache.pop(forKey: 1) == nil)
        XCTAssert(cache.pop(forKey: 3) == "3")
        XCTAssert(cache.pop(forKey: 3) == nil)
        XCTAssert(cache.pop(forKey: 4) == "4")
        XCTAssert(cache.pop(forKey: 4) == nil)
        
        cache.put("1", forKey: 1)
        cache.put("2", forKey: 2)
        cache.put("3", forKey: 3)
        cache.put("4", forKey: 4)
        XCTAssert(cache[1] == nil)
        XCTAssert(cache[2] == "2")
        XCTAssert(cache[3] == "3")
        XCTAssert(cache[4] == "4")
        cache[5] = "5"
        cache[6] = "6"
        cache[7] = "7"
        XCTAssert(cache[2] == nil)
        XCTAssert(cache[3] == nil)
        XCTAssert(cache[4] == nil)
        
        cache.removeAll()
        cache[5] = "5"
        cache[6] = "6"
        cache[7] = "7"
        XCTAssert(cache[5] == "5")
        XCTAssert(cache[6] == "6")
        XCTAssert(cache[7] == "7")
        
        XCTAssert(cache.orderedValues == ["7", "6", "5"])
        let values = cache.values
        XCTAssert(values.contains("5"))
        XCTAssert(values.contains("6"))
        XCTAssert(values.contains("7"))
        cache.remove(some: 32)
        XCTAssert(cache[7] == nil)
        XCTAssert(cache[6] == nil)
        XCTAssert(cache.count == 0)
        cache[5] = "5"
        cache[6] = "6"
        cache[7] = "7"
        cache.touch(forKey: 5)
        XCTAssert(cache.orderedValues == ["5", "7", "6"])
    }
}
