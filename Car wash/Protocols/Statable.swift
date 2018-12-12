//
//  Statable.swift
//  Car wash
//
//  Created by Student on 11/7/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Statable: class {
    
    var state: Person.ProcessingState { get set }
}
