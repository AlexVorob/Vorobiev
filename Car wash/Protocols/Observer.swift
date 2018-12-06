//
//  Observer.swift
//  Car wash
//
//  Created by Student on 12/5/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Observer: class {
    
    func processStateWaitForProcessing<T>(sender: T)
    
    func processStateAvailable<T>(sender: T)
}
