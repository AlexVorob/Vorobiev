//
//  Car.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Car: MoneyGiver {
    
    enum State {
        case clean
        case dirty
    }
    
    let state = Atomic(State.dirty)
    let name: String
    
    private let money = Atomic(0)
    
    init(money: Int, name: String) {
        self.money.value = money
        self.name = name
    }
    
    func giveMoney() -> Int {
        return self.money.modify { money in
            defer { money = 0 }
            
            return money
        }
    }
}
