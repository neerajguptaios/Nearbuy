//
//  VenueListViewController.swift
//  NearbuyApp
//
//  Created by Neeraj Gupta on 16/12/23.
//

import UIKit

class VenueListViewController: UIViewController {
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var emptyStateStackView: UIStackView!
    
    private var viewModel: VenueListViewModelProtocol{
        didSet {
            viewModel.delegate = self
        }
    }

    
    init(viewModel: VenueListViewModelProtocol) {
        self.viewModel =  viewModel
        super.init(nibName: Self.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tryAgainClicked(_ sender: Any) {
        
    }
    
    @IBAction func distanceSlderValueChanged(_ sender: Any) {
        
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
        
    }
}

extension VenueListViewController : VenueListViewModelDelegate{
    func didFetchedVenuesSuccessfully(indexPaths: [IndexPath]?) {
        <#code#>
    }
    
    func didReceivedErrorWhileFetchingVenues(errorMessage: String) {
        <#code#>
    }
    
    func didReceivedEmptyResponse() {
        <#code#>
    }
    
    
}

extension VenueListViewController {
    private func addRowsInTableView(with indexPaths: [IndexPath]?) {
        // Removing paginating cell and adding new cell
        
    }
}
