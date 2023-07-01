//
//  SearchPresenter.swift
//  IMusic
//
//  Created by macbook on 29.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
  
      switch response {
          
      case .some:
          print("presenter.some")
      case .presentTracks:
          print("presenter.presentTracks")
                viewController?.displayData(viewModel:
                Search.Model.ViewModel.ViewModelData.displayTracks)
      }
  }
}
