//
//  AlertViewFactory.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import UIKit

class AlertViewFactory {
    
    static func createAlertView(title: String?,
                                message: String?,
                                actions: [UIAlertAction],
                                preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        actions.forEach { alertView.addAction($0) }
        
        return alertView
    }
}
