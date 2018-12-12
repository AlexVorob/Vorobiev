//
//  Person.swift
//  Car wash
//
//  Created by Student on 12/11/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Person: MoneyReceiver, MoneyGiver, Statable {
    
    enum ProcessingState {
        case busy
        case waitForProcessing
        case available
    }
    
    var state: ProcessingState {
        get { return atomicState.value }
        set {
            guard self.state != newValue else { return }
            self.atomicState.value = newValue
            self.notify(state: newValue)
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    let atomicState = Atomic(ProcessingState.available)
    
    private let atomicMoney = Atomic(0)
    private let atomicObservers = Atomic([Observer]())
    
    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }
            
            return money
        }
    }
    
    func receive(money: Int) {
        self.atomicMoney.modify {
            $0 += money
        }
    }
    
    func observer(handler: @escaping Observer.Handler) -> Observer {
        return self.atomicObservers.modify {
            let observer = Observer(sender: self, handler: handler)
            $0.append(observer)
            observer.handler(self.state)
            
            return observer
        }
    }
    
    private func notify(state: ProcessingState) {
        self.atomicObservers.modify {
            $0 = $0.filter { $0.isObserving }
            $0.forEach { $0.handler(state) }
        }
    }
}
