//
//  Storyboard+Extension.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import UIKit

// The uniform place where we state all the storyboard we have in our application
// If we Will be having multiple storyboard in project we can esaly maintain with enum so that no need to have any mistake in string.
extension UIStoryboard {
    
    enum Storyboard: String {
        case main = "Main"
        
        case dash
        var filename: String {
            return rawValue.capitalized
        }
    }

//Create own initializer and Pass storyboard name using enums cases
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

/// Storyboard identifiers is UIViewController name that  we create, i.e identifies name for subclass Of UIViewController.

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

//protocol extension declaration, there is a where clause which makes it only apply to classes that are either UIViewController or it’s subclasses
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

//Conform protocol UIViewController..
extension UIViewController: StoryboardIdentifiable { }
