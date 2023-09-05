//
//  SearchViewController.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 12.06.2023.
//

import UIKit

class SearchMusicViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var timer: Timer?
    private lazy var footerView = FooterView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModel = SearchMusicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        tableView.tableFooterView = footerView
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource

extension SearchMusicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.numberOfRows() > 0 ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        let cellViewModel = viewModel.configureTrackCellViewModel(indexPath: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last
        let trackDetailView = Bundle.main.loadNibNamed("TrackDetailView", owner: self)?.first as! TrackDetailView
        let trackDetailViewModel = viewModel.configureTrackDetailViewModel(indexPath: indexPath)
        trackDetailView.delegate = self
        trackDetailView.viewModel = trackDetailViewModel
        window?.addSubview(trackDetailView)
    }
}

//MARK: UISearchBarDelegate

extension SearchMusicViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        footerView.showLoader()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.viewModel.fetchTracks(searchText: searchText, complection: {
                DispatchQueue.main.async {
                    self?.footerView.hideLoader()
                    self?.tableView.reloadData()
                }
            })
        })
    }
}

//MARK: TrackMovingDelegate

extension SearchMusicViewController: TrackMovingDelegate {
    func moveBackForPreviousTrack() -> TrackDetailViewModelProtocol? {
        getBackTrackViewModel()
    }
    
    func moveForwardForPreviousTrack() -> TrackDetailViewModelProtocol? {
        getForwardTrackViewModel()
    }
    
    private func getBackTrackViewModel() -> TrackDetailViewModelProtocol? {
        guard let currentIndexPath = tableView.indexPathForSelectedRow else { return nil }
        var backIndexPath = IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)
        
        tableView.deselectRow(at: currentIndexPath, animated: true)
        
        if currentIndexPath.row == 0 {
            backIndexPath.row = viewModel.numberOfRows() - 1
        }
        
        tableView.selectRow(at: backIndexPath, animated: true, scrollPosition: .none)
        return viewModel.configureTrackDetailViewModel(indexPath: backIndexPath)
    }
    
    private func getForwardTrackViewModel() -> TrackDetailViewModelProtocol? {
        guard let currentIndexPath = tableView.indexPathForSelectedRow else { return nil }
        var forwardIndexPath = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
        
        tableView.deselectRow(at: currentIndexPath, animated: true)
        
        if forwardIndexPath.row == viewModel.numberOfRows() {
            forwardIndexPath.row = 0
        }
        
        tableView.selectRow(at: forwardIndexPath, animated: true, scrollPosition: .none)
        return viewModel.configureTrackDetailViewModel(indexPath: forwardIndexPath)
    }
}
