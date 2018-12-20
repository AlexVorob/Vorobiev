//
//  CarWashingService.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class CarWashingService {
    
    private let washerManager: StaffManager<Washer, Car>
    private let accountantManager: StaffManager<Accountant, Washer>
    private let directorManager: StaffManager<Director, Accountant>
    
    init(
        accountant: Accountant,
        director: Director,
        washersAvailable: [Washer]
    ) {
        self.washerManager = StaffManager(person: washersAvailable)
        self.accountantManager = StaffManager(person: accountant)
        self.directorManager = StaffManager(person: director)
        self.setObservers()
    }
    
    func wash(car: Car) {
        self.washerManager.doWork(object: car)
    }
    
    private func setObservers() {
        self.washerManager.observer(handler: self.accountantManager.doWork)
        self.accountantManager.observer(handler: self.directorManager.doWork)
    }
}
