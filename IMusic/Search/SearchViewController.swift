//
//  SearchViewController.swift
//  IMusic
//
//  Created by macbook on 29.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    @IBOutlet weak var table: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?
    
    private lazy var footerView = FooterView()
    weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
      setup()
      setupSearchBar()
      setupTableView()
      
      //defult
      searchBar(searchController.searchBar, textDidChange: "Лезгины")
  }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCellView.identifier)
        table.tableFooterView = footerView
    }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
      switch viewModel {
          
      case .displayTracks(let searchViewModel):
          print("viewController.display")
          self.searchViewModel = searchViewModel 
          table.reloadData()
          footerView.hideLoader()
      case .displayFooterView:
          footerView.showLoader()
      }
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCellView
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above ..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]
        
        self.tabBarDelegate?.maximizedTrackDetailController(viewModel: cellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
    }
}

extension SearchViewController: TrackMovingDeleate {
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndextPath: IndexPath!
        if isForwardTrack {
            nextIndextPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndextPath.row == searchViewModel.cells.count {
                nextIndextPath.row = 0
            }
        } else {
            nextIndextPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndextPath.row == -1 {
                nextIndextPath.row = searchViewModel.cells.count - 1
            }
        }
        
        table.selectRow(at: nextIndextPath, animated: true, scrollPosition: .none)
        let cellViewModel = searchViewModel.cells[nextIndextPath.row]
        return cellViewModel
    }
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        print("next")
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        print("next2")
        return getTrack(isForwardTrack: true)
    }
}
