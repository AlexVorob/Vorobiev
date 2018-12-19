//
//  Queue.swift
//  Car wash
//
//  Created by Student on 10/29/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

class Queue<Element> {
    
    private var elements: Atomic<[Element]>
    
    init(elements: [Element]) {
        self.elements = Atomic(elements)
    }
    
    convenience init() {
        self.init(elements: [Element]())
    }
    
    func enqueue(value: Element) {
        self.elements.modify { $0.append(value) }
    }
    
    func dequeue() -> Element? {
        return self.elements.modify { $0.safeRemoveFirst() }
    }
    
    var isEmpty: Bool {
        return self.elements.value.isEmpty
    }
    
    var count: Int {
        return self.elements.value.count
    }
}
