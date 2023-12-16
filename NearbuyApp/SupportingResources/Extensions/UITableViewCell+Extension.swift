//
//  UITableViewCell+Extension.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import UIKit

extension UITableViewCell {
    static func tableCellReuseIdentifier() -> String {
        return className
    }
}
