//
//  ListViewController.swift
//  UnitBeanTest
//
//  Created by George Prokopenko on 07.02.2018.
//  Copyright © 2018 George Prokopenko. All rights reserved.
//

import UIKit
import SVProgressHUD

class ListViewController: UITableViewController {
    
    
    
    
    
    let cellID = "ArticleCell"
    var articlesArray: NSArray?
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.barTintColor = UIColor(rgb:0xd53824)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        SVProgressHUD.show(withStatus: "Загрузка")
        DataLoader.getArticles(success: { (receivedArticles) in
            SVProgressHUD.dismiss()
            self.articlesArray = receivedArticles
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }) { (error) in
            SVProgressHUD.dismiss()
            print(error)
        }
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articlesArray == nil { return 0 }
        return (articlesArray?.count)!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ArticleCell
        
        if articlesArray == nil {
            return cell
        }
        
        let article: Article? = articlesArray?.object(at: indexPath.row) as! Article?
        
        cell.titleLabel.text = article?.title
        cell.dateLabel.text = "9 Февраля, 2018"
        
        let articleText: String? = article?.text
        var trimmedText: String?
        if let text = articleText, text.count > 120 {
            trimmedText = (text as NSString).substring(to: 117)
            trimmedText = trimmedText! + "..."
        }
        
        cell.textView.text = trimmedText ?? article?.text
        
        DataLoader.getCommentsForArticle(articleId: article!.id, success: { (comment) -> Void in
            article?.comments?.removeAllObjects()
            article?.comments?.add(comment)
            cell.commentsCounter.text = "\(article?.comments?.count ?? 0)"
        }) { (error) in
            print(error)
        }
    
        cell.innerView.layer.shadowColor = UIColor.black.cgColor
        cell.innerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.innerView.layer.shadowRadius = 2
        cell.innerView.layer.shadowOpacity = 0.25
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : UIView! = UIView()
        header.frame = CGRect(x:0, y:0, width: self.view.bounds.width, height: 20)
        header.backgroundColor = UIColor.clear
        return header
    }
    
    var articleToPass: Article?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article: Article? = articlesArray?.object(at: indexPath.row) as! Article?
        articleToPass = article!
        
        performSegue(withIdentifier: "ArticleDetail", sender: Any?.self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ArticleDetail" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.article = articleToPass
            }
        }
    }

    
}










// COLORS
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
