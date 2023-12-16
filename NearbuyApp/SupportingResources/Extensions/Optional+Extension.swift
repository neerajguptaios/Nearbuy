//
//  Optional+Extension.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation
extension Optional {
   func unwrappedValue(or defaultValue: Wrapped) -> Wrapped {
        if self != nil{
            switch self {
            case .none:
                return defaultValue
            case .some(let wrapped):
                return wrapped
            }
        }

        return defaultValue
    }
}
