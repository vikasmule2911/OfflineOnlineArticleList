//
//  ArticlesViewController.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import UIKit

// This protocol set up rule for Viewcontroller to prepare basic UI once confimed any view class

protocol SetUpView {
    func PrepareUI()
}

class ArticlesViewController: UIViewController, SetUpView {
    
    // MARK: - Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var loadMore = true
    var viewModel: ArticlesViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrepareUI()
    }
    
    //MARK: - Set Up All UI Elements
    
    func PrepareUI() {
        self.title = "Articles"
        footerView.isHidden = true
        registerTableViewCell()
        bindViewModel()
        //checkIsOffline()
        fetchOnlineArticles()
    }
    
    private func fetchOnlineArticles() {
        if NetworkConnectionServices.shared.isNetworkReachable() {
            showSpinner(true)
            viewModel.ready()
        } else {
            loadMore = true
            showSpinner(false)
            viewModel.fetchFromDB()
            showErrorMessage("Please check your internet connection and try again.", "No Internet Connection")
        }
    }
    
    private func showSpinner( _ isShow: Bool) {
        isShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // MARK: - ViewModel Data Binding
    
    private func bindViewModel() {
        
        viewModel.didReceivedSuccess = { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.loadMore = true
            strongSelf.showSpinner(false)
            strongSelf.tableView.reloadData()
            //print("Data : \(strongSelf.viewModel.fetchFromStorage() ?? [Articles]())")
        }
        
        viewModel.didReceivedError = { [weak self] errorMessage in
            guard let strongSelf = self else { return }
            strongSelf.showSpinner(false)
            strongSelf.showErrorMessage(errorMessage)
        }
    }
    
    //MARK: - AlertViewController To Show Error Message If any
    
    private func showErrorMessage(_ message: String, _ titleText: String = "") {
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default, handler: { [weak self] _ in
                                        guard let strongSelf = self else { return }
        })
        let alertController = AlertViewFactory.createAlertView(title: titleText,
                                                               message: message,
                                                               actions: [okAction])
        self.present(alertController, animated: true, completion: nil)
        return
    }
    
    //MARK: - UITableView Cell Registration
    
    private func registerTableViewCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 230
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.registerTableViewCell(ArticlesViewCell.self)
    }
    
    func checkIsOffline() {
        if NetworkConnectionServices.shared.isNetworkReachable() {
            CoreDataManager.shared.delete(DataModelEntity.allCases)
        }
    }
}

//MARK: - UITableView Delegates

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let articlesItem = viewModel.articles
        return tableView.dequeueCell(ArticlesViewCell.self, for: indexPath, data: articlesItem, configure: { (cellData, cell) in
            let articles = articlesItem[indexPath.row]
            guard let userData = articles.user.first else { return }
            if let mediaData = articles.media.first {
                cell.viewMediaBackground.isHidden = mediaData.image.isEmpty ? true : false
                cell.imgMedia.loadThumbnail(urlSting: mediaData.image)
                cell.lblArticleTitle.text = mediaData.title
                cell.lblArticleURL.setTitle(mediaData.url, for: .normal)
                cell.viewMediaBackground.isHidden = false
                cell.viewArticleBackground.isHidden = false
                cell.viewArticleUrlBackground.isHidden = false
            } else {
                cell.viewMediaBackground.isHidden = true
                cell.viewArticleBackground.isHidden = true
                cell.viewArticleUrlBackground.isHidden = true
            }
            
            cell.lblUserName.text = userData.userFullName
            cell.lblUserDesignation.text = userData.designation
            cell.lblArticleContent.text = articles.content
            
            cell.lblLikesCount.text = articles.numberOfLikes
            cell.lblCommentCount.text = articles.numberOfComments
            cell.imgUserAvatar.loadThumbnail(urlSting: userData.avatar)
            
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let reachedBottom = maximumOffset - currentOffset
        
        if reachedBottom <= scrollView.frame.size.height &&
            loadMore && viewModel.isMoreRecords &&
            NetworkConnectionServices.shared.isNetworkReachable() {
            loadMore = false
            fetchOnlineArticles()
        }
        footerView.isHidden = !viewModel.isMoreRecords
    }
}
