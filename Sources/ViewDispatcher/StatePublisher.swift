//
//  StatePublisher.swift
//
//
//  Created by hoseung Lee on 4/3/24.
//

import Foundation
import Combine

@propertyWrapper
public struct StatePublisher<State: ViewState> {
  private var statePublisher: CurrentValueSubject<ViewState, Never>
  public var wrappedValue: CurrentValueSubject<ViewState, Never> {
    get {
      statePublisher
    }
  }
  
  public var projectedValue: StateSignal<State>
  
  public init(wrappedValue: CurrentValueSubject<ViewState, Never>) {
    self.statePublisher = wrappedValue
    self.projectedValue = StateSignal(state: wrappedValue.value as! State)
  }

  @MainActor
  public func send<T>(_ keyPath: WritableKeyPath<State, T>, value: T) {
    var newState = wrappedValue.value as! State
    newState[keyPath: keyPath] = value
    projectedValue.send(keyPath, value: value)
    statePublisher.send(newState)
  }
}
