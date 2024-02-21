/// ``SieveCache`` is an open source replacement for ``NSCache`` that behaves in a predictable, debuggable way.
///
/// ``SieveCache`` is an implementation in Swift of the SIEVE cache explained [here](https://cachemon.github.io/SIEVE-website).
@available(swift 5.9)
public final class SieveCache<KeyType: Hashable, ObjectType> {
    private var cache: [KeyType: SieveNode<KeyType, ObjectType>]
    private var hand: SieveNode<KeyType, ObjectType>?
    private var head: SieveNode<KeyType, ObjectType>?
    private var tail: SieveNode<KeyType, ObjectType>?

    /// The maximum number of objects the cache should hold.
    ///
    /// The default value is 1000.
    public var countLimit: Int
    
    /// Is the cache empty?
    public var isEmpty: Bool { cache.isEmpty }
    
    /// Initialize a SieveCache with a specified ``countLimit``.
    /// - Parameter countLimit: The maximum number of objects the cache should hold. The default value is 1000.
    public init(countLimit: Int = 1000) {
        self.countLimit = countLimit
        self.cache = [KeyType: SieveNode<KeyType, ObjectType>]()
    }
    
    /// Returns the value associated with a given key.
    /// - Parameter key: An object identifying the value.
    /// - Returns: The value associated with key, or `nil` if no value is associated with key.
    public func object(forKey key: KeyType) -> ObjectType? {
        access(key: key)
    }
    
    /// Sets the value of the specified key in the cache.
    /// - Parameters:
    ///   - object: The object to be stored in the cache.
    ///   - key: The key with which to associate the value.
    public func setObject(_ object: ObjectType?, forKey key: KeyType) {
        guard let object else {
            removeObject(forKey: key)
            return
        }
        
        insert(key: key, value: object)
    }
    
    /// Removes the value of the specified key in the cache.
    /// - Parameter key: The key identifying the value to be removed.
    /// - Returns: The value associated with key, or `nil` if no value is associated with key.
    @discardableResult public func removeObject(forKey key: KeyType) -> ObjectType? {
        guard let node = cache.removeValue(forKey: key) else {
            return nil
        }
        
        return node.object
    }
    
    /// Empties the cache.
    public func removeAllObjects() {
        cache.removeAll()
        hand = nil
        head = nil
        tail = nil
    }
    
    private func access(key: KeyType) -> ObjectType? {
        guard let node = cache[key] else { return nil }

        // Cache hit
        node.visited = true
        return node.object
    }
    
    private func insert(key: KeyType, value: ObjectType) {
        guard cache[key] == nil else { return }
        
        // Cache miss
        if count == countLimit {
            // Cache full
            evict(key)
        }
        let newNode = SieveNode(key: key, object: value)
        addToHead(newNode)
        cache[key] = newNode
    }
    
    private func addToHead(_ node: SieveNode<KeyType, ObjectType>) {
        node.next = head
        if let head {
            head.previous = node
        }
        head = node
        if tail == nil {
            tail = node
        }
    }
    
    private func removeNode(_ node: SieveNode<KeyType, ObjectType>) {
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
    
    private func evict(_ key: KeyType) {
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
