import UIKit

struct StoryboardSegueCoordinator: StoryboardViewControllerVisitor {
    
    let segue: UIStoryboardSegue
    let sender: Any?
    
    func prepare() {
        guard let destination = segue.destination as? VistableViewController else { return }
        destination.accept(visitor: self)
    }
    
}



