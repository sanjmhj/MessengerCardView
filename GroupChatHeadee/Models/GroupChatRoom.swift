import UIKit

class GroupChatRoom {
    
    var title: String = "Group Chat"
    var lastOnline: String = "0"
    var personArray: [Person] = []
    
    init(title: String, lastOnline: String, personArray: [Person]) {
        self.title = title
        self.lastOnline = lastOnline
        self.personArray = personArray
    }

}
