//
//  ObservableObject.swift
//  Car wash
//
//  Created by Student on 12/14/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class ObservableObject<State> {
    
    typealias Handler = (State) -> ()
    
    private let atomicObservers = Atomic([Observer]())
    
    public func observer(handler: @escaping Handler) -> Observer {
        return self.atomicObservers.modify {
            let observer = Observer(sender: self, handler: handler)
            $0.append(observer)
            
            return observer
        }
    }
    
    public func notify(state: State) {
        self.atomicObservers.modify {
            $0 = $0.filter { $0.isObserving }
            $0.forEach { $0.handler(state) }
        }
    }
}
