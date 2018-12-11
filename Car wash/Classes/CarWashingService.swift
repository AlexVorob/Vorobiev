//
//  CarWashingService.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class CarWashingService {
    
    //private var allObservers:

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
        self.initialObserver()
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
    
//    func processStateWaitForProcessing<SenderObject>(sender: SenderObject) {
//        if let washer = sender as? Washer {
//            self.accountant.doAsyncWork(object: washer)
//        } else {
//            self.director.doAsyncWork(object: self.accountant)
//        }
//    }
//
//    func processStateAvailable<SenderObject>(sender: SenderObject) {
//        if let washer = sender as? Washer {
//            self.cars.dequeue().do(washer.doAsyncWork)
//        }
//    }
    
    private func initialObserver() {
        self.washers.value.forEach { washer in
            washer.observer { [weak self] in
                switch $0 {
                case .available: self?.cars.dequeue().apply(washer.doAsyncWork)
                case .busy: return
                case .waitForProcessing: self?.accountant.doAsyncWork(object: washer)
                }
            }
        }
        self.accountant.observer { [weak accountant, weak self] in
            switch $0 {
            case .available: return
            case .busy: return
            case .waitForProcessing: accountant.apply(self?.director.doAsyncWork)
            }
        }
        self.director.observer {
            switch $0 {
            case .available: return
            case .busy: return
            case .waitForProcessing: return
            }
        }
    }
}
