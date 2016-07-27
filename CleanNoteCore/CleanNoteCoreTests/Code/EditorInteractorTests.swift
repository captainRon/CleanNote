import XCTest
@testable import CleanNoteCore

class EditorInteractorTests: XCTestCase {

  var output: MockEditorInteractorOutput!

  override func setUp() {
    output = MockEditorInteractorOutput()
  }


  func test_fetchText_newNote_emptyText() {
    // Arrange.
    let gateway = InMemoryNoteGateway(notes: [])

    let sut = EditorInteractor(output: output, gateway: gateway, noteID: nil)

    // Act.
    sut.fetchText()

    // Assert.
    let expectedText = ""
    XCTAssertEqual(expectedText, output.actualText)
  }
  

  func test_fetchText_existingNote_verbatimText() {
    // Arrange.
    let note = Note(id: "one", text: "sample text")
    let gateway = InMemoryNoteGateway(notes: [note])

    let sut = EditorInteractor(output: output, gateway: gateway, noteID: "one")

    // Act.
    sut.fetchText()

    // Assert.
    let expectedText = "sample text"
    XCTAssertEqual(expectedText, output.actualText)
  }


  func test_fetchText_noteNotFound_emptyText() {
    // Arrange.
    let note = Note(id: "one", text: "sample text")
    let gateway = InMemoryNoteGateway(notes: [note])

    let sut = EditorInteractor(output: output, gateway: gateway, noteID: "zilch")

    // Act.
    sut.fetchText()

    // Assert.
    let expectedText = ""
    XCTAssertEqual(expectedText, output.actualText)
  }


  func test_saveText_newNote_createsNote() {
    // Arrange.
    let gateway = MockNoteGateway()

    let sut = EditorInteractor(output: output, gateway: gateway, noteID: nil)

    // Act.
    sut.save(text: "my note text")

    // Assert.
    let expectedText = "my note text"
    let actualText = gateway.textForCreateNote
    XCTAssertEqual(expectedText, actualText)
  }
  
  
  func test_saveText_newNote_failsToSave_informsOutput() {
    // Arrange.
    let gateway = MockNoteGateway()
    gateway.stub(createNoteThrows: .unknown)
    output.expectDidFailToSave()

    let sut = EditorInteractor(output: output, gateway: gateway, noteID: nil)

    // Act.
    sut.save(text: "my note text")

    // Assert.
    XCTAssertTrue(output.assert())
  }
  
  
  func test_saveText_existingNote_updatesNote() {
    // Arrange.
    let gateway = MockNoteGateway()

    let sut = EditorInteractor(output: output, gateway: gateway, noteID: "one")

    // Act.
    sut.save(text: "my note text")

    // Assert.
    let expectedText = "my note text"
    let actualText = gateway.textForSaveNote
    XCTAssertEqual(expectedText, actualText)
    
    let expectedNoteID = "one"
    let actualNoteID = gateway.noteIDForSaveNote
    XCTAssertEqual(expectedNoteID, actualNoteID)
  }


  func test_saveText_existingNote_failsToSave_informsOutput() {
    // Arrange.
    let gateway = MockNoteGateway()
    gateway.stub(saveThrows: .notFound)
    output.expectDidFailToSave()

    let sut = EditorInteractor(output: output, gateway: gateway, noteID: "one")

    // Act.
    sut.save(text: "my note text")

    // Assert.
    XCTAssertTrue(output.assert())
  }
}