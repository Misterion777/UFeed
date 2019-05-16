//
//  InstagramSettingsViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class InstagramSettingsViewController: SettingsViewController {
    
    var pages : [InstagramPage]?
    let headerId = "headerId"
    
    var foundPage : Page?
    var isLoading = false
    var searchController : UISearchController!
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instagram"
        currentSocial = .instagram
        
        tableView.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        self.settings = SettingsManager.shared.getSettings(for: .instagram)        
        setupView()
        
    }
    
    override func fetchOwnerPageDidCompleted (result : Result<Page, DataResponseError>) {
        switch result {
        case .success(let page):
            sections.append(Section(header: .currentAccount, objects: [page], cellId: pageCellId))
            sections.append(Section(header: .pages, objects: self.settings!.pages, cellId: pageCellId))
            reloadData()
        case .failure(let error):
            showError(message: ErrorsParser.parse(error: error))
        }
        self.tableView.reloadData()
    }
    
}


extension InstagramSettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (sections[section].header == .currentAccount) {
            return headerHeight
        }
        else {
            return headerHeight + 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (sections[section].header == .pages) {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! SearchHeaderView
            header.configure(searchBarDelegate: self)
            return header
        }
        return nil
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (sections[section].header == .currentAccount) {
            return sections[section].header.rawValue
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sections[section].header == .currentAccount) {
            return 1
        }
        
        if sections[section].objects == nil {
            return 0
        }
        return sections[section].objects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sections[indexPath.section].cellId, for: indexPath)
        cell.selectionStyle = .none
        if (sections[indexPath.section].header == .currentAccount) {
            if let cell = cell as? SetupSocialViewCell {
                cell.configure(with: .instagram)
                cell.onButtonClick = setupButtonClicked
                return cell
            }
            else {
                let cell = cell as! PageTableViewCell
                let page = sections[indexPath.section].objects![0] as! Page
                cell.configure(with: page, mainPageLogout: logout)
            }
        }
        else {
            
            let pages = sections[indexPath.section].objects as? [Page]
            if (pages != nil) {
                let page = pages![indexPath.row]
                
                let cell = cell as! PageTableViewCell
                cell.configure(with: page,needCheckmark: false)
            }
        }
        return cell
    }
    
}

extension InstagramSettingsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete && sections[indexPath.section].header == .pages) {
            self.sections[indexPath.section].objects!.remove(at: indexPath.row)
            self.settings!.pages!.remove(at: indexPath.row)
            self.toggleSaveButton()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


extension InstagramSettingsViewController : UISearchBarDelegate {
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        findResults(for: searchBar.text!)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.foundPage = nil
        self.tableView.reloadData()
    }

    func findResults(for text: String) {
        if (self.sections[1].objects == nil) {
            self.sections[1].objects = [Any]()
        }
        
        let pages = self.sections[1].objects! as! [InstagramPage]
        if (pages.contains{$0.link == text.lowercased()}) {
            return self.alert(title: "", message: "This page is already in list")
        }
        
        if (!isLoading) {
            isLoading = true
            (self.apiClient! as! InstagramApiClient).fetchPage(by: text) { result in
                switch result{
                case .success(let response):
                    self.foundPage = response                    
                    self.sections[1].objects!.append(response)
                    self.settings!.appendPage(page: response)
                    
                case .failure(let error):
                    print(error)
//                    self.alert(title: "Not found", message: error.localizedDescription)
                    self.foundPage = nil
                }
                self.toggleSaveButton()
                self.tableView.reloadData()                
                self.isLoading = false
            }
        }
    }    
}
