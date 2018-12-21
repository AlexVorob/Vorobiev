//
//  StaffManager.swift
//  Car wash
//
//  Created by Student on 12/19/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class StaffManager<Object: Staff<ProcessObject>, ProcessObject: MoneyGiver>: ObservableObject<Object> {
    
    private var countQueue: Int {
        return self.queueProcessObject.count
    }
    
    private var queueStaff = Atomic([Object]())
    private let queueProcessObject = Queue<ProcessObject>()
    private let staffObservers = Atomic([Person.Observer]())

    init(person: [Object]) {
        self.queueStaff.value = person
        super.init()
        self.setObservers()
    }
    
    convenience init(person: Object) {
        self.init(person: [person])
    }
    
    func doWork(object: ProcessObject) {
        self.queueStaff.transform {
            let availableObject = $0.first {
                $0.state == .available
            }
            
            let enqueueProcessingObject = { self.queueProcessObject.enqueue(value: object) }
            
            if self.countQueue == 0 {
                if let availableObject = availableObject {
                    availableObject.processObject(processObject: object)
                } else {
                    enqueueProcessingObject()
                }
            } else {
                enqueueProcessingObject()
            }
        }
    }
    
    private func setObservers() {
        self.staffObservers.value += self.queueStaff.value.map { object in
            let observer = object.observer { [weak object, weak self] state in
                DispatchQueue.background.async {
                    switch state {
                    case .available:
                        self?.queueProcessObject.dequeue().apply(object?.processObject)
                    case .busy: return
                    case .waitForProcessing:
                        //print("\(type(of: self)) - \(self!.countQueue)")
                        object.apply(self?.notify)
                    }
                }
            }

            return observer
        }
    }
}
