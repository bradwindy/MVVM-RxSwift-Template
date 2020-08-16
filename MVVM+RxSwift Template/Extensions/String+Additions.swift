//
//  String+Additions.swift
//  MVVM+RxSwift Template
//
//  Created by Bradley Windybank on 16/08/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import Foundation

extension String {
    public func formatNumberString() -> String {
        if let stringInt = Int(self) {
            return formatNumberAsBMK(stringInt)
        }
        else {
            return self.capitalized
        }
    }
}

private func formatNumberAsBMK(_ n: Int) -> String {
    let num = abs(Double(n))
    let sign = (n < 0) ? "-" : ""

    switch num {
    case 1_000_000_000_000...:
        var formatted = num / 1_000_000_000_000
        formatted = formatted.truncate(places: 1)
        return "\(sign)\(formatted)T"

    case 1_000_000_000...:
        var formatted = num / 1_000_000_000
        formatted = formatted.truncate(places: 1)
        return "\(sign)\(formatted)B"

    case 1_000_000...:
        var formatted = num / 1_000_000
        formatted = formatted.truncate(places: 1)
        return "\(sign)\(formatted)M"

    case 1_000...:
        var formatted = num / 1_000
        formatted = formatted.truncate(places: 1)
        return "\(sign)\(formatted)K"

    case 0...:
        return "\(n)"

    default:
        return "\(sign)\(n)"
    }
}

private extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
