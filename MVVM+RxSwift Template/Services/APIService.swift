//
//  APIService.swift
//  MVVM+RxSwift Template
//
//  Created by Bradley Windybank on 16/08/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import Foundation
import RxSwift

protocol APIServiceObservable: class {
    func fetchPlanets() -> Observable<PlanetResponse>
}

final class APIService: RequestHandler, APIServiceObservable {
    static let shared = APIService()
    let endpoint = "https://swapi.dev/api/planets/"
    var task : URLSessionTask?
    
    func fetchPlanets() -> Observable<PlanetResponse> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return observer.onError(ErrorResult.network(string: "Something has gone wrong. Please Try Again!")) as! Disposable }
            self.cancelFetch()
            self.task = RequestService().loadData(urlString: self.endpoint,
                                                  completion: self.networkResult(){ (result: Result<PlanetResponse, ErrorResult>) in
                                                    
                                                    switch result {
                                                    case .success(let planet):
                                                        observer.onNext(planet)
                                                        
                                                    case .failure(let error):
                                                        observer.onError(error)
                                                    }
                                                    
                                                    observer.onCompleted()
            })
            
            self.task?.resume()
            
            return Disposables.create {
                self.task?.cancel()
            }
        }
    }
    
    func cancelFetch() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
