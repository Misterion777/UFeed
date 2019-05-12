//
//  TwitterSettingsViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SafariServices

class TwitterSettingsViewController: SettingsViewController, SFSafariViewControllerDelegate {
    let headerMarkId = "headerMarkId"
    var headerSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Twitter"
        currentSocial = .twitter
        
        tableView.register(MarkAllHeaderView.self, forHeaderFooterViewReuseIdentifier: headerMarkId)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.settings = SettingsManager.shared.getSettings(for: .twitter)
        setupView()
    }
    
    override func fetchOwnerPageDidCompleted(result: Result<Page, DataResponseError>) {
        switch result {
        case .success(let response):
            sections.append(Section(header: .currentAccount, objects: [response], cellId: pageCellId))
            sections.append(Section(header: .pages, objects: nil, cellId: pageCellId))
            apiClient!.fetchPages(next: nil, completion: updatePages)            
        case .failure(let error ):
            self.alert(title: "Eror", message: error.errorDescription!)
        }
        
    }
    
    private func updatePages(result: Result<PagedResponse<Page>, DataResponseError>) {
        switch result {
        case .success(let response):
            let pages = response.objects as? [TwitterPage]
            sections[1].objects = pages
            sections[1].cellId = pageCellId
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
            reloadData()
        case .failure(let error):
            self.alert(title: "Eror", message: error.errorDescription!)
        }
    }

}

extension TwitterSettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
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
                for page in sections[1].objects as! [TwitterPage] {
                    settings!.appendPage(page: page)
                }
                headerSelected = true
            }
            toggleSaveButton()
            tableView.reloadData()
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
    
    private func onLoadLikes () {
        (SocialManager.shared.getDelegate(forSocial: .facebook) as! FacebookDelegate).getUserLikesPermissions {
            self.apiClient!.fetchPages(next: nil, completion: self.updatePages)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sections[indexPath.section].cellId, for: indexPath)
        
        if (sections[indexPath.section].header == .currentAccount) {
            if let cell = cell as? SetupSocialViewCell {
                cell.configure(with: "Setup your Twitter!")
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
            
            let page = pages![indexPath.row]
            
            let cell = cell as! PageTableViewCell
            cell.configure(with: page)
            
            if (self.settings!.pages!.contains{$0.id == page.id}) {
                cell.toggle(check: true)
            }
            else {
                cell.toggle(check: false)
            }
            
        }
        
        return cell
    }
    
}

extension TwitterSettingsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) as? PageTableViewCell {
            if cell.checked {
                self.settings!.removePage(by: cell.page!.id)
            }
            else {
                self.settings!.appendPage(page: cell.page!)
            }
            cell.toggle()
            self.toggleSaveButton()
        }
    }
}
