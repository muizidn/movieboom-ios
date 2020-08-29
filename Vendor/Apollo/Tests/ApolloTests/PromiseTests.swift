import XCTest
@testable import Apollo
import ApolloTestSupport
import StarWarsAPI

private struct TestError: Error {}
private struct OtherTestError: Error {}

class PromiseTests: XCTestCase {
  func testResultOfFulfilledPromise() {
    let promise = Promise<String>(fulfilled: "foo")
    
    XCTAssertEqual(promise.result?.apollo.value, "foo")
  }
  
  func testResultOfRejectedPromise() {
    let promise = Promise<String>(rejected: TestError())
    
    XCTAssertNil(promise.result?.apollo.value)
    XCTAssert(promise.result?.apollo.error is TestError)
  }
  
  func testWaitForResultOfFulfilledPromise() throws {
    let promise = Promise<String>(fulfilled: "foo")
    
    XCTAssertEqual(try promise.await(), "foo")
  }
  
  func testWaitForResultOfRejectedPromise() {
    let promise = Promise<String>(rejected: TestError())
    
    XCTAssertThrowsError(try promise.await()) { error in
      XCTAssert(error is TestError)
    }
  }
  
  func testFulfilledPromiseAndThen() {
    let promise = Promise<String>(fulfilled: "foo")
    
    let expectation = self.expectation(description: "andThen handler invoked")
    
    promise.andThen { value in
      XCTAssertEqual(value, "foo")
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func testRejectedPromiseCatch() {
    let promise = Promise<String>(rejected: TestError())
    
    let expectation = self.expectation(description: "catch handler invoked")
    
    promise.catch { error in
      XCTAssert(error is TestError)
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func testResultOfImmediatelyFulfilledPromise() {
    let promise = Promise<String> { (fulfill, reject) in
      fulfill("foo")
    }
    
    XCTAssertEqual(promise.result?.apollo.value, "foo")
  }
  
  func testWaitForResultOfImmediatelyFulfilledPromise() throws {
    let promise = Promise<String> { (fulfill, reject) in
      fulfill("foo")
    }
    
    XCTAssertEqual(try promise.await(), "foo")
  }
  
  func testResultOfImmediatelyRejectedPromise() {
    let promise = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }

    XCTAssert(promise.result?.apollo.error is TestError)
  }
  
  func testWaitForResultOfImmediatelyRejectedPromise() {
    let promise = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }
    
    XCTAssertThrowsError(try promise.await()) { error in
      XCTAssert(error is TestError)
    }
  }
  
  // Error handling
  
  func testAndThenPropagatesError() {
    let promise = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }.andThen { (_) in }
    
    XCTAssertThrowsError(try promise.await()) { error in
      XCTAssert(error is TestError)
    }
  }
  
  func testMapPropagatesError() {
    let promise = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }.map { (value) in
      return "bar"
    }
    
    XCTAssertThrowsError(try promise.await()) { error in
      XCTAssert(error is TestError)
    }
  }
  
  func testErrorThrownFromMapIsPropagated() {
    let promise = Promise<String> { (fulfill, reject) in
      fulfill("bar")
    }.map { (value) in
      throw TestError()
    }
    
    XCTAssertThrowsError(try promise.await()) { error in
      XCTAssert(error is TestError)
    }
  }
  
  func testFlatMapPropagatesError() {
    let promise = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }.flatMap { (value) in
      Promise<String> { (fulfill, reject) in
        return fulfill("bar")
      }
    }
    
    XCTAssertThrowsError(try promise.await()) { error in
      XCTAssert(error is TestError)
    }
  }
  
  func testErrorReturnedFromFlatMapIsPropagated() {
    let promise = Promise<String> { (fulfill, reject) in
      fulfill("bar")
    }.flatMap { (value) in
      Promise<String> { (fulfill, reject) in
        reject(TestError())
      }
    }
    
    XCTAssertThrowsError(try promise.await()) { error in
      XCTAssert(error is TestError)
    }
  }
  
  func testRejectedPromiseSkipsAndThen() {
    let expectation = self.expectation(description: "catch handler invoked")
    
    _ = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }.andThen { value in
      XCTFail()
    }.catch { error in
      XCTAssert(error is TestError)
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func testCatchPropagatesError() {
    let expectation = self.expectation(description: "catch handler invoked")
    
    _ = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }.catch { error in
      XCTAssert(error is TestError)
    }.catch { error in
      XCTAssert(error is TestError)
      expectation.fulfill()
    }.andThen { _ in
      XCTFail()
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func testErrorThrownFromAndThenIsPropagated() {
    let expectation = self.expectation(description: "catch handler invoked")
    
    _ = Promise<String> { (fulfill, reject) in
      fulfill("foo")
    }.andThen { value in
      throw TestError()
    }.catch { error in
      XCTAssert(error is TestError)
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func testErrorThrownFromCatchIsPropagated() {
    let expectation = self.expectation(description: "catch handler invoked")
    
    _ = Promise<String> { (fulfill, reject) in
      reject(TestError())
    }.catch { error in
      throw OtherTestError()
    }.catch { error in
      XCTAssert(error is OtherTestError)
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1)
  }
  
  // When all
  
  func testWhenAll() throws {
    let promises: [Promise<String>] = [Promise(fulfilled: "foo"), Promise(fulfilled: "bar")]
    
    let expectation = self.expectation(description: "whenAll andThen handler invoked")
    
    whenAll(promises).andThen { values in
      XCTAssertEqual(values, ["foo", "bar"])
      
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1)
  }
  
  func testWhenAllRejectsWhenAnyOfThePromisesRejects() throws {
    let promises: [Promise<String>] = [Promise(fulfilled: "foo"), Promise(rejected: TestError()), Promise(fulfilled: "bar")]
    
    let expectation = self.expectation(description: "whenAll catch handler invoked")
    
    whenAll(promises).catch { error in
      XCTAssert(error is TestError)
      
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1)
  }

  func testWhenAllRejectsWhenAnyOfThePromisesRejectsAsync_doesNotCreateMemoryLeak() throws {
    var executeReject: ((Error) -> Void)?

    var promises: [Promise<String>] = [Promise(fulfilled: "foo"),
                                       Promise<String> { _, reject in executeReject = reject },
                                       Promise(fulfilled: "bar")]
    weak var weakPromise0 = promises[0]
    weak var weakPromise1 = promises[1]
    weak var weakPromise2 = promises[2]

    let expectation = self.expectation(description: "whenAll catch handler invoked")

    whenAll(promises).catch { error in
      XCTAssert(error is TestError)

      expectation.fulfill()
    }

    promises = []
    executeReject?(TestError())
    executeReject = nil

    waitForExpectations(timeout: 1)

    XCTAssertNil(weakPromise0)
    XCTAssertNil(weakPromise1)
    XCTAssertNil(weakPromise2)
  }

}
