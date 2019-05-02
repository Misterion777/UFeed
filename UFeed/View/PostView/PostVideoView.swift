//
//  PostVideoView.swift
//  UFeed
//
//  Created by Admin on 02/04/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import NAKPlaybackIndicatorView
import AVFoundation


class PostVideoView : UIView {
    
    var isPlaying = false
    var videoItem : AVPlayerItem
    
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
        button.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        return button
    }()
    
    
    init(videoName: String, videoUrl : String, duration : Int, platform : String) {
        videoItem = AVPlayerItem(url: URL(string: videoUrl)!)
        super.init(frame: CGRect.zero)
        
        setup(videoName: videoName, duration : duration, platform: platform)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(videoName: String, duration : Int, platform : String){
        videoNameLabel.text = videoName
        durationLabel.text = secondsToText(seconds: duration)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: videoItem)
        SingleMediaPlayer.shared.addObserver(self, forKeyPath: "currentItem", options: .new, context: nil)
    }

    @objc private func playerDidFinishPlaying(note: NSNotification) {
        print("playback finished correctly")
        stopPlayer()
    }
    
    private func togglePlay(_ playing: Bool){
        isPlaying = playing
        playButton.setImage(playing ? #imageLiteral(resourceName: "pauseIcon") : #imageLiteral(resourceName: "playIcon") , for: .normal)
    }
    
    private func stopPlayer(){
        SingleMediaPlayer.shared.seek(to: CMTime.zero)
        togglePlay(false)
    }
    
    @objc func playAudio(sender: UIButton!){
        
        if isPlaying {
            SingleMediaPlayer.shared.pause()
            togglePlay(false)
        }
        else {
            if SingleMediaPlayer.shared.currentItem != videoItem {
                SingleMediaPlayer.shared.replaceCurrentItem(with: videoItem)
            }
            
            SingleMediaPlayer.shared.play()
            togglePlay(true)
        }
    }

    private func secondsToText(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        if hours == 0 {
            return "\(minutes):\(seconds)"
        }
        else{
            return "\(hours):\(minutes):\(seconds)"
        }
    }
    
}


