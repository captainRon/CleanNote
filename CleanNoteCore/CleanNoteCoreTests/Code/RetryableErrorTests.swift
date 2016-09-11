import XCTest
@testable import CleanNoteCore

class DummyError: LocalizedError {
  let stubErrorDescription: String?

  convenience init() {
    self.init(errorDescription: nil)
  }

  init(errorDescription: String?) {
    stubErrorDescription = errorDescription
  }

  var errorDescription: String? {
    get { return stubErrorDescription }
  }
}

class RetryableErrorTests: XCTestCase {
  
  func test_errorDescription_readsFromWrappedError() {
    // Arrange.
    let wrappedError = DummyError(errorDescription: "wrapped error description")
    let sut = RetryableError(code: wrappedError) {}

    // Act.
    let actualErrorDescription = sut.errorDescription

    // Assert.
    let expectedErrorDescription = "wrapped error description"
    XCTAssertEqual(expectedErrorDescription, actualErrorDescription)
  }


  func test_attemptRecovery_cancelled_doesNotCallRecovery() {
    // Arrange.
    let wrappedError = DummyError()
    var didCallRecovery = false
    let sut = RetryableError(code: wrappedError) {
      didCallRecovery = true
    }

    // Act.
    let actualResult = sut.attemptRecovery(optionIndex: 1)

    // Assert.
    XCTAssertFalse(actualResult)
    XCTAssertFalse(didCallRecovery)
  }
}
