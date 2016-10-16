import CleanNoteCore

class ListWireframe {
  func configure(listViewController: ListViewController, noteGateway: NoteGateway) {

    let listPresenter = ListPresenter(interface: listViewController)
    let listInteractor = ListInteractor(output: listPresenter, gateway: noteGateway)

    listViewController.interactor = listInteractor
    listViewController.noteGateway = noteGateway
  }
}
