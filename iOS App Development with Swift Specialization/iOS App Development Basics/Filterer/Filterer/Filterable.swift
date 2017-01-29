//
//  Filterable.swift
//  Filterer
//
//  Created by Juan Pablo Pinto Santana on 9/17/16.
//  Copyright © 2016 UofT. All rights reserved.
//

import Foundation

protocol Filterable {
    var intensity: Double { get set }
    
    var filterType: FilterSelection { get }
    
    var filterName: String { get }
    
    init?(name: String, intensity: Double)
    
    func apply(rgbaImage: RGBAImage) -> RGBAImage
}

enum FilterSelection: String {
    case RED
    case GREEN
    case BLUE
    case GRAYSCALE
    case CONTRAST
}

class FilterCalculations {
    private static func calculateAverages(rgbaImage: RGBAImage) -> (avgRed: Int, avgGreen: Int, avgBlue: Int) {
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
    
    static func redFilter(rgbaImage: RGBAImage, intensity: Double) -> RGBAImage {
        var rgbaImage = rgbaImage
        let averages = self.calculateAverages(rgbaImage)
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let redDelta = Int(pixel.red) - averages.avgRed

                if (Int(pixel.red) > averages.avgRed) {
                    pixel.red = UInt8(max(min(255, (Double(averages.avgRed) + intensity * 10 * Double(redDelta))), 0))
                } else {
                    
                }
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }
    
    static func blueFilter(rgbaImage: RGBAImage, intensity: Double) -> RGBAImage {
        var rgbaImage = rgbaImage
        let averages = self.calculateAverages(rgbaImage)
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let blueDelta = Int(pixel.blue) - averages.avgBlue

                if (Int(pixel.blue) > averages.avgBlue) {
                    pixel.blue = UInt8(max(min(255, (Double(averages.avgBlue) + intensity * 10 * Double(blueDelta))), 1))
                } else {
                    
                }
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }

    static func greenFilter(rgbaImage: RGBAImage, intensity: Double) -> RGBAImage {
        var rgbaImage = rgbaImage
        let averages = self.calculateAverages(rgbaImage)
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let greenDelta = Int(pixel.green) - averages.avgGreen
                
                if (Int(pixel.green) > averages.avgGreen) {
                    pixel.green = UInt8(max(min(255, (Double(averages.avgGreen) + intensity * 10 * Double(greenDelta))), 0))
                } else {
                    
                }
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }
    
    static func grayscaleFilter(rgbaImage: RGBAImage, intensity: Double) -> RGBAImage {
        var rgbaImage = rgbaImage
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let red = 0.2126 * intensity * Double(pixel.red)
                let green = 0.7152 * intensity * Double(pixel.green)
                let blue = 0.0722 * intensity * Double(pixel.blue)
                let l = red + green + blue
                
                pixel.red = UInt8(min(l, 255))
                pixel.green = UInt8(min(l, 255))
                pixel.blue = UInt8(min(l, 255))
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }
    
    static func contrastFilter(rgbaImage: RGBAImage, intensity: Double) -> RGBAImage {
        var rgbaImage = rgbaImage
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                
                let correctIntensity = (intensity * 255) - 128
                
                let factor = (259 * (correctIntensity + 255)) / (255 * (259 - correctIntensity))
                
                let red = factor * (Double(pixel.red) - 128) + 128
                let green = factor * (Double(pixel.green) - 128) + 128
                let blue = factor * (Double(pixel.blue) - 128) + 128
                
                pixel.red = UInt8(min(max(0, red), 255))
                pixel.green = UInt8(min(max(0, green), 255))
                pixel.blue = UInt8(min(max(0, blue), 255))
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage
    }
}