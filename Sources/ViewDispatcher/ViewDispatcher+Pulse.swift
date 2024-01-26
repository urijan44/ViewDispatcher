//
//  ViewDispatcher+Pulse.swift
//
//
//  Created by henry.lee on 12/11/23.
//

import Combine

public extension Publisher where Self.Failure == Never, Self.Output: Equatable {
    var pulse: AnyPublisher<Output, Failure> {
        scan((Output?.none, 0)) { previous, current in
            let (previousValue, previousCount) = previous
            return (current, (previousValue == current ? previousCount : previousCount + 1))
        }
        .removeDuplicates { $0.1 == $1.1 }
        .map(\.0)
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
}
