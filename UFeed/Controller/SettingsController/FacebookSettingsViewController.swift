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
        case pages = "Pages that will be in your feed"
        case other = "Other"
    }
    
    
    let sectionHeaderHeight: CGFloat = 25
    
    @IBOutlet weak var pagesTableView: UITableView!
    let cellId = "fbCellId"
    
    let apiClient = FacebookApiClient()
    var pages : [FacebookPage]?    
    var sections = [SectionHeader]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Facebook"
        
        pagesTableView.estimatedRowHeight = 44
        pagesTableView.rowHeight = UITableView.automaticDimension
        pagesTableView.register(PageTableViewCell.self, forCellReuseIdentifier: cellId)
        
        pagesTableView.dataSource = self
        pagesTableView.delegate = self
        self.settings = SettingsManager.shared.getSettings(for: .facebook)
        
        apiClient.fetchPages(next: nil, completion: updatePages)
        for section in SectionHeader.allCases {
            sections.append(section)
        }
    }
    
    private func updatePages(result: Result<PagedResponse<Page>, DataResponseError>) {
        switch result {
        case .success(let response):
            self.pages = response.objects as? [FacebookPage]
            
            if (!self.settings!.isInitialized() ){
                self.settings!.pagesId = self.pages!.map{ $0.id }
            }
            else {
                self.settings!.pagesId! = self.settings!.pagesId!.filter {
                    let element = $0
                    return self.pages!.contains(where: {$0.id == element})
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
        return sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (sections[section] == .pages) {
            if self.pages == nil {
                return 0
            }
            return self.pages!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PageTableViewCell
        if let pages = pages {
            let page = pages[indexPath.row]
            
            cell.configure(with: page)
            
            if (self.settings!.pagesId!.contains(page.id)) {
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
        if let cell = tableView.cellForRow(at: indexPath) as? PageTableViewCell {
            if (cell.accessoryType == .checkmark) {
                cell.accessoryType = .none
                if let idx = self.settings!.pagesId!.index(of: cell.page!.id) {
                    self.settings!.pagesId!.remove(at: idx)
                }
            }
            else {
                cell.accessoryType = .checkmark
                self.settings!.pagesId!.append(cell.page!.id)
            }
            self.toggleSaveButton()
        }
    }
}
