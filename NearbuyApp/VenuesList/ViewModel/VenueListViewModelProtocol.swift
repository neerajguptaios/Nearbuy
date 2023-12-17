//
//  VenueListViewModelProtocol.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

protocol VenueListViewModelProtocol {
    
    var delegate: VenueListViewModelDelegate? { get set }
    var venueSearchApiService: VenueSearchApiProtocol { get }
    var selectedRange: Float { get }
    
    func updateLacation(lat: Double, lon: Double)
    func updateRange(value: Float)
    func getRangeString() -> String
    
    func getVenues()
    
    func getNumberOfVenues() -> Int
    func getVenueForIndexPath(indexPath: IndexPath) -> VenueDTO?
        
    func willDisplayIndexPath(indexPath: IndexPath)
}



protocol VenueListViewModelDelegate: AnyObject {
    func update(indexPaths: [IndexPath], completion: ((_ completed: Bool) -> Void))
    func reloadCompleteTableView(completion: ((_ completed: Bool) -> Void))
    func didReceivedErrorWhileFetchingVenues(errorMessage: String)
    func didReceivedEmptyResponse()
}
