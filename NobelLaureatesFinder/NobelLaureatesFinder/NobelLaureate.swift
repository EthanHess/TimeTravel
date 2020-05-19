//
//  NobelLaureate.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/15/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import Foundation
import CoreLocation

struct NobelLaureate : Codable {
    
    //MARK properties
    var name : String = ""
    var id : Int = 0
    var category : String = ""
    var died : String = ""
    var diedcity : String = ""
    var borncity : String = ""
    var born : String = ""
    var surname : String = ""
    var firstname : String = ""
    var motivation : String = ""
    var city : String = ""
    var borncountry : String = ""
    var year : String = "" //And this
    var diedcountry : String = ""
    var country : String = ""
    var gender : String = ""
    var location : Location
    
    //Not in original JSON, assigned later
    var cost : Int = 0
 
    enum CodingKeys: String, CodingKey {
        
        case id
        case category
        case died
        case diedcity
        case borncity
        case born
        case surname
        case firstname
        case motivation
        case city
        case borncountry
        case year
        case diedcountry
        case country
        case gender
        case name
        
        //Nested values
        case location
    }
    
    init(from decoder: Decoder) throws {
        //not nested
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        category = try values.decode(String.self, forKey: .category)
        died = try values.decode(String.self, forKey: .died)
        diedcity = try values.decode(String.self, forKey: .diedcity)
        borncity = try values.decode(String.self, forKey: .borncity)
        born = try values.decode(String.self, forKey: .born)
        surname = try values.decode(String.self, forKey: .surname)
        firstname = try values.decode(String.self, forKey: .firstname)
        motivation = try values.decode(String.self, forKey: .motivation)
        city = try values.decode(String.self, forKey: .city)
        borncountry = try values.decode(String.self, forKey: .borncountry)
        year = try values.decode(String.self, forKey: .year) //query this + location
        diedcountry = try values.decode(String.self, forKey: .diedcountry)
        country = try values.decode(String.self, forKey: .country)
        gender = try values.decode(String.self, forKey: .gender)
        name = try values.decode(String.self, forKey: .name)
        //nested
        location = try values.decode(Location.self, forKey: .location)
    }
}

struct Location : Codable {
    var lat : Double = 0
    var lng : Double = 0
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decode(Double.self, forKey: .lat)
        lng = try values.decode(Double.self, forKey: .lng)
    }
}
