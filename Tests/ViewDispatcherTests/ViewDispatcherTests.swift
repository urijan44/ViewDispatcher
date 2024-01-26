import XCTest
@testable import ViewDispatcher
import Combine

final class ViewDispatcherTests: XCTestCase {
    
    struct SomeState: Equatable {
        
        var value1: Int
        var value2: Int
        var value3: Int
        
    }
    private var cancelablles: Set<AnyCancellable> = []
    func testExample() throws {
        
        var state = SomeState(value1: 0, value2: 0, value3: 0)
        
        let publisher = CurrentValueSubject<SomeState, Never>(state)
        let exp = expectation(description: "")
        exp.expectedFulfillmentCount = 2
        publisher
            .map(\.value1)
            .pulse
            .sink { state in
                print(state)
                exp.fulfill()
            }
            .store(in: &cancelablles)
        
        
        state.value2 = 1
        publisher.send(state)
        state.value3 = 1
        publisher.send(state)
        state.value1 = 1
        publisher.send(state)
        
        wait(for: [exp])
    }
}
