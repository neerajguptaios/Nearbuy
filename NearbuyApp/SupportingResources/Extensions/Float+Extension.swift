//
//  Float+Extension.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 17/12/23.
//

import Foundation


extension Float {
    public func roundTo(_ digits: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Float {
        if self.isNaN || self.isInfinite {
            return 0
        }
        let multiplier: Float = powf(10.0, Float(digits))
        return (self * multiplier).rounded(rule) / multiplier
    }
    
}

