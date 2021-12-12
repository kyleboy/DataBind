import XCTest
import DataBind

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testIntAfterChange() {
        var x = Observable(0)
        var t: Int = -1
        x.afterChange.add(owner: self) { value in
            t = value.newValue
//            print(t)
        }
        
        x.value = 1
        XCTAssertEqual(t, 1, "Should receive correct new value")

        x.value += 1
        XCTAssertEqual(t, 2, "Should receive correct new value")

        x.value += 1
        XCTAssertEqual(t, 3, "Should receive correct new value")

        x.value += 1
        XCTAssertEqual(t, 4, "Should receive correct new value")

        x.value -= 1
        XCTAssertEqual(t, 3, "Should receive correct new value")
    }
    
    func testIntTransformAfterChange() {
        var x = Observable(0)
        var t: String = ""
        x.afterChange.add(owner: self) { value in
            t = value.transform { "\($0.newValue)" }
            print(t)
        }
        
        x.value = 1
        XCTAssertEqual(t, "1", "Should receive correct new value")

        x.value += 1
        XCTAssertEqual(t, "2", "Should receive correct new value")

        x.value += 1
        XCTAssertEqual(t, "3", "Should receive correct new value")

        x.value += 1
        XCTAssertEqual(t, "4", "Should receive correct new value")

        x.value -= 1
        XCTAssertEqual(t, "3", "Should receive correct new value")
    }
    
    func testArrayAfterChange() {
        var x = Observable([String]())
        var t: [String]?
        x.afterChange.add(owner: self) { value in
            t = value.newValue
            print(t?.description ?? "")
        }
        
        x.value.append("A")
        XCTAssertEqual(t![0], "A", "Should receive correct new value")
        
        x.value.append("B")
        XCTAssertEqual(t![1], "B", "Should receive correct new value")
        
        x.value.removeLast()
        XCTAssertEqual(t!.count, 1, "Should receive correct new value")
    }
    
    func testArrayObjectAfterChange() {
        var x = Observable([AnyObject]())
        var t: [AnyObject]?
        x.afterChange.add(owner: self) { value in
            t = value.newValue
            print(t?.description)
        }
        
        x.value.append(NSObject())
        XCTAssertEqual(t!.count, 1, "Should receive correct new value")
        
        x.value.append(NSString("12"))
        XCTAssertEqual(t!.count, 2, "Should receive correct new value")
        
        x.value.removeLast()
        XCTAssertEqual(t!.count, 1, "Should receive correct new value")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
