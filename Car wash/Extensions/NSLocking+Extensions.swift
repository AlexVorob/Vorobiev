//
//  NSLocking+Extensions.swift
//  Car wash
//
//  Created by Student on 10/31/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension NSLocking {
    
    func locked<Result>( _ action: () -> Result) -> Result {
        self.lock()
        defer { self.unlock() }
        
        return action()
    }
}
