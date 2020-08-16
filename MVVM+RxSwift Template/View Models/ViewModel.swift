//
//  ViewModel.swift
//  MVVM+RxSwift Template
//
//  Created by Bradley Windybank on 16/08/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ViewModel {
    weak var apiService: APIServiceObservable?
    let input: Input
    let output: Output
    
    struct Input {
        let reload: PublishRelay<Void>
    }
    
    struct Output {
        let planets: Driver<[Planet]>
        let errorMessage: Driver<String>
    }
    
    init(apiService: APIServiceObservable = APIService.shared) {
        self.apiService = apiService
        
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        
        let planets = reloadRelay
            .asObservable()
            .flatMapLatest({ apiService.fetchPlanets() })
            .map({ $0.results })
            .asDriver { (error) -> Driver<[Planet]> in
                errorRelay.accept((error as? ErrorResult)?.localizedDescription ?? error.localizedDescription)
                return Driver.just([])
            }
        
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(planets: planets,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
    }
}
