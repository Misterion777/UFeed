//
//  SettingsViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let headerHeight : CGFloat = 50.0
    
    enum SectionHeader: String, CaseIterable {
        case currentAccount = "Your account"
        case pages = "Pages that will be in your feed"
        case generalFeed = "Feed settings"
    }
    
    struct Section {
        var header : SectionHeader
        var objects : [Any]?
        var cellId : String
    }
    
    let pageCellId = "pageCellId"
    let buttonCellId = "buttonCellId"
    
    var tableView : UITableView!
    var indicatorView : UIActivityIndicatorView!
    var errorView: ErrorView!
    
    var settings : Settings?
    var sections = [Section]()
    var currentSocial : Social!
    var apiClient : ApiClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        let safeArea = view.safeAreaLayoutGuide    
        
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.color = UIColor(rgb: 0x8860D0)
        indicatorView.hidesWhenStopped = true
        
        view.addSubview(indicatorView)
        indicatorView.center = view.center        
        
        tableView = UITableView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PageTableViewCell.self, forCellReuseIdentifier: pageCellId)
        tableView.register(SetupSocialViewCell.self, forCellReuseIdentifier: buttonCellId)
        
        view.addSubview(tableView)
        tableView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        addErrorView()        
        
        let burger = UIBarButtonItem(image: #imageLiteral(resourceName: "burger"), style: .plain, target: self, action: #selector(burgerButtonClicked))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonClicked))       
        
        saveButton.isEnabled = false
        self.navigationItem.leftBarButtonItem = burger
        self.navigationItem.rightBarButtonItem = saveButton
        SocialManager.shared.setViewController(vc: self)
        let tabBarController = self.navigationController!.tabBarController!
        if tabBarController.viewControllers![0] is SignInViewController {
            tabBarController.viewControllers?.removeFirst(1)
            tabBarController.tabBar.isHidden = false
        }
        let reloadbleFeedVC = tabBarController.viewControllers![0] as! Reloadable
        SettingsManager.shared.setReloadable(reloadable: reloadbleFeedVC)        
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
    
    func showError(message : String) {
        tableView.isHidden = true
        errorView.isHidden = false
        errorView.setErrorMessage(with: message)
    }
    
    func reloadData(){
        self.indicatorView.stopAnimating()
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func setupView() {
        sections.removeAll()
        if (SocialManager.shared.isAuthorized(forSocial: currentSocial)) {
            tableView.separatorStyle = .singleLine
            apiClient = SocialManager.shared.getApiClient(forSocial: currentSocial)
            self.tableView.isHidden = true
            indicatorView.startAnimating()
            apiClient.fetchOwnerPage(completion: fetchOwnerPageDidCompleted)
        }
        else {
            tableView.separatorStyle = .none
            sections.append(Section(header: .currentAccount, objects: nil, cellId: buttonCellId))
            tableView.reloadData()
        }        
    }
    
    func fetchOwnerPageDidCompleted (result : Result<Page, DataResponseError>){
    }
    
    func toggleSaveButton() {
        if (settings!.hasChanged()){
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }        
    }
    
    func logout() {
        self.alert(title: "Logout", message: "Are you sure you want to logout?", ok: { action in
            SocialManager.shared.logOut(via: self.currentSocial)
            self.setupView()
        }, cancel: { action in
            print("canceled")
        })        
    }
    
    @objc func setupButtonClicked () {
        SocialManager.shared.getDelegate(forSocial: currentSocial).authorize(onSuccess: {
            SocialManager.shared.updateClients()
            self.setupView()
        })
    }
    
    @objc func saveButtonClicked() {
        settings!.save()
        self.alert(title: "Settings successfully saved!", message: "")
        print(self.settings!.pages!)
        toggleSaveButton()
    }
    
    @objc func burgerButtonClicked() {
        sideMenuController?.revealMenu()
    }
    
}

