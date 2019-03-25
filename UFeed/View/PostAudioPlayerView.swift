//
//  PostAudioPlayerView.swift
//  UFeed
//
//  Created by Ilya on 3/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

import NAKPlaybackIndicatorView
import AudioPlayer

//class PostAudioPlayerView: UIView {
//    
//    let audioUrl = ""
//    
//    var audioPlayer : AudioPlayer
//    
//    lazy var playButton: UIButton = {
//        
//        let button = UIButton()
//        
//        button.setTitle("Playe!", for: .normal)
//        
//        button.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
//        
//        return button
//    }()
//    
//    @objc func playAudio(sender: UIButton!){
//        indicatorView.state = .playing
//        
//        
//        
//    }
//    
//    lazy var indicatorView: NAKPlaybackIndicatorView = {
//        let indicator = NAKPlaybackIndicatorView(style: NAKPlaybackIndicatorViewStyle.iOS10())
//        
//        return indicator!
//    }()
//    
//    lazy var audioLabel : UILabel = {
//        let label = UILabel()
//        
//        return label
//    }
//    
//    
//    lazy var timeLabel: UILabel = {
//        let time = UILabel()
//        
//        time.text = "4.33"
//        return time
//    }()
//    
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        setup()
//    }
//    
//    init(){
//        super.init(frame: CGRect.zero)
//        setup()
//    }
//    
//    private func setup(){
//        
//        audioPlayer = AudioPlayer()
//        
//        addSubview(ownerImage)
//        addSubview(ownerNameLabel)
//        addSubview(dateLabel)
//        
//        
//        ownerImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50, enableInsets: false)
//        
//        
//        ownerNameLabel.anchor(top: topAnchor, left: ownerImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
//        
//        dateLabel.anchor(top: ownerNameLabel.bottomAnchor, left: ownerImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
//        
//    }
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
