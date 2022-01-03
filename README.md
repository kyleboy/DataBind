# DataBind

[![CI Status](https://img.shields.io/travis/iyinghui@163.com/DataBind.svg?style=flat)](https://travis-ci.org/iyinghui@163.com/DataBind)
[![Version](https://img.shields.io/cocoapods/v/DataBind.svg?style=flat)](https://cocoapods.org/pods/DataBind)
[![License](https://img.shields.io/cocoapods/l/DataBind.svg?style=flat)](https://cocoapods.org/pods/DataBind)
[![Platform](https://img.shields.io/cocoapods/p/DataBind.svg?style=flat)](https://cocoapods.org/pods/DataBind)

利用Swift 属性包装器和泛型实现的观察者模式（KVO）



## Use

```swift
func test {
  class TestInt {
   	@Observable var i: Int = 0
  }
  let x = TestInt()
  x.$i.change(owner: self) { value in
	print(t)
  }
  // print 0

  x.i = 1  // print 1
  x.i += 1 // print 2
  x.i += 1 // print 3
  x.i += 1 // print 4
  x.i -= 1 // print 3
} 

test() // 0 1 2 3 4 3

```



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DataBind is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DataBind'
```

## Author

iyinghui@163.com, wangyinghui@changba.com

## License

DataBind is available under the MIT license. See the LICENSE file for more info.
