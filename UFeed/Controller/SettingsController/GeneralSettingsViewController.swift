//
//  GeneralViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift

class GeneralSettingsViewController : SettingsViewController {
    
    let toggleCellId = "toggleCellId"
    private let generalSettings = SettingsManager.shared.getGeneralSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "General"
        tableView.register(ToggleViewCell.self, forCellReuseIdentifier: toggleCellId)
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        self.sections.append(Section(header: .generalFeed, objects: ["Sort feed by date"], cellId: toggleCellId))
    }
    
    override func toggleSaveButton() {
        if (generalSettings.hasChanged()){
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc override func saveButtonClicked() {
        generalSettings.save()
        self.alert(title: "Settings successfully saved!", message: "")        
        toggleSaveButton()
    }
    
    func onToggleOn() {
        generalSettings.set(key: .feedSortedByDate, value: true)
        toggleSaveButton()
    }
    
    func onToggleOff() {
        generalSettings.set(key: .feedSortedByDate, value: false)
        toggleSaveButton()
    }
}

extension GeneralSettingsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].objects!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: sections[indexPath.section].cellId, for: indexPath) as! ToggleViewCell
        
        cell.configure(with: "Sort feed by date", generalSettings.get(key: .feedSortedByDate), onToggleOn, onToggleOff)
        return cell
    }
    
}


class ToggleViewCell : UITableViewCell {
    
    var label = UILabel()
    var switchOnOff = UISwitch()
    
    private var toggleOn : (()->Void)!
    private var toggleOff : (()->Void)!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        switchOnOff.setOn(false, animated: false)
        switchOnOff.onTintColor = UIColor(rgb: 0x5680E9)
        
        switchOnOff.addTarget(self, action: #selector(switchStateDidChange), for: .touchUpInside)
        addSubview(label)
        addSubview(switchOnOff)
        
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        switchOnOff.anchor(top: topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0, enableInsets: false)
    }
    
    @objc func switchStateDidChange(_ sender: UISwitch) {
        if (sender.isOn){
            toggleOn()
        }
        else {
            toggleOff()
        }
    }
    
    func configure(with text: String, _ currentOn: Bool, _ onToggleOn: @escaping ()->Void, _ onToggleOff: @escaping ()->Void) {
        label.text = text
        switchOnOff.setOn(currentOn, animated: false)
        self.toggleOn = onToggleOn
        self.toggleOff = onToggleOff
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

