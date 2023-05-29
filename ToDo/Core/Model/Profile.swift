import Foundation
import RealmSwift

class Profile : Object {
    @objc dynamic var background : NSData = NSData()
    @objc dynamic var profile : NSData =  NSData()
    @objc dynamic var Sender = ""    
}
