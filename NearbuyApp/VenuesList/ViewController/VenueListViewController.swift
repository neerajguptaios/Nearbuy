//
//  VenueListViewController.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import UIKit
import CoreLocation

class VenueListViewController: UIViewController {
    
    private let reuseIdentifierString : String = "reuse_cell_identifier_venue_list"
    
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var emptyStateStackView: UIStackView!
        
    private var viewModel: VenueListViewModelProtocol
    private let locationManager = CLLocationManager()

    init(viewModel: VenueListViewModelProtocol) {
        self.viewModel =  viewModel
        super.init(nibName: Self.className, bundle: nil)
        
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.distanceSlider.value = viewModel.selectedRange
        updateSliderLabel()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
                DispatchQueue.main.async {
                    self.viewModel.getVenues()
                }
            }
        }
    }
    
    
    @IBAction func tryAgainClicked(_ sender: Any) {
        viewModel.getVenues()
    }
    
    @IBAction func distanceSlderValueChanged(_ sender: Any) {
        viewModel.updateRange(value: distanceSlider.value)
        updateSliderLabel()
    }
    
    private func updateSliderLabel(){
        sliderLabel.text = "Restaurants within \(viewModel.getRangeString()) of current location"
    }
    
}

extension VenueListViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        viewModel.updateLacation(lat: locValue.latitude, lon: locValue.longitude)
    }
}


//MARK: - UISearchBarDelegate
extension VenueListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}


extension VenueListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfVenues()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierString)

        if(cell == nil)
        {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifierString)
        }
        if let model = viewModel.getVenueForIndexPath(indexPath: indexPath) {
            cell?.textLabel?.text = model.name
            cell?.detailTextLabel?.text = model.getCompleteAddress()
        }
        return cell!
    }
}

extension VenueListViewController : VenueListViewModelDelegate{
    func reloadCompleteTableView(completion: ((Bool) -> Void)) {
        tableView.reloadData()
        completion(true)
    }
    
    func update(indexPaths: [IndexPath], completion: ((_ completed: Bool) -> Void)) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
        completion(true)
    }
    
    func didReceivedErrorWhileFetchingVenues(errorMessage: String) {
        // handle error
    }
    
    func didReceivedEmptyResponse() {
        // handle empty response
    }
    
    
}
