//
//  Observer.swift
//  Car wash
//
//  Created by Student on 12/12/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Observer: Hashable {
    
    typealias Handler = (Person.ProcessingState) -> ()
    
    public var isObserving: Bool {
        return self.sender != nil
    }
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    let handler: Handler
    private weak var sender: Person?
    
    init(sender: Person, handler: @escaping Handler) {
        self.sender = sender
        self.handler = handler
    }
    
    func cancel() {
        self.sender = nil
    }
    
    static func == (lhs: Observer, rhs: Observer) -> Bool {
        return lhs === rhs
    }
}
