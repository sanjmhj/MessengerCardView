import UIKit

class Person {
    var name: String = "Unamed"
    var image: UIImage //= UIImage(named: "Default")!
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}