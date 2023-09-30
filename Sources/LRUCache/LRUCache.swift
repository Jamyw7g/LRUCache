// The Swift Programming Language
// https://docs.swift.org/swift-book

/// An LRU cahce implement.
public final class LRUCache<Key: Hashable, Val> {
    private var map: [Key: Entry] = [:]
    private var head: Entry?
    private var tail: Entry?
    
    public let cap: Int
    
    /// Init with capacity, if cap <= 0 will init fail.
    public init?(cap: Int) {
        if cap <= 0 {
            return nil
        }
        self.cap = cap
        self.head = Entry()
        self.tail = Entry()
        
        self.head?.next = self.tail
        self.tail?.prev = self.head
    }
}

public extension LRUCache {
    /// Return how many count store in cache.
    var count: Int {
        self.map.count
    }
    
    /// Return unordered values.
    var values: [Val?] {
        self.map.values.map { $0.val }
    }
    
    /// Return unordered keys.
    var keys: [Key] {
        Array(self.map.keys)
    }
    
    /// Return ordered values.
    var orderedValues: [Val?] {
        var res = [Val?]()
        var next = self.head?.next
        while next !== self.tail {
            res.append(next?.val)
            next = next?.next
        }
        return res
    }
    
    /// Return ordered keys.
    var orderedKeys: [Key] {
        var res = [Key]()
        var next = self.head?.next
        while next !== self.tail {
            if let key = next?.key {
                res.append(key)
            }
            next = next?.next
        }
        return res
    }
    
    /// Put new value(nil) into cache with key.
    func put(_ val: Val?, forKey key: Key) {
        if let entry = self.map[key] {
            entry.val = val
            detach(entry)
            attachToHead(entry)
        } else {
            let entry: Entry
            if self.map.count >= self.cap {
                entry = popLast()!
                entry.key = key
                entry.val = val
            } else {
                entry = Entry(key: key, val: val)
            }
            self.map[key] = entry
            attachToHead(entry)
        }
    }
    
    /// Pop a value(nil) for key.
    @discardableResult
    func pop(forKey key: Key) -> Val? {
        guard let entry = self.map.removeValue(forKey: key) else {
            return nil
        }
        detach(entry)
        return entry.val
    }
    
    /// Get value from the cache.
    func get(forKey key: Key) -> Val? {
        guard let entry = self.map[key] else {
            return nil
        }
        detach(entry)
        attachToHead(entry)
        return entry.val
    }
    
    /// Make the key to the first.
    func touch(forKey key: Key) {
        if let entry = self.map[key] {
            detach(entry)
            attachToHead(entry)
        }
    }
    
    /// Using subscript syntax to set or get value.
    subscript(key: Key) -> Val? {
        get {
            get(forKey: key)
        }
        set {
            put(newValue, forKey: key)
        }
    }
    
    /// Remove some elements from the cahce. keepCapacity == true to
    /// keep capacity, default is false.
    func remove(some num: Int, keepingCapacity keepCapacity: Bool = false) {
        if num >= self.map.count {
            removeAll(keepingCapacity: keepCapacity)
        } else {
            var deleted = 0
            while deleted < num {
                popLast()
                deleted += 1
            }
            if !keepCapacity {
                self.map.reserveCapacity(self.map.count)
            }
        }
    }
    
    /// Remove all elements from the cahce. keepCapacity == true to
    /// keep capacity, default is false.
    func removeAll(keepingCapacity keepCapacity: Bool = false) {
        self.map.removeAll(keepingCapacity: keepCapacity)
        self.head?.next = self.tail
        self.tail?.prev = self.head
    }
}

private extension LRUCache {
    @discardableResult
    func popLast() -> Entry? {
        let prev = self.tail?.prev
        guard prev !== self.head else {
            return nil
        }
        let oldKey = prev?.key
        let oldEntry = self.map.removeValue(forKey: oldKey!)
        detach(oldEntry!)
        return oldEntry
    }
    
    func attachToHead(_ node: Entry) {
        node.next = self.head?.next
        node.prev = self.head
        self.head?.next = node
        node.next?.prev = node
    }
    
    func detach(_ node: Entry) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
    }
}

private extension LRUCache {
    final class Entry {
        var key: Key?
        var val: Val?
        unowned var prev: Entry?
        unowned var next: Entry?
        
        // For uninit values.
        init() {
        }
        
        // Init with known value, the value can be nil.
        init(key: Key, val: Val?) {
            self.key = key
            self.val = val
        }
    }
}
