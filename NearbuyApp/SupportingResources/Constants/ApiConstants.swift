//
//  ApiConstants.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

struct ApiConstants {
    private static let baseURL = "https://api.seatgeek.com/2"
//    private static let baseURL = "https://api.seatgeek.com/2/venues?cleint_id=<client_id>&per_page"
    static let clientIdValue = "Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5"
    static let clientIdKey = "client_id"

    struct EndPoints {
        static let venues = "\(baseURL)/venues"
    }
}
