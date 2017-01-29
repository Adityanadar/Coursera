//
//  ImageProcessor.swift
//  Filterer
//
//  Created by Juan Pablo Pinto Santana on 9/16/16.
//  Copyright © 2016 UofT. All rights reserved.
//
import UIKit

class ImageProcessor {
    
    var rgbaImage: RGBAImage!
    private var imageAverages: (Int, Int, Int) {
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width{
                let index = y * rgbaImage.width + x
                let pixel = rgbaImage.pixels[index]
                
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        let pixelCount = rgbaImage.width * rgbaImage.height
        let avgRed = totalRed / pixelCount
        let avgGreen = totalGreen / pixelCount
        let avgBlue = totalBlue / pixelCount
        
        return (avgRed, avgGreen, avgBlue)
    }
    
    
    func applyFilter(filterName: String, intensity: Double) -> RGBAImage? {
        guard let filterType = FilterSelection(rawValue: filterName.uppercaseString) else {
            return nil
        }
 
        switch filterType {
            case .RED:
                return ImageCalculations.redFilter(rgbaImage, intensity: intensity)
            case .BLUE:
                return ImageCalculations.blueFilter(rgbaImage, intensity: intensity)
            case .GREEN:
                return ImageCalculations.greenFilter(rgbaImage, intensity: intensity)
            case .GRAYSCALE:
                return ImageCalculations.grayscaleFilter(rgbaImage, intensity: intensity)
            case .CONTRAST:
                return ImageCalculations.contrastFilter(rgbaImage, intensity: intensity)
        }
    }
}