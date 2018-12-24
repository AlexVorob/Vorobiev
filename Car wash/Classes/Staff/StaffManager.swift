//
//  StaffManager.swift
//  Car wash
//
//  Created by Student on 12/19/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class StaffManager<Object: Staff<ProcessingObject>, ProcessingObject: MoneyGiver>: ObservableObject<Object> {
    
    private let objectQueue = Atomic([Object]())
    private let processObjectsQueue = Queue<ProcessingObject>()
    private let cancellableObservers = CompositeCancellableProperty()

    init(person: [Object]) {
        self.objectQueue.value = person
        super.init()
        self.setObservers()
    }
    
    convenience init(person: Object) {
        self.init(person: [person])
    }
    
    func performStaffWork(processObject: ProcessingObject) {
        self.objectQueue.transform {
            let availableObject = $0.first {
                $0.state == .available
            }
            
            let enqueueProcessingObject = { self.processObjectsQueue.enqueue(value: processObject) }
            
            if self.processObjectsQueue.isEmpty {
                if let availableStaff = availableObject {
                    availableStaff.processObject(processObject: processObject)
                } else {
                    enqueueProcessingObject()
                }
            } else {
                enqueueProcessingObject()
            }
        }
    }
    
    private func setObservers() {
        self.cancellableObservers.value = self.objectQueue.value.map { object in
            let observer = object.observer { [weak object, weak self] state in
                DispatchQueue.background.async {
                    self?.objectQueue.transform {_ in 
                        switch state {
                        case .available:
                            self?.processObjectsQueue.dequeue().apply(object?.processObject)
                        case .busy: return
                        case .waitForProcessing:
                            object.apply(self?.notify)
                        }
                    }
                }
            }

            return observer
        }
    }
}
