//
//  ArticleUser+CoreDataProperties.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 13/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//
//

import Foundation
import CoreData


extension ArticleUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleUser> {
        return NSFetchRequest<ArticleUser>(entityName: "ArticleUser")
    }

    @NSManaged public var about: String?
    @NSManaged public var avatar: String?
    @NSManaged public var blogId: String?
    @NSManaged public var city: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var designation: String?
    @NSManaged public var id: String?
    @NSManaged public var lastname: String?
    @NSManaged public var name: String?
    @NSManaged public var articleId: String?

}
