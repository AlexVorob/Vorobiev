//
//  CarWashingService.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class CarWashingService {
    
    private var staffObservers = [Observer]()

    private let accountant: Accountant
    private let director: Director
    private let washers: Atomic<[Washer]>
    private let cars = Queue<Car>()
    
    deinit {
        self.staffObservers.forEach {
            $0.cancel()
        }
    }
    
    init(
        accountant: Accountant,
        director: Director,
        washersAvailable: [Washer]
    ) {
        self.accountant = accountant
        self.director = director
        self.washers = Atomic(washersAvailable)
        self.initializationObservers()
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
    
    private func initializationObservers() {
        self.washers.value.forEach { washer in
            let observer = washer.observer { [weak washer, weak self] in
                switch $0 {
                case .available: self?.cars.dequeue().apply(washer?.doAsyncWork)
                case .busy: return
                case .waitForProcessing: washer.apply(self?.accountant.doAsyncWork)
                }
            }
            self.staffObservers.append(observer)
        }
        
        self.staffObservers.append(self.accountant.observer { [weak self] in
            switch $0 {
            case .available: self?.accountant.processQueue()
            case .busy: return
            case .waitForProcessing: (self?.accountant).apply(self?.director.doAsyncWork)
            }
        })
        
        self.staffObservers.append(self.director.observer {
            switch $0 {
            case .available: return
            case .busy: return
            case .waitForProcessing: return
            }
        })
    }
}
