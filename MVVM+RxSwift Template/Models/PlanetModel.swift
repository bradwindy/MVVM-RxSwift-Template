//
//  PlanetModel.swift
//  MVVM+RxSwift Template
//
//  Created by Bradley Windybank on 16/08/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import Foundation

struct PlanetResponse {
    let count : Int
    let nextUrlString : String
    let prevUrlString: String?
    let results: [Planet]
}

struct Planet {
    let name : String
    let diameter : String
    let rotationPeriod: String
    let orbitalPeriod: String
    let gravity: String
    let population: String
    let climate: String
    let terrain: String
    let surfaceWater: String
    let residents: [String]
    let films: [String]
    let url: String
    let created: String
    let edited: String
}

struct PlanetProperty {
    let detail: String
    let unit: String?
    let description: String
}

extension PlanetResponse: Parseable {
    static func parseObject(dictionary: [String : AnyObject]) -> Result<PlanetResponse, ErrorResult> {
        if let count = dictionary["count"] as? Int,
            let nextUrlString = dictionary["next"] as? String,
            let results = dictionary["results"] as? [[String: AnyObject]] {
            
            var planets: [Planet] = []
            
            for result in results {
                let planetResult = Planet.parseObject(dictionary: result)
                switch planetResult {
                case .success(let planet):
                    planets.append(planet)
                default:
                    break
                }
            }
            
            return .success(PlanetResponse(count: count,
                                           nextUrlString: nextUrlString,
                                           prevUrlString: nil,
                                           results: planets))
        }
        else {
            return .failure(.parser(string: "Unable to parse planet response"))
        }
    }
}

extension Planet: Parseable {
    static func parseObject(dictionary: [String : AnyObject]) -> Result<Planet, ErrorResult> {
        if let name = dictionary["name"] as? String,
            let diameter = dictionary["diameter"] as? String,
            let rotationPeriod = dictionary["rotation_period"] as? String,
            let orbitalPeriod = dictionary["orbital_period"] as? String,
            let gravity = dictionary["gravity"] as? String,
            let population = dictionary["population"] as? String,
            let climate = dictionary["climate"] as? String,
            let terrain = dictionary["terrain"] as? String,
            let surfaceWater = dictionary["surface_water"] as? String,
            let residents = dictionary["residents"] as? [String],
            let films = dictionary["films"] as? [String],
            let url = dictionary["url"] as? String,
            let created = dictionary["created"] as? String,
            let edited = dictionary["edited"] as? String {
            
            return .success(Planet(name: name,
                                   diameter: diameter,
                                   rotationPeriod: rotationPeriod,
                                   orbitalPeriod: orbitalPeriod,
                                   gravity: gravity,
                                   population: population,
                                   climate: climate,
                                   terrain: terrain,
                                   surfaceWater: surfaceWater,
                                   residents: residents,
                                   films: films,
                                   url: url,
                                   created: created,
                                   edited: edited))
        }
        else {
            return .failure(.parser(string: "Unable to parse planet"))
        }
    }
}

extension Planet {
    func getProperties() -> [PlanetProperty] {
        var properties = [PlanetProperty]()
        
        properties.append(PlanetProperty(detail: self.climate, unit: nil, description: "Climate"))
        properties.append(PlanetProperty(detail: self.diameter, unit: "km", description: "Diameter"))
        properties.append(PlanetProperty(detail: self.gravity, unit: "g", description: "Gravity"))
        properties.append(PlanetProperty(detail: self.orbitalPeriod, unit: "days", description: "Orbital Period"))
        properties.append(PlanetProperty(detail: self.population, unit: "people", description: "Population"))
        properties.append(PlanetProperty(detail: self.rotationPeriod, unit: "hours", description: "Rotation Period"))
        properties.append(PlanetProperty(detail: self.surfaceWater, unit: "percent", description: "Surface Water"))
        properties.append(PlanetProperty(detail: self.terrain, unit: nil, description: "Terrain"))
        
        return properties
    }
}
