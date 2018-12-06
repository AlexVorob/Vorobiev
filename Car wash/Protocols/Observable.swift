//
//  Observable.swift
//  Car wash
//
//  Created by Student on 12/5/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

protocol Observable {
    
    func addObserver(observer: Observer)
    
    func deleteObserver()
}
