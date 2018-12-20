//
//  ObservableObject+Extentions.swift
//  Car wash
//
//  Created by Student on 12/14/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension ObservableObject {
    
    class Observer: Hashable {
        
        var isObserving: Bool {
            return self.sender != nil
        }
        
        var hashValue: Int {
            return ObjectIdentifier(self).hashValue
        }
        
        private(set) var handler: Handler
        
        private weak var sender: ObservableObject?
        
        init(sender: ObservableObject, handler: @escaping Handler) {
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
}
