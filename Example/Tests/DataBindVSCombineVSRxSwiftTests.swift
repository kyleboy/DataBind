//
//  DataBindVSCombineVSRxSwiftTests.swift
//  DataBind_Tests
//
//  Created by 王英辉 on 2021/12/22.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import DataBind
//import RxSwift
import Combine


class DataBindVSCombineVSRxSwiftTests: XCTestCase {

//    private let input = stride(from: 0, to: 1_000_000, by: 1)
//
//    override class var defaultPerformanceMetrics: [XCTPerformanceMetric] {
//        return [XCTPerformanceMetric()]
//    }
    
    private let input = stride(from: 0, to: 1_000_000, by: 1)
    override class var defaultPerformanceMetrics: [XCTPerformanceMetric] {
        return [    XCTPerformanceMetric("com.apple.XCTPerformanceMetric_TransientHeapAllocationsKilobytes"),
            .wallClockTime
        ]
    }

    func testDataBind() {
        class TestInt {
            @DataBind.Observable var i: Int = 0
        }
        
        print("size Int: \(MemoryLayout<Int>.size)")
        print("size Observable: \(MemoryLayout<DataBind.Observable<Int>>.size)")
        print("size Observable(): \(MemoryLayout.size(ofValue: DataBind.Observable(wrappedValue: 1)))")
        print("size Event: \(MemoryLayout<DataBind.Event<ValueChange<Int>>>.size)")
        print("size Event(): \(MemoryLayout.size(ofValue: DataBind.Event<ValueChange<Int>>.self))")
       
        
//
//        self.measure {
//            let x = TestInt()
////            var t: Int = -1
////            x.$i.change(owner: self) { value in
////                t = value.newValue
////                print(t)
////            }
//
//            x.i += 1
//            x.i += 1
//            x.i += 1
//        }
    }
    
    func testNoDataBind() {
        class TestInt {
            var i: Int = 0
        }
        
        self.measure {
            let x = TestInt()
        
            
            x.i += 1
            x.i += 1
            x.i += 1
            
            print(x.i)
        }
    }
    
//    func testCombine() {
//        if #available(iOS 13, *) {
//            self.measure {
//                _ = Publishers.Sequence(sequence: input)
//                    .map { $0 * 2 }
//                    .filter { $0.isMultiple(of: 2) }
//                    .flatMap { Just($0) }
//                    .count()
//                    .sink(receiveValue: {
//                        print($0)
//                    })
//            }
//        }
//    }
//
//    func testRxSwift() {
//        self.measure {
//            _ = RxSwift.Observable.from(input)
//                .map { $0 * 2 }
//                .filter { $0.isMultiple(of: 2) }
//                .flatMap { RxSwift.Observable.just($0) }
//                .toArray()
//                .map { $0.count }
//                .subscribe(onSuccess: { print($0) })
//        }
//    }

}
