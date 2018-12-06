//
//  CarWashingService.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class CarWashingService: Observer {

    private let accountant: Accountant
    private let director: Director
    private let washers: Atomic<[Washer]>
    private let cars = Queue<Car>()
    
    init(
        accountant: Accountant,
        director: Director,
        washersAvailable: [Washer]
    ) {
        self.accountant = accountant
        self.director = director
        self.washers = Atomic(washersAvailable)
        
        self.accountant.addObserver(observer: self)
        self.washers.value.forEach { washer in
            washer.addObserver(observer: self)
        }
    }
    
    func wash(car: Car) {
        self.washers.transform {
            let availableWasher = $0.first { $0.state == .available }
            if let washer = availableWasher {
                washer.doAsyncWork(object: car)
            } else {
                self.cars.enqueue(value: car)
            }
        }
    }
    
    func processStateWaitForProcessing<SenderObject>(sender: SenderObject) {
        if let washer = sender as? Washer {
            self.accountant.doAsyncWork(object: washer)
        } else {
            self.director.doAsyncWork(object: self.accountant)
        }
    }
    
    func processStateAvailable<SenderObject>(sender: SenderObject) {
        if let washer = sender as? Washer {
            self.cars.dequeue().do(washer.doAsyncWork)
        } else {
            if self.accountant.countQueueObjects != 0 {
                self.accountant.processingQueue()
            }
        }
    }
}
