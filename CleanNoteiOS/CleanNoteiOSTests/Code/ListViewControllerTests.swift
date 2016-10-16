import XCTest
@testable import CleanNoteCore
@testable import CleanNoteiOS

class ListViewControllerTests: XCTestCase {

  var interactor: MockListInteractorInput!
  var tableView: MockTableView!
  var sut: ListViewController!

  override func setUp() {
    interactor = MockListInteractorInput()
    tableView = MockTableView()
    tableView.stub(dequeueReusableCell: UITableViewCell(), with: "NoteCell")

    sut = ListViewController()
    sut.interactor = interactor
    sut.noteGateway = MockNoteGateway()
    sut.tableView = tableView
  }


  func test_viewWillAppear_fetchesNotes() {
    // Arrange.
    interactor.expectFetchNotes()

    // Act.
    sut.viewWillAppear(false)

    // Assert.
    XCTAssert(interactor.assert())
  }


  func test_update_reloadsTableView() {
    // Arrange.
    let notes = ListViewList(notes: [], selected: nil)
    tableView.expectReloadData()

    // Act.
    sut.update(list: notes)

    // Assert.
    XCTAssert(tableView.assert())
  }


  func test_update_displaysCorrectNumberOfRowsInTable() {
    // Arrange.
    let notes = [
      ListViewNote(id: "1", summary: "sample note"),
      ListViewNote(id: "2", summary: "another sample note")
    ]
    let list = ListViewList(notes: notes, selected: nil)

    // Act.
    sut.update(list: list)

    // Assert.
    let expectedRows = 2
    let actualRows = sut.tableView(tableView, numberOfRowsInSection: 0)
    XCTAssertEqual(expectedRows, actualRows)
  }


  func test_update_displaysCorrectDataInTable() {
    // Arrange.
    let notes = [
      ListViewNote(id: "1", summary: "sample note"),
      ListViewNote(id: "2", summary: "another sample note")
    ]
    let list = ListViewList(notes: notes, selected: nil)
    
    // Act.
    sut.update(list: list)

    // Assert.
    for row in (0..<notes.count) {
      let indexPath = IndexPath(row: row, section: 0)
      let cell = sut.tableView(tableView, cellForRowAt: indexPath)
      let expectedCellText = notes[row].summary
      let actualCellText = cell.textLabel?.text
      XCTAssertEqual(expectedCellText, actualCellText)
    }
  }


  func test_prepareForSegue_editNote_configuresEditorModuleWithSelectedNoteID() {
    // Arrange.
    let notes = [
      ListViewNote(id: "zero", summary: "sample note"),
      ListViewNote(id: "one", summary: "another sample note")
    ]
    let list = ListViewList(notes: notes, selected: nil)
    sut.update(list: list)

    let indexPath = IndexPath(row: 1, section: 0)
    tableView.stub(indexPath: indexPath, forSelectedRow: 1)

    let editorViewController = EditorViewController()
    let segue = UIStoryboardSegue(identifier: "editNote", source: sut, destination: editorViewController)

    // Act.
    sut.prepare(for: segue, sender: nil)

    // Assert.
    guard let interactor = editorViewController.interactor as? EditorInteractor else {
        XCTFail()
        return
    }
    XCTAssertEqual(interactor.noteID, "one")
  }
}
