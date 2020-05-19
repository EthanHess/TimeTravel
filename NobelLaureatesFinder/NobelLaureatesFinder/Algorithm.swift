//
//  Algorithm.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/16/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import Foundation
import CoreLocation


 
// Your time machine is capable of moving 1 year through time expending the same energy as traveling 10km along the surface of Earth. You should consider a jump of (2 years + 0km) as equivalent to (1 year + 10km) and (0 years + 20km)

// Store local array/hash of values for quick fetch
var pastSearches : [String : [NobelLaureate]] = [:]

class Algorithm {
    static func performSearchWithArray(array: [NobelLaureate], latitude: Double, longitude: Double, year: Int, completion: @escaping((_ nearestTwenty : [NobelLaureate]?) -> Void)) {
        var tempArray : [NobelLaureate] = [] //nearest
        
        //One for loop = O(n)
        for var laur in array {
            //current is cur element
            //abs will give positive number if negative
            let yearsFromCurrent = abs(yearsFromCurrentWithLaureate(laureate: laur, inputYear: Int(year)))
            let distanceFromCurrent = distanceFromCurrentWithLocationInKilometers(location: CLLocation(latitude: laur.location.lat, longitude: laur.location.lng), inputLocation: CLLocation(latitude: latitude, longitude: longitude))
            
            Logger.log("YEARS + DISTANCE \(yearsFromCurrent) \(distanceFromCurrent)")
            
            let yearCost = yearsFromCurrent * 10
            let kmCost = distanceFromCurrent
            
            var cost = 0
            cost += yearCost + Int(kmCost)
            
            Logger.log("COST \(cost)")
            
            laur.cost = cost
            tempArray.append(laur)
        }
    
        // Sort complexity is O(n log n) - DOMINANT TERM -
        // Ascending
        tempArray.sort { (laurOne, laurTwo) -> Bool in
            return laurOne.cost < laurTwo.cost
        }
        
        // Complexity is O(1), Good :)
        let completionArray = Array(tempArray.prefix(upTo: 20))
        
        Logger.log("--- SORTED ARRAY \(completionArray)")
        
        completion(completionArray)
    }
    
    //Years
    static func yearsFromCurrentWithLaureate(laureate: NobelLaureate, inputYear: Int) -> Int {
        
        var componentsLaur = DateComponents()
        var componentsInput = DateComponents()
        componentsLaur.year = Int(laureate.year)
        componentsInput.year = Int(inputYear)
        let theCalendar = Calendar.current
        let laurYear = theCalendar.date(from: componentsLaur)
        let inputDateYear = theCalendar.date(from: componentsInput)
        let years = laurYear!.yearsApart(from: inputDateYear!)
        
        return years
    }
    
    //KM
    static func distanceFromCurrentWithLocationInKilometers(location: CLLocation, inputLocation: CLLocation) -> Double {
        return location.distance(from: inputLocation) / 1000 //is meters
    }
    
    //Store searches for fast fetching if they enter the same location, come up with other hash tables too for future searches
    
    static func cacheResults(key: String, results: [NobelLaureate]) {
        pastSearches[key] = results
    }
    
    static func fetchSearchResults(key: String) -> [NobelLaureate]? {
        return pastSearches[key]
    }
}

