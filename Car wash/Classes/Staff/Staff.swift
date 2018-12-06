//
//  Staff.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: MoneyReceiver, MoneyGiver, Statable, Observable {
    
    enum ProcessingState {
        case busy
        case waitForProcessing
        case available
    }
    
    var state: ProcessingState {
        get { return atomicState.value }
        set {
            self.atomicState.value = newValue
            switch newValue {
            case .available:
                if self.countQueueObjects != 0 {
                    self.queueObjects.dequeue().do(self.doAsyncWork)
                } else {
                    self.observer?.processStateAvailable(sender: self)
                }
            case .busy: break
            case .waitForProcessing: self.observer?.processStateWaitForProcessing(sender: self)
            }
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    public var countQueueObjects: Int {
        return self.queueObjects.count
    }
    
    weak var observer: Observer?
    
    let name: String
    let queueObjects = Queue<ProcessedObject>()
    
    private let atomicState = Atomic(ProcessingState.available)
    private let atomicMoney = Atomic(0)
    private let queue: DispatchQueue
    
    init (
        money: Int,
        name: String,
        queue: DispatchQueue
    ) {
        self.atomicMoney.value = money
        self.name = name
        self.queue = queue
    }
    
    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }
            
            return money
        }
    }
    
    func receive(money: Int) {
        self.atomicMoney.modify {
            $0 += money
        }
    }

    func process(object: ProcessedObject) {
        
    }
    
    func completeProcessing(object: ProcessedObject) {
        
    }
    
    func finishProcessing() {
        self.queueObjects.dequeue().do(self.asyncWork)
    }

    func doAsyncWork(object: ProcessedObject) {
        self.atomicState.transform { objectState in
            if objectState == .available {
                self.state = .busy
                self.asyncWork(object: object)
            } else {
                self.queueObjects.enqueue(value: object)
            }
        }
    }
    
    private func asyncWork(object: ProcessedObject) {
        self.queue.asyncAfter(deadline: .after(interval: .random(in: 0.0...1.0))) {
            self.process(object: object)
            self.completeProcessing(object: object)
            self.finishProcessing()
        }
    }
    
    func addObserver(observer: Observer) {
        self.observer = observer
    }
    
    func deleteObserver() {
        self.observer = nil
    }
}
