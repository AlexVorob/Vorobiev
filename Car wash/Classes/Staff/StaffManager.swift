//
//  StaffManager.swift
//  Car wash
//
//  Created by Student on 12/19/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class StaffManager<Process: Staff<ProcessObject>, ProcessObject: MoneyGiver>: ObservableObject<Process> {
    
    private var countQueue: Int {
        return self.processObjectsQueue.count
    }
    
    private let staffQueue = Atomic([Process]())
    private let processObjectsQueue = Queue<ProcessObject>()
    private let staffObservers = Atomic([Person.Observer]())

    init(person: [Process]) {
        self.staffQueue.value = person
        super.init()
        self.setObservers()
    }
    
    convenience init(person: Process) {
        self.init(person: [person])
    }
    
    func performStaffWork(processObject: ProcessObject) {
        self.staffQueue.transform {
            let availableObject = $0.first {
                $0.state == .available
            }
            
            let enqueueProcessingObject = { self.processObjectsQueue.enqueue(value: processObject) }
            
            if self.countQueue == 0 {
                if let availableObject = availableObject {
                    availableObject.processObject(processObject: processObject)
                } else {
                    enqueueProcessingObject()
                }
            } else {
                enqueueProcessingObject()
            }
        }
    }
    
    private func setObservers() {
        self.staffObservers.value += self.staffQueue.value.map { object in
            let observer = object.observer { [weak object, weak self] state in
                DispatchQueue.background.async {
                    switch state {
                    case .available:
                        self?.processObjectsQueue.dequeue().apply(object?.processObject)
                    case .busy: return
                    case .waitForProcessing:
                        object.apply(self?.notify)
                    }
                }
            }

            return observer
        }
    }
}
