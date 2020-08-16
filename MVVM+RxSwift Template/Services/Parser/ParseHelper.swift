//
//  ParseHelper.swift
//  MVVM+RxSwift Template
//
//  Created by Bradley Windybank on 16/08/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import Foundation
import RxSwift

protocol Parseable {
    static func parseObject(dictionary: [String: AnyObject]) -> Result<Self, ErrorResult>
}

final class ParserHelper {
    static func parse<T: Parseable>(data: Data, completion : (Result<[T], ErrorResult>) -> Void) {
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                var finalResult : [T] = []
                for object in result {
                    if let dictionary = object as? [String : AnyObject] {
                        switch T.parseObject(dictionary: dictionary) {
                        case .failure(_):
                            continue
                        case .success(let newModel):
                            finalResult.append(newModel)
                            break
                        }
                    }
                }
                completion(.success(finalResult))
            }
            else {
                // not an array
                completion(.failure(.parser(string: "Json data is not an array")))
            }
        }
        catch {
            // can't parse json
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }
    
    static func parse<T: Parseable>(data: Data, completion : (Result<T, ErrorResult>) -> Void) {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                switch T.parseObject(dictionary: dictionary) {
                case .failure(let error):
                    completion(.failure(error))
                    break
                case .success(let newModel):
                    completion(.success(newModel))
                    break
                }
            }
            else {
                // not an array
                completion(.failure(.parser(string: "Json data is not valid")))
            }
        }
        catch {
            // can't parse json
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }
}
