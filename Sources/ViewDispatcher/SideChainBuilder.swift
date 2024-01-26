//
//  SideChainBuilder.swift
//
//
//  Created by henry.lee on 12/11/23.
//

import Foundation

@resultBuilder
public struct SideChainBuilder<T: ChainSendable> {
    public static func buildBlock(_ components: T...) -> [T] {
        components
    }

    public static func buildBlock(_ components: [T]...) -> [T] {
        components.flatMap { $0 }
    }
    
    public static func buildBlock(_ components: [T]) -> [T] {
        components
    }
    
}

public struct Chains<T: ChainSendable>: Sequence {

    private var chains: [T]
    
    public init(@SideChainBuilder<T> _ chains: () -> [T]) {
        self.chains = chains()
    }
    
    public func makeIterator() -> ChainsIterator<T> {
        ChainsIterator(chains: chains)
    }
    
    @discardableResult
    public func taskWithReturn(action: @escaping (T) async -> T) async -> [T] {
        var stream: [T] = []
        for chain in chains {
            stream.append(await action(chain))
        }
        return stream
    }
    
    public func task(action: @escaping (T) async -> Void) async {
        for chain in chains {
            await action(chain)
        }
    }
    
    @discardableResult
    mutating
    public func concate(@SideChainBuilder<T> _ chains: () -> [T]) -> Self {
        self.chains += chains()
        return self
    }
}

public protocol ChainSendable {}

public struct ChainsIterator<T>: IteratorProtocol {
    public typealias Element = T
    private var currentIndex = 0
    private let chains: [T]

    init(chains: [T]) {
        self.chains = chains
    }

    public mutating func next() -> T? {
        guard currentIndex < chains.count else { return nil }
        let currentChain = chains[currentIndex]
        currentIndex += 1
        return currentChain
    }
}

