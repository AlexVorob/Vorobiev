//
//  Cancellable.swift
//  Car wash
//
//  Created by Student on 12/24/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Cancellable {
    
    var isCancelled: Bool { get }
    
    func cancel()
}
