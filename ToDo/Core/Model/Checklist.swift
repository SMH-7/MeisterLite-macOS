import Foundation
import RealmSwift

class Checklist : Object , Codable {
    @objc dynamic var CheckListTitle : String = ""
    @objc dynamic var CheckListSender : String = ""
    @objc dynamic var Check : Bool = false
}
