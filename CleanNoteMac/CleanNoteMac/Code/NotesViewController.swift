import Cocoa
import CleanNoteCore

class NotesViewController: NSSplitViewController {

  var listWireframe: ListWireframe!
  var editorWireframe: EditorWireframe!

  var listViewController: ListViewController!
  var editorViewController: EditorViewController!

  var listInteractor: ListInteractorInput?
  var editorInteractor: EditorInteractorInput?

  override func viewDidLoad() {
    enableRoundWindowCorners()
    configureChildrenControllers()
    configureDelegates()
    super.viewDidLoad()
  }
  
  private func enableRoundWindowCorners() {
    view.wantsLayer = true
  }

  private func configureChildrenControllers() {
    listViewController = childViewControllers[0] as! ListViewController
    editorViewController = childViewControllers[1] as! EditorViewController
  }

  private func configureDelegates() {
    listViewController.delegate = self
    editorViewController.delegate = self
  }

  func start() {
    configureList()
    editorViewController.showNoNoteScreen()
    listInteractor?.fetchNotesAndSelect(noteID: nil)
  }

  private func configureList() {
    listInteractor = listWireframe.configure(listViewController: listViewController)
  }

  @IBAction func newNote(_ sender: AnyObject) {
    editorViewController.prepareForEditing()
    listInteractor?.makeNote()
  }
}

extension NotesViewController: ListViewControllerDelegate {
  func didSelect(noteID: NoteID) {
    configureEditor(noteID: noteID)
    editorViewController.showNoteScreen()
    editorInteractor?.fetchText()
    listInteractor?.fetchNotesAndSelect(noteID: noteID)
  }

  private func configureEditor(noteID: NoteID) {
    editorInteractor = editorWireframe.configure(editorViewController: editorViewController, noteID: noteID)
  }

  func didDeselectAllNotes() {
    listInteractor?.fetchNotesAndSelect(noteID: nil)
    editorInteractor = nil
    editorViewController.showNoNoteScreen()
  }
}

extension NotesViewController: EditorViewControllerDelegate {
  func didModify(text: String) {
    editorInteractor?.save(text: text)
  }

  func didSaveText(for noteID: NoteID) {
    listInteractor?.fetchNotesAndSelect(noteID: noteID)
  }
}
