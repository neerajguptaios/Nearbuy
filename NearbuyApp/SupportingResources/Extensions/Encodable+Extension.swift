//
//  Encodable+Extension.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation
extension Encodable {
    func convertToDictionary() -> [String: String]? {
        do {
            let encoder = try JSONEncoder().encode(self)

            // Use try/catch for JSON deserialization
            guard let jsonObject = try JSONSerialization.jsonObject(with: encoder, options: .allowFragments) as? [String: Any] else {
                // Handle the case when deserialization fails
                return nil
            }

            // Convert the dictionary values to strings
            let dict = jsonObject.mapValues { value in
                return "\(value)"
            }

            return dict
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
}
