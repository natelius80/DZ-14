
import Foundation
import RealmSwift


class ToDoItem: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var done = false
}
