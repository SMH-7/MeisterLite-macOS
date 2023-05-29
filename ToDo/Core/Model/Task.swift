import Foundation
import RealmSwift

class  Task : Object , Codable{
    @objc dynamic var TaskTitle : String = ""
    @objc dynamic var TaskSender : String = ""
}
