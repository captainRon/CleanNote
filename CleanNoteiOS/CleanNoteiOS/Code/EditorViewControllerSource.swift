import CleanNoteCore

protocol EditorViewControllerSource {
    func noteID(for sender:Any?) -> String
    var noteGateway: NoteGateway! { get set }
}
