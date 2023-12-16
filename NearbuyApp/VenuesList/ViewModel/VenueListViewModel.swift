//
//  VenueListViewModel.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

class VenueListViewModel: VenueListViewModelProtocol{
    
    
    init(venueSearchApiService: VenueSearchApiProtocol = VenueSearchApiService()) {
        self.venueSearchApiService = venueSearchApiService
    }
    
    var dataSource: [VenueDTO] = []
    
    var delegate: VenueListViewModelDelegate?
    
    var venueSearchApiService: VenueSearchApiProtocol
    
    func updateLacation(lat: Double, lon: Double) {
        <#code#>
    }
    
    func updateRange(value: Float) {
        <#code#>
    }
    
    func getVenues() {
        <#code#>
    }
    
    func loadMoreVenues() {
        <#code#>
    }
    
    func getNumberOfVenues() -> Int {
        <#code#>
    }
    
    func isNextBatchAvailable() -> Bool {
        <#code#>
    }
    
    func isAtLastIndexForPagination(_ row: Int) -> Bool {
        <#code#>
    }
    
    func willDisplayIndexPath(indexPath: IndexPath) {
        <#code#>
    }
    
    
}
