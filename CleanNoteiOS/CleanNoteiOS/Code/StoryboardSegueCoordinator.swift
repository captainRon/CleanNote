import UIKit

protocol SegueableViewController {
    func accept(visitor: StoryboardViewControllerVisitor)
}

struct StoryboardSegueCoordinator: StoryboardViewControllerVisitor {
    
    let segue: UIStoryboardSegue
    let sender: Any?
    
    func prepare() {
        guard let destination = segue.destination as? SegueableViewController else { return }
        destination.accept(visitor: self)
    }
    
}



