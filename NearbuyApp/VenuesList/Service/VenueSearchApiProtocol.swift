//
//  VenueSearchApiProtocol.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

protocol VenueSearchApiProtocol {
    func fetchVenues(with requestParam: VenueSearchApiRequesstParam, completion: @escaping (Result<VenueListResponseDTO, NetworkError>) -> Void)
}
