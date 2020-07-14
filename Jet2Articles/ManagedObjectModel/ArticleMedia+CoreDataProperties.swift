//
//  ArticleMedia+CoreDataProperties.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 13/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//
//

import Foundation
import CoreData


extension ArticleMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleMedia> {
        return NSFetchRequest<ArticleMedia>(entityName: "ArticleMedia")
    }

    @NSManaged public var blogId: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var articleId: String?

}
