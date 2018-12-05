//
//  TimeInterval + Extension.swift
//  Car wash
//
//  Created by Student on 10/24/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension DispatchTime {
    
    static func after(interval: TimeInterval) -> DispatchTime {
        return .now() + interval
    }
}
