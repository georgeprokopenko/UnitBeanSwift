//
//  DetailViewController.swift
//  UnitBeanTest
//
//  Created by George Prokopenko on 09.02.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    // OBJECTS
    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var tableView: UITableView?
    var article: Article!
    let iconsArray = ["icon1.png", "icon2.png", "icon3.png", "icon4.png", "icon5.png"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        label?.text = article.title
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (article.comments?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let textCell: ArticleTextCell = tableView.dequeueReusableCell(withIdentifier: "ArticleTextCell", for: indexPath) as! ArticleTextCell
            textCell.textView.text = article.text
            return textCell
            
        } else {
            
            let commentCell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            
            commentCell.userAvatar.layer.cornerRadius = commentCell.userAvatar.bounds.size.width/2
            commentCell.userAvatar.backgroundColor = navigationController?.navigationBar.barTintColor
            
            if (article.comments?.count) != 0 {
                let comment = article.comments!.object(at: indexPath.row - 1) as! Comment
                commentCell.userNameLabel.text = comment.userName
                commentCell.userCommentLabel.text = comment.text
                commentCell.dateLabel.text = "9 Февраля, 2018"
                
                let iconName: String! = iconsArray.randomItem()
                commentCell.userAvatar.image = UIImage.init(named: iconName)
            }
            
            return commentCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    
}


//RANDOM
extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
