//
//  SafeSet.swift
//  EddystoneScanner
//
//  Created by Amit Prabhu on 11/01/18.
//  Copyright © 2018 Amit Prabhu. All rights reserved.
//

import Foundation

///
/// Safe Set
///
/// Thread safe generic set class in swift
/// Methods and properties are similar to that of the generic Set class
/// Example: let a = SafeSet<String>(identifier: "a")
///
public class SafeSet<E: Hashable> {
    private let queue: DispatchQueue
    private var set: Set<E> = []
    var index: Set<E>.Index
    
    public init(identifier: String) {
        queue = DispatchQueue(label: "com.safeset.\(Date().timeIntervalSince1970).\(identifier)", attributes: .concurrent)
        index = set.startIndex
    }
    
    public subscript(index: Set<E>.Index) -> E? {
        get {
            return queue.sync {
                guard index < set.endIndex else {
                    return nil
                }
                return set[index]
            }
        }
    }
}

extension SafeSet {
    // MARK: Mutable methods
    public func insert(_ newMember: E) {
        queue.async(flags: .barrier) {
            self.set.insert(newMember)
        }
    }
    
    public func remove(_ member: E) {
        queue.async(flags: .barrier) {
            self.set.remove(member)
        }
    }
    
    public func update(with member: E) {
        queue.async(flags: .barrier) {
            let _ = self.set.update(with: member)
        }
    }
    
    public func filterInPlace(_ isIncluded: @escaping (E) -> Bool) {
        queue.async(flags: .barrier) {
            let originalSet = self.set
            self.set = Set<E>()
            
            for member in originalSet {
                if isIncluded(member) {
                    self.set.insert(member)
                }
            }
        }
    }
    
    public func removeAll() {
        queue.async(flags: .barrier) {
            self.set.removeAll()
        }
    }
    
    public func subtract(_ other: SafeSet<E>) {
        queue.async(flags: .barrier) {
            self.set = self.set.subtracting(other.set)
        }
    }
    
    public func union(_ safeSet: SafeSet<E>) {
        queue.async(flags: .barrier) {
            for element in safeSet.getSet() {
                self.set.insert(element)
            }
        }
    }
}

extension SafeSet: Sequence {
    public func makeIterator() -> SafeSetIterator<E> {
        return SafeSetIterator(Array(self.set))
    }
}

extension SafeSet {
    // MARK: Immutable properties
    public var isEmpty: Bool {
        get {
            return queue.sync {
                return set.isEmpty
            }
        }
    }
    
    public var count: Int {
        get {
            return queue.sync {
                return set.count
            }
        }
    }
    
    public var startIndex: Set<E>.Index {
        get {
            return queue.sync {
                return set.startIndex
            }
        }
    }
    
    public var endIndex: Set<E>.Index {
        get {
            return queue.sync {
                return set.endIndex
            }
        }
    }
    
    // MARK: Immutable methods
    public func getSet() -> Set<E> {
        return queue.sync {
            return set
        }
    }
    
    public func contains(_ member: E) -> Bool {
        return queue.sync {
            return set.contains(member)
        }
    }
    
    public func index(of member: E) -> Set<E>.Index? {
        return queue.sync {
            return set.firstIndex(of: member)
        }
    }
    
    public func first(where predicate: (E) throws -> Bool) rethrows -> E? {
        return try queue.sync {
            return try set.first(where: predicate)
        }
    }
}

public struct SafeSetIterator<E: Hashable>: IteratorProtocol {
    
    private let values: [E]
    private var index: Int?
    
    init(_ values: [E]) {
        self.values = values
    }
    
    private func nextIndex(for index: Int?) -> Int? {
        if let index = index, index < self.values.count - 1 {
            return index + 1
        }
        if index == nil, !self.values.isEmpty {
            return 0
        }
        return nil
    }
    
    mutating public func next() -> E? {
        if let index = self.nextIndex(for: self.index) {
            self.index = index
            return self.values[index]
        }
        return nil
    }
}
