//
//  ArticlesViewCell.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 10/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import UIKit

class ArticlesViewCell: UITableViewCell {

    @IBOutlet weak var viewArticleUrlBackground: UIView!
    @IBOutlet weak var viewArticleBackground: UIView!
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDesignation: UILabel!
    @IBOutlet weak var viewMediaBackground: UIView!
    @IBOutlet weak var imgMedia: UIImageView!
    @IBOutlet weak var lblArticleContent: UILabel!
    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblArticleURL: UIButton!
    @IBOutlet weak var lblLikesCount: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUserAvatar.layer.cornerRadius = imgUserAvatar.frame.height/2
        imgUserAvatar.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
