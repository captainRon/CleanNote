protocol StoryboardViewControllerVisitor {
    func process(_ viewController: EditorViewController)
    func process(_ viewController: ListViewController)
}

protocol VistableViewController {
    func accept(visitor: StoryboardViewControllerVisitor)
}

extension EditorViewController: VistableViewController {
    func accept(visitor: StoryboardViewControllerVisitor){
        visitor.process(self)
    }
}

extension ListViewController: VistableViewController {
    func accept(visitor: StoryboardViewControllerVisitor){
        visitor.process(self)
    }
}
