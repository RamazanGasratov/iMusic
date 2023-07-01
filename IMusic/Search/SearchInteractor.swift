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

  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
      
      switch request {
          
      case .some:
          print("intractor.some")
          presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks)
      case .getTracks:
          print("intractor.getTracks")
          presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks)
      }
  }
  
}
