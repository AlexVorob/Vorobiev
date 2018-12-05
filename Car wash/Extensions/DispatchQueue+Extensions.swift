//
//  DispatchQueue + Extension.swift
//  Car wash
//
//  Created by Student on 10/24/18.
//  Copyright © 2018 IDAP. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static var background = DispatchQueue.global(qos: .background)
    static var userInteractive = DispatchQueue.global(qos: .userInteractive)
    static var userInitiated = DispatchQueue.global(qos: .userInitiated)
    static var utility = DispatchQueue.global(qos: .utility)
    static var unspecified = DispatchQueue.global(qos: .unspecified)
    static var `default` = DispatchQueue.global(qos: .default)
    
    func timerToken(
        interval: TimeInterval,
        execute: @escaping F.Execute
    )
        -> TimerToken
    {
        let timerToken = TimerToken()
        
        self.continueWorkTimer(timerToken: timerToken, interval: interval, execute: execute)
        
        return timerToken
    }

    private func continueWorkTimer(timerToken: TimerToken, interval: TimeInterval, execute: @escaping F.Execute) {
        self.asyncAfter(
            deadline:.after(interval: interval)
        ) {
            if timerToken.isRunning {
                execute()
                self.continueWorkTimer(timerToken: timerToken, interval: interval, execute: execute)
            }
        }
    }
    
    class TimerToken {
        
        private let tokenState = Atomic(true)
        
        var isRunning: Bool {
            return self.tokenState.value
        }
        
        func stop() {
            self.tokenState.value = false
        }
    }
}
