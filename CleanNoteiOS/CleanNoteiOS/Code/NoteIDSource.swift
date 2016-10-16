import CleanNoteCore

protocol NoteDataSource {
    func noteID(for sender:Any?) -> String
    var noteGateway: NoteGateway! { get set }
}
