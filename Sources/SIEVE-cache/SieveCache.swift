// https://cachemon.github.io/SIEVE-website/blog/2023/12/17/sieve-is-simpler-than-lru/

public final class SieveCache<Key: Hashable, Value> {
    private let capacity: Int
    private var cache = [Key: SieveNode<Key, Value>]()
    private var head: SieveNode<Key, Value>?
    private var tail: SieveNode<Key, Value>?
    private var hand: SieveNode<Key, Value>?
    var size: Int { cache.count }

    public init(capacity: Int = Int.max) {
        self.capacity = capacity
    }
    
    public func value(forKey key: Key) -> Value? {
        guard cache[key] != nil else { return nil }

        // Cache hit
        return access(key: key)
    }
    
    public func setValue(_ value: Value?, forKey key: Key) {
        guard let value else {
            removeValue(forKey: key)
            return
        }
        
        insert(key: key, value: value)
    }
    
    @discardableResult public func removeValue(forKey key: Key) -> Value? {
        guard let node = cache.removeValue(forKey: key) else {
            return nil
        }
        
        return node.value
    }
    
    private func access(key: Key) -> Value? {
        guard let node = cache[key] else { return nil }

        // Cache hit
        node.visited = true
        return node.value
    }
    
    private func insert(key: Key, value: Value) {
        guard cache[key] == nil else { return }
        
        // Cache miss
        if size == capacity {
            // Cache full
            evict(key)
        }
        let newNode = SieveNode(key: key, value: value)
        addToHead(newNode)
        cache[key] = newNode
    }
    
    private func addToHead(_ node: SieveNode<Key, Value>) {
        node.next = head
        if let head {
            head.previous = node
        }
        head = node
        if tail == nil {
            tail = node
        }
    }
    
    private func removeNode(_ node: SieveNode<Key, Value>) {
        if node.previous != nil {
            node.previous?.next = node.next
        } else {
            head = node.next
        }
        if node.next != nil {
            node.next?.previous = node.previous
        } else {
            tail = node.previous
        }
    }
    
    private func evict(_ key: Key) {
        guard var obj = if hand != nil { hand } else { tail } else { return }
        
        while obj.visited {
            obj.visited = false
            obj = if obj.previous != nil { obj.previous! } else { tail! }
        }
        
        hand = obj.previous
        removeNode(obj)
        cache[obj.key] = nil
    }
    
    var status: String {
        var s = ""
        var current = head
        while current != nil {
            s += "\(current!.value) (Visited: \(current!.visited))"
            s += current!.next != nil ? " -> " :  "\n"
            current = current?.next
        }
        return s
    }
}
