//
//  Staff.swift
//  Car wash
//
//  Created by Student on 26/10/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: MoneyReceiver, MoneyGiver, Statable {
    
   public class Observer {
        
        public typealias Handler = (ProcessingState) -> ()
        
        public var isObserving: Bool {
            return self.sender != nil
        }
        
        fileprivate let handler: Handler
        private weak var sender: Staff?
        
        public init(sender: Staff, handler: @escaping Handler) {
            self.sender = sender
            self.handler = handler
        }
    
        public func cancel() {
            self.sender = nil
        }
    
        
    }
    
    enum ProcessingState {
        case busy
        case waitForProcessing
        case available
    }
    
    var state: ProcessingState {
        get { return atomicState.value }
        set {
            self.atomicState.modify {
                $0 = newValue
                self.notify(state: newValue)
            }
//            switch newValue {
//            case .available:
//                if self.countQueueObjects != 0 {
//                    self.queueObjects.dequeue().do(self.doAsyncWork)
//                } else {
//                    self.observer?.processStateAvailable(sender: self)
//                }
//            case .busy: break
//            case .waitForProcessing: self.observer?.processStateWaitForProcessing(sender: self)
//            }
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    public var countQueueObjects: Int {
        return self.queueObjects.count
    }
    
    let name: String
    let queueObjects = Queue<ProcessedObject>()
    
    private let atomicObservers = Atomic([Observer]())
    private let atomicState = Atomic(ProcessingState.available)
    private let atomicMoney = Atomic(0)
    private let queue: DispatchQueue
    
    init (
        money: Int,
        name: String,
        queue: DispatchQueue = .background
    ) {
        self.atomicMoney.value = money
        self.name = name
        self.queue = queue
    }
    
    func observer(handler: @escaping Observer.Handler) -> Observer {
        return self.atomicObservers.modify {
            let observer = Observer(sender: self, handler: handler)
            $0.append(observer)
            observer.handler(self.state)
            
            return observer
        }
    }
    
    private func notify(state: ProcessingState) {
        self.atomicObservers.modify {
            $0 = $0.filter { !$0.isObserving }
            $0.forEach { $0.handler(state) }
        }
    }
    
//    func cornerCase() {
//        if self.countQueueObjects != 0 {
//            self.queueObjects.dequeue().do(self.doAsyncWork)
//        } else {
//            self.observer?.processStateAvailable(sender: self)
//        }
//    }
    
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
        // reapiting func
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
}
