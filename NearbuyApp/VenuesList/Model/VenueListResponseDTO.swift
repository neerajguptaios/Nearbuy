//
//  VenueListResponseDTO.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

struct VenueListResponseDTO: Decodable {
    let venues: [VenueDTO]?
    let meta: VenueListMeta?
}

struct VenueDTO: Decodable{
    let name: String?
    let city: String?
    let address: String?
    let extendedAddress: String?
}

struct VenueListMeta: Decodable{
    let total: Int?
    let page: Int?
    let perPage: Int?
}
