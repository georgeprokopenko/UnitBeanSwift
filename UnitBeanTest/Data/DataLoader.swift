//
//  DataLoader.swift
//  UnitBeanTest
//
//  Created by George Prokopenko on 09.02.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

import UIKit
import Alamofire

protocol DataLoaderDelegate: class {
    func articlesDidLoad(data:NSArray?)
    func commentsDidLoad(data:NSArray?)
}

class DataLoader: NSObject {

    weak var delegate: DataLoaderDelegate?
    
    
    
    class func getArticles(success:@escaping (NSArray)-> Void, failure:@escaping (Error)-> Void) -> Void {
        request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            
            if response.result.isSuccess {
                
                guard let recievedArray = response.result.value as? [[String: Any]] else {return}
                var articlesArray: [Article] = []
                
                for object in recievedArray {
                    guard
                        let id = object["id"] as? Int,
                        let title = object["title"] as? String,
                        let text = object["body"] as? String
                    else {
                        return
                    }
                    let article = Article (id: id, title: title, date: nil, text: text, comments: NSMutableArray())
                    
                    articlesArray.append(article)
                }
                success (articlesArray as NSArray)
            }
            
            if response.result.isFailure {
                let error : Error = response.result.error!
                failure(error)
            }
        }
    }
    
    
    
    class func getCommentsForArticle(articleId:Int, success:@escaping (Comment) ->(Void), failure:@escaping (Error) -> Void ) -> (Void) {
        request("https://jsonplaceholder.typicode.com/comments/\(articleId)").responseJSON { response in
            
            if response.result.isSuccess {
                
                let dict = response.result.value as? NSDictionary!
                //print(dict!)
                
                guard
                    let id = dict!["id"] as? Int,
                    let postId = dict!["postId"] as? Int,
                    let name = dict!["email"] as? String,
                    let text = dict!["body"] as? String
                else {
                    return
                }
                let comment = Comment (id: id, postId: postId, date: nil, text: text, userName: name)
                success(comment)
            }
            
            if response.result.isFailure {
                let error : Error = response.result.error!
                failure(error)
            }
            
                
            
        }
    }
    
    
}
