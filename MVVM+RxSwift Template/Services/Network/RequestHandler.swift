//
//  RequestHandler.swift
//  MVVM+RxSwift Template
//
//  Created by Bradley Windybank on 16/08/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import Foundation

class RequestHandler {
    let reachability = Reachability()!
    
//    /// For an array
//    func networkResult<T: Parseable>(completion: @escaping ((Result<[T], ErrorResult>) -> Void)) -> ((Result<Data, ErrorResult>) -> Void) {
//        return { dataResult in
//            DispatchQueue.global(qos: .background).async(execute: {
//                switch dataResult {
//                case .success(let data) :
//                    ParserHelper.parse(data: data, completion: completion)
//
//                case .failure(let error) :
//                    print("Network error \(error)")
//                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
//                }
//            })
//        }
//    }
    
    /// For a single object
    func networkResult<T: Parseable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) -> ((Result<Data, ErrorResult>) -> Void) {
        return { dataResult in
            DispatchQueue.global(qos: .background).async(execute: {
                switch dataResult {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    
                case .failure(let error) :
                    print("Network error \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                }
            })
        }
    }
}
