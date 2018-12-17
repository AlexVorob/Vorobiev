//
//  Person.swift
//  Car wash
//
//  Created by Student on 12/11/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Person: ObservableObject<Person.ProcessingState>, MoneyReceiver, MoneyGiver, Statable {
    
    enum ProcessingState {
        case busy
        case waitForProcessing
        case available
    }
    
    var state: ProcessingState {
        get { return atomicState.value }
        set { self.atomicState.value = newValue }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    let atomicState = Atomic(ProcessingState.available)
    
    private let atomicMoney = Atomic(0)
    
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
}
