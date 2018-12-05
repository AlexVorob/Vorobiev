//
//  MoneyReciver.swift
//  Car wash
//
//  Created by Student on 10/23/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol MoneyReceiver {
    
    func receive(money: Int)
}

extension MoneyReceiver {
    
    func receiveMoney(from moneyGiver: MoneyGiver) {
        self.receive(money: moneyGiver.giveMoney())
    }
}
