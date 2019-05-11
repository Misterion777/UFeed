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
import SafariServices


class PostVideoView : UIView {
    
    var isPlaying = false
    var player : AVPlayer!
    var avController = AVPlayerViewController()
    var presentingViewController : UIViewController!
    private var playerDictionary = [Int:VideoAttachment]()
    private var currentVideo : VideoAttachment!
    
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
        button.layer.applySketchShadow(color: UIColor(rgb: 0x8860D0), alpha: 1,x: 2,y: 2)        
        button.isHidden = true
        return button
    }()
    
    func slideShowPageChanged(page:Int) {
        if (playerDictionary.contains{(key,_) in return key == page}){
            currentVideo = playerDictionary[page]
            playButton.isHidden = false
        }
        else {
            playButton.isHidden = true
        }
        
    }
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(playButton)
                
        playButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 170, paddingBottom: 0, paddingRight: 170, width: 100, height: 100, enableInsets: true)
    }
    
    func clear(){
        playerDictionary.removeAll()
        currentVideo = nil
        self.playButton.isHidden = true
    }
    
//    videoName: String, videoUrl : String, duration : Int, platform : String
    func addVideo(pageIndex: Int, video : VideoAttachment) {
        self.playerDictionary[pageIndex] = video
        if (currentVideo == nil) {
            currentVideo = video
            self.playButton.isHidden = false
        }
        
//        if (video.url == nil) {
//            (video as! VKVideoAttachment).videoDidLoaded = { url in
//                self.playerDictionary[pageIndex] = AVPlayer(url: URL(string: url)!)
//                if (self.avController.player == nil) {
//                    self.avController.player = self.playerDictionary[pageIndex]!
//                    self.playButton.isHidden = false
//                }
//
//            }
//        }
//        else {
//            playerDictionary[pageIndex] = AVPlayer(url: URL(string: video.url!)!)
//            if (avController.player == nil) {
//                self.avController.player = self.playerDictionary[pageIndex]!
//                self.playButton.isHidden = false
//            }
//        }
    }
    
    @objc func playVideo(sender: UIButton!){
        if (currentVideo!.platform == "web") {
            let url = URL(string:currentVideo!.url!)!
            let vc = SFSafariViewController(url: url)
            presentingViewController.present(vc, animated: true)
        }
        else {
            print(self.currentVideo!.url!)
            let player = AVPlayer(url: URL(string: self.currentVideo!.url!)!)
            avController.player = player
            presentingViewController.present(avController, animated: true) {
                player.play()
            }
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


