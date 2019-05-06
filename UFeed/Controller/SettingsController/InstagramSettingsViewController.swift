//
//  InstagramSettingsViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class InstagramSettingsViewController: SettingsViewController {

    let instagramDelegate = SocialManager.shared.getDelegate(forSocial: .instagram) as! InstagramDelegate
    
    @IBOutlet weak var tableView: UITableView!
    var pages : [InstagramPage]?
    enum SectionHeader: String, CaseIterable {
        case currentAccount = "Your account"
        case pages = "Pages that will be in your feed"
    }
    
    struct Section {
        var header : SectionHeader
        var objects : [Any]?
        var cellId : String
    }
    
    var sections = [Section]()
    let pageId = "pageCellId"
    let buttonId = "buttonCellId"
    let headerId = "headerId"
    
    
    
    var instagramApiClient : InstagramApiClient?
    var foundPage : Page?
    var isLoading = false
    var searchController : UISearchController!
    var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Instagram"
        
        tableView.register(PageTableViewCell.self, forCellReuseIdentifier: pageId)
        tableView.register(SetupSocialViewCell.self, forCellReuseIdentifier: buttonId)
        tableView.register(SearchHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        tableView.dataSource = self
        tableView.delegate = self
        self.settings = SettingsManager.shared.getSettings(for: .instagram)
        
        setupView()
        
    }

    

    private func setupView() {
        if (instagramDelegate.isAuthorized()) {
            sections.removeAll()
            instagramApiClient = SocialManager.shared.getApiClient(forSocial: .instagram) as? InstagramApiClient
            instagramDelegate.getPage(success: pageSuccess)
        } else {
            sections.append(Section(header: .currentAccount, objects: nil, cellId: buttonId))
            self.tableView.reloadData()
        }
    }
    
    private func pageSuccess(page : Page) {
        sections.append(Section(header: .currentAccount, objects: [page], cellId: pageId))
        sections.append(Section(header: .pages, objects: self.settings!.pages, cellId: pageId))
        
        self.tableView.reloadData()
    }
    
}


extension InstagramSettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (sections[section].header == .currentAccount) {
            return 30
        }
        else {
            return 70
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
        if sections[section].objects == nil {
            return 1
        }
        return sections[section].objects!.count
    }
    
    @objc private func onSetupButtonClicked () {
        SocialManager.shared.getDelegate(forSocial: .instagram).authorize(onSuccess: {
            SocialManager.shared.updateClients()
            self.setupView()
        })
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sections[indexPath.section].cellId, for: indexPath)
        
        if let cell = cell as? SetupSocialViewCell {
            cell.configure(with: "Setup your Instagram!")
            cell.onButtonClick = onSetupButtonClicked
            return cell
        }
        
        if let pages = sections[indexPath.section].objects as? [Page] {
            
            let page = pages[indexPath.row]
            
            let cell = cell as! PageTableViewCell
            cell.configure(with: page)
//            if let settingsPages = self.settings?.pagesId {
//                if (settingsPages.contains(page.id)) {
//                    cell.accessoryType = .checkmark
//                }
//                else {
//                    cell.accessoryType = .none
//                }
//            }
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
    
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        findResults(for: searchBar.text!)
//    }

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
            self.instagramApiClient!.fetchPage(by: text) { result in
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
    //
    //    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    //
    //    }
}
