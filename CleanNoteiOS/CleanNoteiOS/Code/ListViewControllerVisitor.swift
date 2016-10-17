import UIKit
import CleanNoteCore

extension ListViewController: SegueableViewController {
    func accept(visitor: StoryboardViewControllerVisitor){
        visitor.process(self)
    }
}

extension StoryboardSegueCoordinator {
    
    internal func process(_ viewController: ListViewController) {
       prepare(listViewController: viewController)
    }
    
    private func prepare(listViewController: ListViewController) {
        
        let noteGateway = makeRandomlyFailingGateway()
        
        let listPresenter = ListPresenter(interface: listViewController)
        let listInteractor = ListInteractor(output: listPresenter, gateway: noteGateway)
        
        listViewController.interactor = listInteractor
        listViewController.noteGateway = noteGateway
    }
    
    private func makeRandomlyFailingGateway() -> NoteGateway {
        let sampleNotes = makeSampleNotes()
        let inMemoryNoteGateway = InMemoryNoteGateway(notes: sampleNotes)
        
        let failureRate = UInt32(20)
        let randomNumberGenerator = UniformRandomNumberGenerator()
        let errorGenerator = RandomErrorGenerator(failOneIn: failureRate, randomNumberGenerator: randomNumberGenerator)
        return RandomlyFailingNoteGatewayDecorator(noteGateway: inMemoryNoteGateway, errorGenerator: errorGenerator)
    }
    
    private func makeSampleNotes() -> [Note] {
        let note1 = Note(id: "1", text: "Hello world")
        let note2 = Note(id: "2", text: "Goodbye cruel world")
        return [note1, note2]
    }

}
