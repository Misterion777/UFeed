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
    
    var apiClient : FacebookApiClient?
    var pages : [FacebookPage]?    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facebook"
        
        pagesTableView.estimatedRowHeight = 44
        pagesTableView.rowHeight = UITableView.automaticDimension
        pagesTableView.register(PageTableViewCell.self, forCellReuseIdentifier: cellId)
        pagesTableView.register(SetupSocialViewCell.self, forCellReuseIdentifier: buttonId)
        
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
            apiClient!.fetchPages(next: nil, completion: updatePages)
        case .failure(let error ):
            self.alert(title: "Eror", message: error.errorDescription!)
        }
        
    }
    
    private func updatePages(result: Result<PagedResponse<Page>, DataResponseError>) {
        switch result {
        case .success(let response):
            let pages = response.objects as? [FacebookPage]
            sections.append(Section(header: .pages, objects: pages, cellId: cellId))
            
            if (!self.settings!.isInitialized() ){
                self.settings!.pages = pages!
            }
            else {
                self.settings!.pages! = self.settings!.pages!.filter {
                    let element = $0
                    return pages!.contains{$0.id == element.id}
                }
            }
            self.settings!.save()
            self.pagesTableView.reloadData()
        case .failure(let error):
            self.alert(title: "Eror", message: error.errorDescription!)
        }
    }
}

extension FacebookSettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sections[indexPath.section].cellId, for: indexPath)
        
        if let cell = cell as? SetupSocialViewCell {
            cell.configure(with: .facebook)
            cell.loginSuccess = setupView
            return cell
        }
        
        if let pages = sections[indexPath.section].objects as? [Page] {
            
            let page = pages[indexPath.row]
            
            let cell = cell as! PageTableViewCell
            cell.configure(with: page)
            
            if (self.settings!.pages!.contains{$0.id == page.id}) {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
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
                self.settings!.pages! = self.settings!.pages!.filter {$0.id != cell.page!.id}
            }
            else {
                cell.accessoryType = .checkmark
                self.settings!.appendPage(page: cell.page!)                
            }
            self.toggleSaveButton()
        }
    }
}
