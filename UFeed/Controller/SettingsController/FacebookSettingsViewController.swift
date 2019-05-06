//
//  FacebookSettingsViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class FacebookSettingsViewController: SettingsViewController {

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
    
    let sectionHeaderHeight: CGFloat = 25
    
    @IBOutlet weak var pagesTableView: UITableView!
    let cellId = "fbCellId"
    let buttonId = "buttonCellId"
    let headerMarkId = "headerMarkId"
    
    var apiClient : FacebookApiClient?
    var pages : [FacebookPage]?
    var headerSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facebook"
        
        pagesTableView.estimatedRowHeight = 44
        pagesTableView.rowHeight = UITableView.automaticDimension
        pagesTableView.register(PageTableViewCell.self, forCellReuseIdentifier: cellId)
        pagesTableView.register(SetupSocialViewCell.self, forCellReuseIdentifier: buttonId)
        pagesTableView.register(MarkAllHeaderView.self, forHeaderFooterViewReuseIdentifier: headerMarkId)
        
        pagesTableView.dataSource = self
        pagesTableView.delegate = self
        self.settings = SettingsManager.shared.getSettings(for: .facebook)
        setupView()
    }
    
    private func setupView() {
        if (SocialManager.shared.isAuthorized(forSocial: .facebook)) {
            apiClient = SocialManager.shared.getApiClient(forSocial: .facebook) as? FacebookApiClient
            apiClient!.fetchOwnerPage(completion: updateCurrentPage)
        } else {
            sections.append(Section(header: .currentAccount, objects: nil, cellId: buttonId))
            pagesTableView.reloadData()
        }
    }
    
    private func updateCurrentPage(result: Result<Page, DataResponseError>) {
        switch result {
        case .success(let response):
            sections.append(Section(header: .currentAccount, objects: [response], cellId: cellId))
            if (settings!.isInitialized()) {
                sections.append(Section(header: .pages, objects: nil, cellId: cellId))
                apiClient!.fetchPages(next: nil, completion: updatePages)
            }
            else {
                sections.append(Section(header: .pages, objects: nil, cellId: buttonId))
                self.pagesTableView.reloadData()
            }
        case .failure(let error ):
            self.alert(title: "Eror", message: error.errorDescription!)
        }
        
    }
    
    private func updatePages(result: Result<PagedResponse<Page>, DataResponseError>) {
        switch result {
        case .success(let response):
            pages = response.objects as? [FacebookPage]
            sections[1].objects = pages
            sections[1].cellId = cellId
            if (!self.settings!.isInitialized()){
                self.settings!.pages = pages!
            }
            else {
                self.settings!.pages! = self.settings!.pages!.filter {
                    let element = $0
                    return pages!.contains{$0.id == element.id}
                }
            }
            if (settings!.hasChanged()) {
                self.settings!.save()
            }            
            self.pagesTableView.reloadData()
        case .failure(let error):
            self.alert(title: "Eror", message: error.errorDescription!)
        }
    }
}

// ДЕФОЛТНЫЕ СИНИЕ ГАЛОЧКИ ОТСТОЙ!!!!
// ДЕФОЛТНЫЕ СИНИЕ ГАЛОЧКИ ОТСТОЙ!!!!
extension FacebookSettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (sections[section].header == .pages) {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerMarkId) as! MarkAllHeaderView
            header.configure(buttonPressed: toggleMarkHeader)
            return header
        }
        return nil
    }
    
    private func toggleMarkHeader() {
        if (settings!.isInitialized()) {
            if (headerSelected) {
                settings!.pages!.removeAll()
                headerSelected = false
            }
            else {
                for page in sections[1].objects as! [FacebookPage] {
                    settings!.appendPage(page: page)
                }
                headerSelected = true
            }
            toggleSaveButton()
            pagesTableView.reloadData()
        }        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].objects == nil {
            return 1
        }
        return sections[section].objects!.count
    }
    
    
     private func onSetupButtonClicked () {
        SocialManager.shared.getDelegate(forSocial: .facebook).authorize(onSuccess: {
            SocialManager.shared.updateClients()
            self.setupView()
        })
    }
    
    private func onLoadLikes () {
        (SocialManager.shared.getDelegate(forSocial: .facebook) as! FacebookDelegate).getUserLikesPermissions {
            self.apiClient!.fetchPages(next: nil, completion: self.updatePages)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sections[indexPath.section].cellId, for: indexPath)
        
        if (sections[indexPath.section].header == .currentAccount) {
            if let cell = cell as? SetupSocialViewCell {
                cell.configure(with: "Setup your Facebook!")
                cell.onButtonClick = onSetupButtonClicked
                return cell
            }
            else {
                let cell = cell as! PageTableViewCell
                let page = sections[indexPath.section].objects![0] as? Page
                cell.configure(with: page)
            }
        }
        else {
            if let cell = cell as? SetupSocialViewCell {
                cell.configure(with: "Load liked pages from Facebook")
                cell.onButtonClick = onLoadLikes
                return cell
            }
            else {
                let pages = sections[indexPath.section].objects as? [Page]
                    
                let page = pages![indexPath.row]
                
                let cell = cell as! PageTableViewCell
                cell.configure(with: page)
                
                if (self.settings!.pages!.contains{$0.id == page.id}) {
                    cell.accessoryType = .checkmark // ДЕФОЛТНЫЕ СИНИЕ ГАЛОЧКИ ОТСТОЙ!!!!
                }
                else {
                    cell.accessoryType = .none
                }
            }
            
        }
        
        return cell
    }
    
}

extension FacebookSettingsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) as? PageTableViewCell {
            if (cell.accessoryType == .checkmark) {
                cell.accessoryType = .none
                self.settings!.removePage(by: cell.page!.id)                
            }
            else {
                cell.accessoryType = .checkmark
                self.settings!.appendPage(page: cell.page!)                
            }
            self.toggleSaveButton()
        }
    }
}
