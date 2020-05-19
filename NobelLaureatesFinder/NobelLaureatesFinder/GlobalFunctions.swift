//
//  GlobalFunctions.swift
//  NobelLaureatesFinder
//
//  Created by Ethan Hess on 5/16/20.
//  Copyright © 2020 Ethan Hess. All rights reserved.
//

import Foundation
import UIKit

class GlobalFunctions {
    static func presentAlert(title: String, text: String, fromVC: UIViewController) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        fromVC.present(alertController, animated: true, completion: nil)
    }
}
