//
//  VenueListResponseDTO.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

struct VenueListResponseDTO: Codable{
    let venues: [VenueDTO]?
    let meta: VenueListMeta?
}

struct VenueDTO: Codable{
    let name: String?
    let city: String?
    let address: String?
    let extendedAddress: String?
    
    func getCompleteAddress() -> String{
        let add = [address, extendedAddress].compactMap{$0}
        return add.joined(separator: ", ")
    }
}

struct VenueListMeta: Codable{
    let total: Int?
    let page: Int?
    let perPage: Int?
    
    func isNextBatchAvailable() -> Bool?{
        guard let total = total, let page = page, let perPage = perPage else {
            return nil
        }
        if perPage * page >= total {
            return false
        }
        else{
            return true
        }
    }
}
