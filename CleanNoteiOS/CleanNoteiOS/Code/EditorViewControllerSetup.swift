import UIKit
import CleanNoteCore


extension StoryboardSegueCoordinator {
    
    internal func process(_ viewController: EditorViewController) {
        guard let source = segue.source as? EditorViewControllerSource else { return }
        prepare(editorViewController: viewController, noteGateway: source.noteGateway, noteID: source.noteID(for: sender))
    }
    
    private func prepare(editorViewController: EditorViewController, noteGateway: NoteGateway, noteID: NoteID) {
        let editorPresenter = EditorPresenter(interface: editorViewController)
        let editorInteractor = EditorInteractor(output: editorPresenter, gateway: noteGateway, noteID: noteID)
        editorViewController.interactor = editorInteractor
    }
    
}
