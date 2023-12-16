//
//  VenueListRequestDTO.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

struct VenueListRequestDTO: Encodable {
    let perPage: Int
    let page: Int
    let lat: CGFloat
    let lon: CGFloat
    let range: String
    let searchString: String?


    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case page, lat, lon, range
        case searchString = "q"
    }

}
