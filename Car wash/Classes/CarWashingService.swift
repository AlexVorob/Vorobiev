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
    
    private var managerObservers = CompositeCancellableProperty()
    
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
        self.washerManager.performStaffWork(processObject: car)
    }
    
    private func setObservers() {
        let washerManagerObserver = self.washerManager.observer(handler: self.accountantManager.performStaffWork)
        let accountantManagerObserver = self.accountantManager.observer(handler: self.directorManager.performStaffWork)
        
        self.managerObservers.value = [washerManagerObserver, accountantManagerObserver]
    }
}
