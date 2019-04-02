import UIKit



class FeedTableViewController: UITableViewController{

    let cellId = "cellId"

    var posts = [Post]()
    
    var postsInitialized = false
    let semaphore = DispatchSemaphore(value: 0)
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        
        VKApiWorker.getNewsFeed(onResponse: setupPosts)
    }
    
    private func setupPosts(postsJson: [[String:Any]] ){
        print(postsJson)
//        posts = VKPost.from(postsJson as NSArray)
        for postJson in postsJson {
            let post = VKPost.from(postJson as NSDictionary)
            
            VKApiWorker.getOwnerInfo(post: post!, onResponse: setupPost)
            
//            semaphore.wait()
        }
    }
    
    private func setupPost(pageInfo: [String:Any], post: Post) {
        
        var pageName : String?
        var photo : VKPhotoAttachment?
        
        if let name = pageInfo["name"] as? String {
            pageName = name
        }
        else if let first_name = pageInfo["first_name"] as? String,
            let last_name = pageInfo["last_name"] as? String {
            pageName = first_name + " " + last_name
        }
        
        if let photoUrl = pageInfo["photo_50"] as? String {
            photo = VKPhotoAttachment(url: photoUrl, height: 50, width: 50)
        }
        
        post.ownerPhoto = photo
        post.ownerName = pageName
        
        posts.append(post)
        self.tableView.reloadData()
        
//        self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        i += 1

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VKApiWorker.feedSize
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostTableViewCell
        if (indexPath.row < posts.count) {
            let currentLastItem = posts[indexPath.row]
            
            cell.post = currentLastItem
            
            
        }
        return cell
    }
}
