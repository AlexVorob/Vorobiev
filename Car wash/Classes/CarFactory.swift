//
//  CarFactory.swift
//  Car wash
//
//  Created by Student on 11/7/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class CarFactory {
    
    private let queue: DispatchQueue
    private let carCount = 10
    private let carWashingService: CarWashingService
    
    private var timerToken: DispatchQueue.TimerToken? {
        willSet { timerToken?.stop() }
    }
    
    var isTokenRunning: Bool {
        return self.timerToken?.isRunning ?? false
    }
    
    deinit {
        self.stop()
        print("deinit !!!!!!!")
    }
    
    init(carWashingService: CarWashingService, queue: DispatchQueue = .background) {
        self.carWashingService = carWashingService
        self.queue = queue
    }

    func timerTokenCarEmission() {
        self.timerToken = queue.timerToken(interval: 5.0) { [weak self] in
                self?.continueEmission()
            }
    }
    
    func stop() {
        self.timerToken = nil
    }

    private func continueEmission() {
        self.carCount.times {
            self.queue.async {
                self.carWashingService.wash(car: Car(money: 10, name: "Car"))
            }
        }
    }
}
