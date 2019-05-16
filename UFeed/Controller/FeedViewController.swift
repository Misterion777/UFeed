import UIKit

import SafariServices

class FeedViewController:UIViewController, SFSafariViewControllerDelegate {
    
    let cellId = "cellId"
    private var viewModel : PostsViewModel!
    private var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var errorView: ErrorView!
    
    
    private var isFetching = false
    var needToReload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        
        tableView.dataSource = self
//        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(rgb: 0xECECEC)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        addErrorView()
        
        indicatorView.color = UIColor(rgb: 0x8860D0)
        indicatorView.startAnimating()
        
        viewModel = PostsViewModel(delegate: self)
        isFetching = true
        viewModel.fetchPosts()
    }
    
    func addErrorView() {
        errorView = ErrorView()
        view.addSubview(errorView)
        let safeArea = view.safeAreaLayoutGuide
        errorView.anchor(top:  nil, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        errorView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        errorView.isHidden = true
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
        cell.configureVideo(with: self)
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.post(at: indexPath.row))
        }
        cell.layoutIfNeeded()
        
        
        return cell
    }
    
    func reload() {
        if (needToReload) {
            indicatorView.startAnimating()
            tableView.isHidden = true            
            viewModel.fetchPosts(reload: true)
        }
    }
}

extension FeedViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         print("Cell height: \(cell.frame.size.height)")
        
        if (indexPath.row == viewModel.currentCount - 2 && !isFetching) {
            isFetching = true
            viewModel.fetchPosts()
        }
        
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
    
    func getIndexToInsertNewPosts() -> Int {
        if (tableView.indexPathsForVisibleRows == nil) {
            return 0
        }
        return tableView.indexPathsForVisibleRows!.last!.row
    }
    
    func onFetchCompleted(with newIndexPathToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        
        tableView.isHidden = false
        errorView.isHidden = true
        
        tableView.reloadData()
        
        if (viewModel.currentCount == 0) {
            tableView.isHidden = true
            errorView.isHidden = false
            
            errorView.setErrorMessage(with: "Zero posts returned.\nSeems your settings are a bit incorrect...")  
            needToReload = true
        }
        else {
            needToReload = false
        }
        isFetching = false
        
        
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
        errorView.isHidden = false
        
        errorView.setErrorMessage(with: reason)
        needToReload = true
        if (reason.contains("No internet connection")) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                self.viewModel.fetchPosts()
            })
        }
        isFetching = false
    }
}

extension FeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let index = indexPaths.firstIndex {$0.row == viewModel.currentCount}
        if (index != nil) {
            if (index! < viewModel.currentCount / 2 && !isFetching) {
                isFetching = true
                viewModel.fetchPosts()
            }
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

