//
//  Observer.swift
//  Car wash
//
//  Created by Student on 12/5/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Observer: class {
    
    func handlStateWaitForProcessing<T>(sender: T)
    
    func handlStateAvailable<T>(sender: T)
    
}
