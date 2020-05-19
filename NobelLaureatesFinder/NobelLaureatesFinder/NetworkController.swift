//
//  NetworkController.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/15/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import Foundation

class NetworkController {
    static func fetchDataFromJSON(theURL : URL, completion : @escaping((_ nobelLaureates : [NobelLaureate]?, _ error: Error?) -> Void)) {
        URLSession.shared.dataTask(with: theURL) { (data, response, error) in
            if (error != nil) {
                completion(nil, error)
            } else {
                guard let data = data else { return }
                do {
                    let laureates = try JSONDecoder().decode([NobelLaureate].self, from: data)
                    Logger.log("\(laureates)")
                    completion(laureates, nil)
                } catch let JSONError {
                    Logger.log("--- JSON Error --- \(JSONError)")
                    completion(nil, JSONError)
                }
            }
        }.resume() //If task gets suspended, this continues it
    }
}
