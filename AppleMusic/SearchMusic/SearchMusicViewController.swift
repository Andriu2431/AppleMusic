//
//  SearchViewController.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 12.06.2023.
//

import UIKit
import Alamofire

class SearchMusicViewController: UIViewController {
    
    private var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = SearchMusicViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchMusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        let cellViewModel = viewModel.configureCellViewModel(indexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.viewModel.fetchTracks(searchText: searchText, complection: {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        })
    }
}
