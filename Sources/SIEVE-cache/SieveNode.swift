import Foundation

class SieveNode<Key, Value> {
    let key: Key
    let value: Value
    var visited = false
    var previous: SieveNode?
    var next: SieveNode?
    
    init(key: Key, value: Value) {
        self.key = key
        self.value = value
    }
}
