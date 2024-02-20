public final class SieveCache<Key: Hashable, Value> {
    private var cache: [Key: SieveNode<Key, Value>]
    private var hand: SieveNode<Key, Value>?
    private var head: SieveNode<Key, Value>?
    private var tail: SieveNode<Key, Value>?

    /// The maximum number of objects the cache should hold.
    ///
    /// The default value is 1000.
    public var countLimit: Int
    
    /// Is the cache empty?
    public var isEmpty: Bool { cache.isEmpty }
    
    /// Initialize a SieveCache with a specified ``countLimit``
    /// - Parameter countLimit: The maximum number of objects the cache should hold. The default value is 1000.
    public init(countLimit: Int = 1000) {
        self.countLimit = countLimit
        self.cache = [Key: SieveNode<Key, Value>]()
    }
    
    /// Returns the value associated with a given key.
    /// - Parameter key: An object identifying the value.
    /// - Returns: The value associated with key, or `nil` if no value is associated with key.
    public func object(forKey key: Key) -> Value? {
        access(key: key)
    }
    
    /// Sets the value of the specified key in the cache.
    /// - Parameters:
    ///   - object: The object to be stored in the cache.
    ///   - key: The key with which to associate the value.
    public func setObject(_ object: Value?, forKey key: Key) {
        guard let object else {
            removeObject(forKey: key)
            return
        }
        
        insert(key: key, value: object)
    }
    
    /// Removes the value of the specified key in the cache.
    /// - Parameter key: The key identifying the value to be removed.
    /// - Returns: The value associated with key, or `nil` if no value is associated with key.
    @discardableResult public func removeObject(forKey key: Key) -> Value? {
        guard let node = cache.removeValue(forKey: key) else {
            return nil
        }
        
        return node.value
    }
    
    /// Empties the cache.
    public func removeAllObjects() {
        cache.removeAll()
        hand = nil
        head = nil
        tail = nil
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
        if count == countLimit {
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
    
    // The number of objects currently in the cache
    var count: Int { cache.count }
}
