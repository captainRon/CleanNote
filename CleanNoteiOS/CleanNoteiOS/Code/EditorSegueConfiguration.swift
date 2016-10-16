import UIKit
import CleanNoteCore

extension EditorViewController: Segueable {
    func accept(visitor: StoryboardViewControllerVisitor){
        visitor.process(self)
    }
}

extension StoryboardSegueCoordinator {
    
    internal func process(_ viewController: EditorViewController) {
        guard let source = segue.source as? NoteDataSource else { return }
        configure(editorViewController: viewController, noteGateway: source.noteGateway, noteID: source.noteID(for: sender))
    }
    
    func configure(editorViewController: EditorViewController, noteGateway: NoteGateway, noteID: NoteID) {
        let editorPresenter = EditorPresenter(interface: editorViewController)
        let editorInteractor = EditorInteractor(output: editorPresenter, gateway: noteGateway, noteID: noteID)
        editorViewController.interactor = editorInteractor
    }
    
}
