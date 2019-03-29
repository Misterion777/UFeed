import UIKit

struct Post{
    var id : Int
    var ownerImage : String
    var ownerName : String
    var date : Date
    var  text : String
    var attachments: [Attachment]
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
}
