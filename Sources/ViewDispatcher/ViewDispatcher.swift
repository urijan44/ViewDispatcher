//
//  ViewDispatcher.swift
//
//
//  Created by henry.lee on 12/11/23.
//

import Combine

public protocol ViewAction {}

public protocol ActionCaster {
    associatedtype Mutation
    func sendAction<ViewAction>(_ action: ViewAction) async
    func reduce(_ mutation: Mutation) async
}

public protocol ViewStateable {
    var currentState: ViewState { get }
}

public protocol ViewState {}

public extension ViewStateable {}

public protocol ViewDispatcher: ActionCaster, ViewStateable, AnyObject {
    var statePublisher: CurrentValueSubject<ViewState, Never> { get }
}
