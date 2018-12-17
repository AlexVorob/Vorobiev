//
//  CarWashingService.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class CarWashingService {
    
    private var staffObservers = Atomic([Person.Observer]())

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
                case .available: self?.executeAsync {
                    self?.cars.dequeue().apply(washer?.doAsyncWork) }
                case .busy: return
                case .waitForProcessing: self?.executeAsync {
                    washer.apply(self?.accountant.doAsyncWork) }
                }
            }
            self.staffObservers.value.append(observer)
        }
        
        let observer = self.accountant.observer { [weak self] in
            switch $0 {
            case .available: return
            case .busy: return
            case .waitForProcessing: self?.executeAsync {
                (self?.accountant).apply(self?.director.doAsyncWork) }
            }
        }
        self.staffObservers.value.append(observer)
    }
    
    private func executeAsync(execute: @escaping F.Execute) {
        DispatchQueue.background.async {
            execute()
        }
    }
}

public struct Weak<Wrapped: AnyObject> {
    
    private(set) weak var value: Wrapped?
    
    public init(_ value: Wrapped) {
        self.value = value
    }
}

@discardableResult
public func weakify<Wrapped: AnyObject>(_ value: Wrapped) -> Weak<Wrapped> {
    return weakify(value) { _ in }
}

@discardableResult
public func weakify<Wrapped: AnyObject>(_ value: Wrapped, execute: (Weak<Wrapped>) -> ()) -> Weak<Wrapped> {
    let weak = Weak(value)
    execute(weak)
    
    return weak
}
