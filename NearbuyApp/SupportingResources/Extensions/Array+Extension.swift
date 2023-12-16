//
//  Array+Extension.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation
extension Array {

    subscript(safe index: Int) -> Element? {
        if index >= count {
            return nil
        }
        return self[index]
    }
}
