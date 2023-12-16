//
//  VenueSearchApiService.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

struct VenueSearchApiRequesstParam {
    var lat: Double
    var lon: Double
    var range: String
    
    var currentPage: Int
    var batchSize: Int
    var totalElements: Int?
    
    var searchString: String?
    
    init(lat: Double, lon: Double, range: String, currentPage: Int = 0, batchSize: Int = 10, totalElements: Int? = nil, searchString: String?) {
        self.lat = lat
        self.lon = lon
        self.range = range
        self.currentPage = currentPage
        self.batchSize = batchSize
        self.totalElements = totalElements
    }
}

class VenueSearchApiService: VenueSearchApiProtocol {
    
    func fetchVenues(with requestParam: VenueSearchApiRequesstParam, completion: @escaping (Result<VenueListResponseDTO, NetworkError>) -> Void) {
        let endpoint = ApiConstants.EndPoints.venues
        let requestQueryParams = VenueListRequestDTO(perPage: requestParam.batchSize, page: requestParam.currentPage, lat: requestParam.lat, lon: requestParam.lon, range: requestParam.range, searchString: requestParam.searchString)
        var queeryParam = (requestQueryParams.convertToDictionary()).unwrappedValue(or: [String: String]())
        
        queeryParam[ApiConstants.clientIdKey] = ApiConstants.clientIdValue
        
        NetworkingManager.shared.getData(requestURLString: endpoint,
                                         queryParam: requestQueryParams.convertToDictionary(),
                                         customHeader: nil,
                                         resultType: VenueListResponseDTO.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success((let venues, _)):
                    completion(.success(venues))
                    
                case .failure(let error):
                    // Log Error
                    error.logDetails()
                    completion(.failure(error))
                }
            }
        }
    }
}
