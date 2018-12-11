//
//  Washer.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Washer: Staff<Car> {
    
    override func process(object: Car) {
        object.state.value = .clean
    }
    
    override func completeProcessing(object: Car) {
        print("\(object.name) was washed!")
        self.receiveMoney(from: object)
    }
    
    override func finishProcessing() {
        print("\(self.name) take money from Car - \(self.money)")
        super.finishProcessing()
    }
}
