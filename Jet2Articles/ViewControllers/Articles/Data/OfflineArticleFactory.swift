//
//  OfflineArticleFetcher.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 14/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import CoreData

protocol OfflineFetcher {
    func storeDataInDB(completion: (_ success: Bool) -> Void)
    func fetchDataFromDB(completion: (_ success: Bool) -> Void)
}

class OfflineArticleFactory: OfflineFetcher {
    
    var offlineArticles = [Article]()
    
    init() {}
    
    func storeDataInDB(completion: (Bool) -> Void) {
        for article in offlineArticles {
            saveArticlesInDB(article)
        }
        completion(true)
    }
    
    func fetchDataFromDB(completion: (Bool) -> Void) {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<Articles>(entityName: DataModelEntity.articles.rawValue)
        
        do {
            let articlesFromDB: [Articles] = try managedObjectContext.fetch(fetchRequest)
            for dbArticle in articlesFromDB {
                self.offlineArticles.append(Article(id: dbArticle.id ?? "",
                                                   createdAt: dbArticle.createdAt ?? "",
                                                   content: dbArticle.content ?? "",
                                                   comments: Int(dbArticle.comments),
                                                   likes: Int(dbArticle.likes),
                                                   media: fetchMedia(dbArticle.id ?? "") ?? [Media](),
                                                   user: fetchUser(dbArticle.id ?? "") ?? [User]()))
            }
            completion(true)
        } catch let error {
            print(error)
            completion(false)
        }
    }
    
    func checkAndStoreInDB(_ articleID: String) -> Bool {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<Articles>(entityName: DataModelEntity.articles.rawValue)
        let predicate = NSPredicate(format: "id == %@", articleID)
        fetchRequest.predicate = predicate
        do {
            let obj: [Articles] = try managedObjectContext.fetch(fetchRequest)
            if  obj.isEmpty {
                return true
            }
            return false
        } catch {
            print("error while checking data base")
        }
        return false
    }
}

extension OfflineArticleFactory {
    
    func saveArticlesInDB(_ article: Article) {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext()
        let isRecordCanSave = checkAndStoreInDB(article.id)
        let entity = DataModelEntity.articles.rawValue
        let articleManagedObject: Articles = NSEntityDescription.insertNewObject(forEntityName:entity,
                                                                                 into: managedObjectContext) as! Articles
        
        articleManagedObject.comments = Int64(article.comments)
        articleManagedObject.likes = Int64(article.likes)
        articleManagedObject.content = article.content
        articleManagedObject.createdAt = article.createdAt
        articleManagedObject.id = article.id
        for media in article.media {
            saveMediaInDB(articleId: article.id, media: media, context: managedObjectContext)
        }
        
        for user in article.user {
            saveUserInDB(articleId: article.id, user: user, context: managedObjectContext)
        }
        if isRecordCanSave {
            CoreDataManager.shared.saveContext()
        }
    }
    
    func saveMediaInDB(articleId: String, media: Media, context: NSManagedObjectContext) {
        let entity = DataModelEntity.media.rawValue
        let articleManagedObject: ArticleMedia = NSEntityDescription.insertNewObject(forEntityName: entity,
                                                                                     into: context) as! ArticleMedia
        articleManagedObject.articleId = articleId
        articleManagedObject.blogId = media.blogId
        articleManagedObject.createdAt = media.createdAt
        articleManagedObject.id = media.id
        articleManagedObject.image = media.image
        articleManagedObject.title = media.title
        articleManagedObject.url = media.url
    }
    
    func saveUserInDB(articleId: String, user: User, context: NSManagedObjectContext) {
        let entity = DataModelEntity.user.rawValue
        let articleManagedObject: ArticleUser = NSEntityDescription.insertNewObject(forEntityName: entity,
                                                                                    into: context) as! ArticleUser
        articleManagedObject.articleId = articleId
        articleManagedObject.blogId = user.blogId
        articleManagedObject.createdAt = user.createdAt
        articleManagedObject.id = user.id
        articleManagedObject.avatar = user.avatar
        articleManagedObject.city = user.city
        articleManagedObject.designation = user.designation
        articleManagedObject.lastname = user.lastname
        articleManagedObject.about = user.about
        articleManagedObject.name = user.name
    }
}

extension OfflineArticleFactory {
    
    func fetchMedia(_ articleId: String) -> [Media]? {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<ArticleMedia>(entityName: DataModelEntity.media.rawValue)
        let predicate = NSPredicate(format: "articleId == %@", articleId)
        fetchRequest.predicate = predicate
        do {
            let mediaFromDB: [ArticleMedia] = try managedObjectContext.fetch(fetchRequest)
            var media: [Media] = [Media]()
            for dbMedia in mediaFromDB {
                media.append(Media(id: dbMedia.id ?? "",
                                   blogId: dbMedia.blogId ?? "",
                                   createdAt: dbMedia.createdAt ?? "",
                                   image: dbMedia.image ?? "",
                                   title: dbMedia.title ?? "",
                                   url: dbMedia.url ?? ""))
            }
            return media
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func fetchUser(_ articleId: String) -> [User]? {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<ArticleUser>(entityName: DataModelEntity.user.rawValue)
        do {
            let userFromDB: [ArticleUser] = try managedObjectContext.fetch(fetchRequest)
            var user: [User] = [User]()
            for dbUser in userFromDB {
                user.append(User(id: dbUser.id ?? "",
                                 blogId: dbUser.blogId ?? "",
                                 createdAt: dbUser.createdAt ?? "",
                                 name: dbUser.name ?? "",
                                 avatar: dbUser.avatar ?? "",
                                 lastname: dbUser.lastname ?? "",
                                 city: dbUser.city ?? "",
                                 designation: dbUser.designation ?? "",
                                 about: dbUser.about ?? ""))
            }
            return user
        } catch let error {
            print(error)
            return nil
        }
    }
}
