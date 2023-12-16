//
//  UIActivityIndicatorView+Extension.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import UIKit

extension UIActivityIndicatorView {
    func showLoader() {
        self.isHidden = false
        self.startAnimating()
    }

    func hideLoader() {
        self.isHidden = true
        self.stopAnimating()
    }
}
