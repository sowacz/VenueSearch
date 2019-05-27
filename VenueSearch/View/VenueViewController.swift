//
//  ViewController.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 24/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import UIKit

class VenueViewController: UIViewController, VenueView {

    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    private var venuesToPresent = [VenueViewData]()
    private var presenter: VenuePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize(presenter: VenuePresenter(view: self, foursquareService: FoursquareService(), locationService: LocationService()))
    }
    
    public func initialize(presenter: VenuePresenter) {
        self.presenter = presenter
        
        self.searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: VenueTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: VenueTableViewCell.identifier)
    }
    
    public func getCurrentFetchedVenues() -> [VenueViewData] {
        return venuesToPresent
    }

//MARK: - Venue View delegate methods

    public func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    public func finishLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    public func setVenues(venues: [VenueViewData]) {
        self.venuesToPresent = venues
        self.tableView.reloadData()
    }
}

//MARK: -
extension VenueViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter?.getVenue(basedOn: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

//MARK: - Table View Data Source
extension VenueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venuesToPresent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VenueTableViewCell.identifier, for: indexPath) as! VenueTableViewCell
        let venueViewData = venuesToPresent[indexPath.row]
        cell.nameLabel.text = venueViewData.name
        cell.addressLabel.text = venueViewData.address
        cell.distanceLabel.text = venueViewData.distance
        return cell
    }
    
    
}

