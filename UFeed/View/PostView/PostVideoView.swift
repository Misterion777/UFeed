//
//  PostVideoView.swift
//  UFeed
//
//  Created by Admin on 02/04/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit


class PostVideoView : UIView {
    
    var isPlaying = false
    var player : AVPlayer!
    var avController = AVPlayerViewController()
    var presentingViewController : UIViewController!
    
    lazy var videoNameLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    lazy var durationLabel : UILabel = {
        let time = UILabel()
        return time
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
        button.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(playButton)
        playButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30, enableInsets: true)
    }
    
//    videoName: String, videoUrl : String, duration : Int, platform : String
    func configure(videoUrl : String) {
        player = AVPlayer(url: URL(string: videoUrl)!)
        avController.player = player
        playButton.isHidden = false
    }
    
    @objc func playVideo(sender: UIButton!){
        presentingViewController.present(avController, animated: true) {
            self.player.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//    func setup(videoName: String, duration : Int, platform : String){
//        videoNameLabel.text = videoName
//        durationLabel.text = secondsToText(seconds: duration)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: videoItem)
//        SingleMediaPlayer.shared.addObserver(self, forKeyPath: "currentItem", options: .new, context: nil)
//    }
//
//    @objc private func playerDidFinishPlaying(note: NSNotification) {
//        print("playback finished correctly")
//        stopPlayer()
//    }
//
//    private func togglePlay(_ playing: Bool){
//        isPlaying = playing
//        playButton.setImage(playing ? #imageLiteral(resourceName: "pauseIcon") : #imageLiteral(resourceName: "playIcon") , for: .normal)
//    }
//
//    private func stopPlayer(){
//        SingleMediaPlayer.shared.seek(to: CMTime.zero)
//        togglePlay(false)
//    }
//
//
//
//    private func secondsToText(seconds: Int) -> String {
//        let hours = seconds / 3600
//        let minutes = (seconds % 3600) / 60
//        let seconds = (seconds % 3600) % 60
//        if hours == 0 {
//            return "\(minutes):\(seconds)"
//        }
//        else{
//            return "\(hours):\(minutes):\(seconds)"
//        }
//    }
    
}


