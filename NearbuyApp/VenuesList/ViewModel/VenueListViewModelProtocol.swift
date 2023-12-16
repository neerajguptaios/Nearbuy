//
//  VenueListViewModelProtocol.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

protocol VenueListViewModelProtocol {
    var dataSource: [VenueDTO] { get }
    
    var delegate: VenueListViewModelDelegate? { get set }
    var venueSearchApiService: VenueSearchApiProtocol { get }
    
    func updateLacation(lat: Double, lon: Double)
    func updateRange(value: Float)
    
    func getVenues()
    func loadMoreVenues()
    func getNumberOfVenues() -> Int
    func isNextBatchAvailable() -> Bool
    func isAtLastIndexForPagination(_ row: Int) -> Bool
    
    func willDisplayIndexPath(indexPath: IndexPath)
}


protocol VenueListViewModelDelegate: AnyObject {
    func didFetchedVenuesSuccessfully(indexPaths: [IndexPath]?)
    func didReceivedErrorWhileFetchingVenues(errorMessage: String)
    func didReceivedEmptyResponse()
}
