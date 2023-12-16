//
//  GeneralUtil.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

func print(_ object: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.print(object)
    #endif
}

func debugPrint(_ items: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.debugPrint(items)
    #endif
}

