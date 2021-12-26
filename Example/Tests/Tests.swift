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
    
    func testSubjectChange() {
        var x = Subject(0)
        var t: Int = -1
        x.change(owner: self) { value in
            t = value.newValue
            print(t)
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
    
    func testPropertyWrapperChange() {
        class TestInt {
            @Observable var i: Int = 0
        }
        let x = TestInt()
        var t: Int = -1
        x.$i.change(owner: self) { value in
            t = value.newValue
            print(t)
        }

        x.i = 1
        XCTAssertEqual(t, 1, "Should receive correct new value")

        x.i += 1
        XCTAssertEqual(t, 2, "Should receive correct new value")

        x.i += 1
        XCTAssertEqual(t, 3, "Should receive correct new value")

        x.i += 1
        XCTAssertEqual(t, 4, "Should receive correct new value")

        x.i -= 1
        XCTAssertEqual(t, 3, "Should receive correct new value")
    }
    
    func testRemoveOnwer() {
        var subject = Subject(1)
        
        var t: Int = -1
        subject.change(owner: self) { value in
            t = value.newValue
            print(value.newValue)
        } 
        
        XCTAssertEqual(t, 1, "Should receive correct new value")
        
        subject.value += 1
        
        XCTAssertEqual(t, 2, "Should receive correct new value")
        subject.remove(onwer: self)
        subject.remove(onwer: self)
        
        subject.value += 1
        XCTAssertEqual(t, 2, "Should receive correct new value")
        
        subject.change(owner: self) { value in
            t = value.newValue
            print(value.newValue)
        }
        subject.remove(onwer: self).change(owner: self) { value in
            t = value.newValue
            print(value.newValue)
        }
        subject.value += 1
        XCTAssertEqual(t, 4, "Should receive correct new value")
        
        subject.remove(onwer: self)
        subject.value += 1
        XCTAssertEqual(t, 4, "Should receive correct new value")
        
        subject.value += 1
        
        
    }
    
    func testRemoveFlag() {
        var subject = Subject(1)
        
        var t: Int = -1
        subject.change(owner: self, flag: "test") { value in
            t = value.newValue
            print(value.newValue)
        }
        
        XCTAssertEqual(t, 1, "Should receive correct new value")
        
        subject.value += 1
        
        XCTAssertEqual(t, 2, "Should receive correct new value")
        subject.remove(flag: "test")
        subject.remove(flag: "test")
        
        subject.value += 1
        XCTAssertEqual(t, 2, "Should receive correct new value")
        
        subject.change(owner: self, flag: "test") { value in
            t = value.newValue
            print(value.newValue)
        }
        subject.remove(flag: "test").change(owner: self, flag: "test") { value in
            t = value.newValue
            print(value.newValue)
        }
        subject.value += 1
        XCTAssertEqual(t, 4, "Should receive correct new value")
        
        subject.remove(flag: "test")
        subject.value += 1
        XCTAssertEqual(t, 4, "Should receive correct new value")
        
        subject.value += 1
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
