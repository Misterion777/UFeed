import UIKit



class FeedViewController:UIViewController {
    
    let cellId = "cellId"
    private var viewModel : PostsViewModel!
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    private var isFetching = false
    var needToReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(rgb: 0xECECEC)
        tableView.separatorStyle = .none
        
        indicatorView.color = .green
        indicatorView.startAnimating()
        
        viewModel = PostsViewModel(delegate: self)
        isFetching = true
        viewModel.fetchPosts()
    }
}

extension FeedViewController : Reloadable {
    func settingsDidSaved() {
        self.needToReload = true
    }
}

extension FeedViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return viewModel.currentCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.post(at: indexPath.row))
        }
        return cell
    }
    
    func reload() {
        if (needToReload) {
            indicatorView.startAnimating()
            tableView.isHidden = true
            viewModel.fetchPosts()
        }
    }
    
}

extension FeedViewController : UITableViewDelegate {


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         print("Cell height: \(cell.frame.size.height)")
        self.cellHeightsDictionary[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height =  self.cellHeightsDictionary[indexPath] {
            return height
        }
        return UITableView.automaticDimension
    }
}

extension FeedViewController: PostsViewModelDelegate {
    func onFetchCompleted(with newIndexPathToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        isFetching = false
        needToReload = viewModel.currentCount == 0
//
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathToReload!)
//        if indexPathsToReload.count == 0 {
//            indicatorView.stopAnimating()
//            tableView.isHidden = false
//            tableView.reloadData()
//        }
//        else {
//            tableView.insertRows(at: indexPathsToReload, with: .automatic)
//        }
//
//        guard let newIndexPathToReload = newIndexPathToReload else {
//            indicatorView.stopAnimating()
//            tableView.isHidden = false
//            tableView.reloadData()
//            return
//        }
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        tableView.isHidden = true
        needToReload = true
        let title = "Error"
        self.alert(title: title, message: reason)
    }
}

extension FeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if (indexPaths.contains(where: isLoadingCell) && !isFetching){
            isFetching = true
            viewModel.fetchPosts()
        }
    }
}

private extension FeedViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

