//
//  VenueListViewModel.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import Foundation

private let defaultSliderValue: Float = 5.0

class VenueListViewModel{

    init(venueSearchApiService: VenueSearchApiProtocol = VenueSearchApiService()) {
        self.venueSearchApiService = venueSearchApiService
    }
    
    
    var delegate: VenueListViewModelDelegate?
    var venueSearchApiService: VenueSearchApiProtocol

    
    
    private var rangeString : String {
        return "\(selectedRange)mi"
    }
    
    private(set) var selectedRange: Float = defaultSliderValue
    
    private var selectedLat: Double?
    private var selectedLon: Double?
    private var searchString : String?
    private var dataSource: [VenueDTO] = []
    private var nextBatchAvailable = true
    private var isFetchVenuesApiCallInProgress = false
    private let semaphore : DispatchSemaphore = DispatchSemaphore(value: 1)
    private var currentPage : Int = 1
    private var workItem : DispatchWorkItem?
    private var venueSearchApiRequestParam: VenueSearchApiRequesstParam {
        return VenueSearchApiRequesstParam(lat: selectedLat.unwrappedValue(or: Double.zero), lon: selectedLon.unwrappedValue(or: Double.zero), range: rangeString, currentPage: currentPage, searchString: searchString)
    }
    

}


extension VenueListViewModel: VenueListViewModelProtocol {
    
    func updateLacation(lat: Double, lon: Double){
        self.selectedLat = lat
        self.selectedLon = lon
    }
    
    func updateRange(value: Float) {
        self.selectedRange = value
        scheduleWorkItemToFetchVenues()
    }
    
    func getRangeString() -> String{
        return "\(Int(selectedRange)) miles"
    }
    
    func getVenues() {
        guard selectedLon != nil, selectedLat != nil else {
            // location is not fetched. show error
            return
        }
        semaphore.wait()
        dataSource.removeAll()
        delegate?.reloadCompleteTableView(completion: {[weak self] completed in
            self?.semaphore.signal()
            self?.fetchVenuesFromServer()
        })
        
    }
    
    
    func getNumberOfVenues() -> Int {
        return dataSource.count
    }

    func getVenueForIndexPath(indexPath: IndexPath) -> VenueDTO?{
        return dataSource[safe: indexPath.row]
    }

    func willDisplayIndexPath(indexPath: IndexPath) {
        // need to fetch more venues
        if indexPath.row >= self.dataSource.count {
            loadMoreVenues()
        }
    }
}


extension VenueListViewModel {
    
    func scheduleWorkItemToFetchVenues(){
        workItem?.cancel()
        let tempWorkItem = DispatchWorkItem { [weak self] in
            self?.fetchVenuesFromServer()
        }
        
        workItem = tempWorkItem
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: tempWorkItem)
    }
    
    private func fetchVenuesFromServer(){
        isFetchVenuesApiCallInProgress = true
        venueSearchApiService.fetchVenues(with: venueSearchApiRequestParam) { [weak self] result in
            guard let self else { return}
            isFetchVenuesApiCallInProgress = false
            switch result {
            case .success(let response):
                self.processVenuedResponse(response)
            case .failure(let error):
                error.logDetails()
                self.delegate?.didReceivedErrorWhileFetchingVenues(errorMessage: error.reason)

            }
        }
    }
    
    private func loadMoreVenues() {
        guard !isFetchVenuesApiCallInProgress else {
            return
        }
        // update page
        currentPage += 1
        fetchVenuesFromServer()
    }

    private func processVenuedResponse(_ venuesDto: VenueListResponseDTO) {
        if let venues = venuesDto.venues {
            self.semaphore.wait()
            let startIndex = self.dataSource.count
            self.dataSource.append(contentsOf: venues)
            let endIndex = self.dataSource.count
            if let newIndexPaths = prepareIndexPathsToReload(for: startIndex, endIndex: endIndex) {
                delegate?.update(indexPaths: newIndexPaths, completion: { completed in
                    self.semaphore.signal()
                })
            }
        }
        else{
            delegate?.didReceivedEmptyResponse()
        }
    }
    
    private func prepareIndexPathsToReload(for startIndex: Int,  endIndex: Int) -> [IndexPath]? {
        var newIndexPaths: [IndexPath] = []
        
        for index in startIndex..<endIndex {
            let indexPath = IndexPath(item: index , section: 0)
            newIndexPaths.append(indexPath)
        }
        return newIndexPaths
    }
}
