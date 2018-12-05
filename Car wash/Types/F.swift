//
//  F.swift
//  Car wash
//
//  Created by Student on 10/24/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

enum F {
    typealias Execute = () -> ()
    typealias Completion = () -> ()
    typealias CompletionWith<Value> = (Value) -> ()
}
