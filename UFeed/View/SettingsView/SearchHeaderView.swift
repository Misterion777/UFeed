//
//  SearchHeaderView.swift
//  UFeed
//
//  Created by Ilya on 5/2/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class SearchHeaderView : UITableViewHeaderFooterView {
    
    var searchBar : UISearchBar!
    
    lazy var label: UILabel = {
        let ownerName = UILabel()
        ownerName.textColor = .black
        ownerName.font = UIFont.boldSystemFont(ofSize: 16)
        ownerName.textAlignment = .left
        return ownerName
    }()
    
    func configure(searchBarDelegate : UISearchBarDelegate) {
        searchBar = UISearchBar()
        searchBar.delegate = searchBarDelegate
        searchBar.placeholder = "Search instagram business pages"
        
        label.text = "Business pages that will be in your feed"
        subviewFields()
    }
    
    
    func subviewFields() {
        
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        addSubview(searchBar)
        searchBar.anchor(top: label.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
    }
    
}


