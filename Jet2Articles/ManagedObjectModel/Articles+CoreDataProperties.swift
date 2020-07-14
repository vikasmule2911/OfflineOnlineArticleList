//
//  Articles+CoreDataProperties.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 13/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//
//

import Foundation
import CoreData


extension Articles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Articles> {
        return NSFetchRequest<Articles>(entityName: "Articles")
    }

    @NSManaged public var comments: Int64
    @NSManaged public var content: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var id: String?
    @NSManaged public var likes: Int64

}
