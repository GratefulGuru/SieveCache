import Foundation

final class SieveNode<KeyType, ObjectType> {
    let key: KeyType
    let object: ObjectType
    var visited = false
    var previous: SieveNode?
    var next: SieveNode?
    
    init(key: KeyType, object: ObjectType) {
        self.key = key
        self.object = object
    }
}
