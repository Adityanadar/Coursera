//
//  Filter.swift
//  Filterer
//
//  Created by Juan Pablo Pinto Santana on 9/15/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import UIKit


class Filter: Filterable {
    var intensity: Double
    
    let filterType: FilterSelection
    
    var filterName: String {
        return filterType.rawValue
    }
    
    required init?(name: String, intensity: Double) {
        guard let filterType = FilterSelection(rawValue: name.uppercaseString) else {
            return nil
        }
        self.filterType = filterType
        self.intensity = intensity
    }
    
    func apply(rgbaImage: RGBAImage) -> RGBAImage {
        switch filterType {
            case .RED:
                return FilterCalculations.redFilter(rgbaImage, intensity: intensity)
            case .BLUE:
                return FilterCalculations.blueFilter(rgbaImage, intensity: intensity)
            case .GREEN:
                return FilterCalculations.greenFilter(rgbaImage, intensity: intensity)
            case .GRAYSCALE:
                return FilterCalculations.grayscaleFilter(rgbaImage, intensity: intensity)
            case .CONTRAST:
                return FilterCalculations.contrastFilter(rgbaImage, intensity: intensity)
        }
    }
}