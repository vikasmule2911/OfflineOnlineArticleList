//
//  Articles.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import UIKit

struct Article: Codable {
    
    var id: String
    let createdAt: String
    let content: String
    let comments: Int
    let likes: Int
    let media: [Media]
    let user: [User]
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case content
        case comments
        case likes
        case media
        case user
    }
    
    var numberOfLikes: String {
        return self.likes.formatUsingAbbrevation() + " Likes"
    }
    
    var numberOfComments: String {
        return self.comments.formatUsingAbbrevation() + " Comments"
    }
}

struct Media: Codable {
    
    let id: String
    let blogId: String
    let createdAt: String
    let image: String
    let title: String
    let url: String
    //@NSManaged var articleId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case blogId
        case createdAt
        case image
        case title
        case url
        //case articleId
    }
}
    
struct User: Codable {
    
    let id: String
    let blogId: String
    let createdAt: String
    let name: String
    let avatar: String
    let lastname: String
    let city: String
    let designation: String
    let about:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case blogId
        case createdAt
        case name
        case avatar
        case lastname
        case city
        case designation
        case about
    }
    
    var userFullName: String {
        return self.name + " " + self.lastname
    }
}
