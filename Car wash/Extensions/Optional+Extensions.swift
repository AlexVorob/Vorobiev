//
//  Optional.swift
//  Car wash
//
//  Created by Student on 10/23/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension Optional {
    
    func `do`( _ action: (Wrapped) -> ()) {
        self.map(action)
    }
}
