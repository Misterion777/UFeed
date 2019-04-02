import UIKit



class FeedViewController:UIViewController {
    
    let cellId = "cellId"
    private var viewModel : PostsViewModel!
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.isHidden = true
        
        indicatorView.color = .green
        indicatorView.startAnimating()
        
        viewModel = PostsViewModel(delegate: self)
        viewModel.fetchPosts()
        
    }

    
}

extension FeedViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return viewModel.currentCount + VKApiClient.feedSize
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
    
}

extension FeedViewController: PostsViewModelDelegate {
    func onFetchCompleted(with newIndexPathToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        
//        indicatorView.stopAnimating()
//        tableView.isHidden = false
//        tableView.beginUpdates()
//        tableView.insertRows(at: newIndexPathToReload!, with: <#T##UITableView.RowAnimation#>)
//        tableView.endUpdates()
//
        
//        guard let newIndexPathsToReload = newIndexPathToReload else {
//            indicatorView.stopAnimating()
//            tableView.isHidden = false
//            tableView.reloadData()
//            return
//        }
//        // 2
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        
        let alertController = UIAlertController(title: title, message: reason, preferredStyle: .alert)
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
}

extension FeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
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

