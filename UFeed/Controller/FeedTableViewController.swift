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
    var name : String
    var image : String
    var text : String
    
    
}

class FeedTableViewController: UITableViewController{
    
    var posts = [
        Post(id: 1, name: "12.05", image: "./Apple.jpg", text: "Aristocrats" ),
        Post(id: 2, name: "14.07",  image: "./Apple.jpg", text: "Aristocratssdfgsdlgdshfgsdufgdhfgsdhjfgdsjhfgdsjhfgjdhsgfhjsdgfjhdsgfjhdsgfjhdsgfdjshfgdsjhfgsdhjfghjsdgfhsdjfgsdhfgsdhjfgsdhjfgsdhjfgsdhjfgdshjfgsdjhfgdshjfgdshjfg1231231231231231231231231231231231231231231231231231"),
        Post(id: 3, name: "15.16",  image: "./Apple.jpg", text: "Aristocrats3453453454353454434534534534534534534534543543")
    ]
    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostTableViewCell
        let currentLastItem = posts[indexPath.row]
        cell.post = currentLastItem
        
        return cell
    }
  
        
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
