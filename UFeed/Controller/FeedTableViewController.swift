//
//  FeedTableViewController.swift
//  UFeed
//
//  Created by Admin on 21/03/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

struct Post{
    var id : Int
    var headerTimeLabel : String
    var headerImage : String
    var headerGroupNameLabel : String
}

class PostTableViewCell: UITableViewCell{
    @IBOutlet weak var headerGroupNameLabel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTimeLabel: UILabel!
}


class FeedTableViewController: UITableViewController{

    var posts = [
        Post(id: 1, headerTimeLabel: "12.05", headerImage: "./Apple.jpg",headerGroupNameLabel: "Aristocrats" ),
        Post(id: 2, headerTimeLabel: "14.07",  headerImage: "./Apple.jpg", headerGroupNameLabel: "Aristocrats"),
        Post(id: 3, headerTimeLabel: "15.16",  headerImage: "./Apple.jpg", headerGroupNameLabel: "Aristocrats")
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200.0;
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
            as! PostTableViewCell
        
        
        
        let headline = posts[indexPath.row]
        cell.headerGroupNameLabel?.text = headline.headerGroupNameLabel
        cell.headerTimeLabel?.text = headline.headerTimeLabel
        cell.headerImage?.image = UIImage(named: headline.headerImage)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
//    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//
//        let widthRatio  = targetSize.width  / image.size.width
//        let heightRatio = targetSize.height / image.size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
////        if(widthRatio > heightRatio) {
////            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
////        } else {
////            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
////        }

 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
