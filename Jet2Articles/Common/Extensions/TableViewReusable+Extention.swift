//
//  TableViewReusable+Extention.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 10/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView, NibLoadableView { }

extension UITableView {
    
    func registerTableViewCell<T: UITableViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueCell<T, U>(_ type: T.Type,
                           for indexPath: IndexPath,
                           data: U,
                           configure: (U, T) -> Void) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with ID: \(T.defaultReuseIdentifier)")
        }
        configure(data, cell)
        return cell
    }
}

extension UITableView{

    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil{
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.isHidden = false
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.isHidden = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }else{
            return activityIndicatorView
        }
    }

    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)) {
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
        indicatorView().isHidden = false
    }

    func stopLoading() {
        indicatorView().stopAnimating()
        indicatorView().isHidden = true
    }
}
