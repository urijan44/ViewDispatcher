//
//  StateSignal.swift
//
//
//  Created by hoseung Lee on 4/3/24.
//

import Foundation
import Combine

@dynamicMemberLookup
public struct StateSignal<State: ViewState> {
  private let signalPublisher: CurrentValueSubject<[String: Any], Never>
  private let state: State
  public func send<T>(_ keyPath: KeyPath<State, T>, value: T) {
    let key = String(describing: keyPath.self)
    signalPublisher.send([key: value])
  }
  
  public subscript<V>(dynamicMember member: KeyPath<State, V>) -> AnyPublisher<V, Never> {
    signalPublisher
      .receive(on: DispatchQueue.main)
      .compactMap { dictionary in
        let key = String(describing: member.self)
        return dictionary[key] as? V
      }
      .eraseToAnyPublisher()
      
  }
  
  public init(state: State) {
    self.state = state
    
    let keyPathSet = (Mirror(reflecting: state).children).reduce(into: [String: Any]()) { partialResult, child in
      guard let label = child.label else { return }
      partialResult["\\StateImpl.\(label)"] = child.value
    }
    self.signalPublisher = CurrentValueSubject(keyPathSet)
  }
}
