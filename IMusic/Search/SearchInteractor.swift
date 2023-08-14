//
//  SearchInteractor.swift
//  IMusic
//
//  Created by macbook on 29.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {

    var networkService = NetworkService()
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
      
      switch request {
     
      case .getTracks(let serchTerm):
          print("intractor.getTracks")
          presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
          
          networkService.fetchTrack(searchText: serchTerm) { [weak self] searchResponse in
              self?.presenter?.presentData(response:
                                        Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
          }
      }
  }
}
