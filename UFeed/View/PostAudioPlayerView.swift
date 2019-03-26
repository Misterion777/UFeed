//
//  PostAudioPlayerView.swift
//  UFeed
//
//  Created by Ilya on 3/25/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

import NAKPlaybackIndicatorView
import AVFoundation

class PostAudioPlayerView: UIView {
    
    let audioUrl = "https://vk.com/mp3/audio_api_unavailable.mp3"
    var isPlaying = false
    
    lazy var audioItem : AVPlayerItem = {
        return AVPlayerItem(url: URL(string: audioUrl)!)
    }()

    
    lazy var playButton: UIButton = {
        
        let button = UIButton()
        
        //TODO: Change to picture
        button.setTitle("Play!", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        
        button.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        
        return button
    }()
    
    
    
    lazy var indicatorView: NAKPlaybackIndicatorView = {
        let indicator = NAKPlaybackIndicatorView(style: NAKPlaybackIndicatorViewStyle.iOS10())
        
        return indicator!
    }()
    
    lazy var audioLabel : UILabel = {
        let label = UILabel()
        label.text = "Audio Name"
        return label
    }()
    
    
    lazy var timeLabel: UILabel = {
        let time = UILabel()
        
        time.text = "4.33"
        return time
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    init(){
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    private func setup(){
        
        SingleAudioPlayer.shared.replaceCurrentItem(with: audioItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: audioItem)
        
        SingleAudioPlayer.shared.addObserver(self, forKeyPath: "currentItem", options: .new, context: nil)
        
        
        addSubview(playButton)
        addSubview(indicatorView)
        addSubview(audioLabel)
        addSubview(timeLabel)
        
        
        playButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        audioLabel.anchor(top: topAnchor, left: playButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        indicatorView.anchor(top: topAnchor, left: audioLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        timeLabel.anchor(top: audioLabel.bottomAnchor, left: playButton.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
    }
    
    @objc func playAudio(sender: UIButton!){
        
        if isPlaying {
            indicatorView.state = .paused
            SingleAudioPlayer.shared.pause()
            togglePlay(false)
        }
        else {
            if SingleAudioPlayer.shared.currentItem != audioItem {
                //TODO: Change to async
                SingleAudioPlayer.shared.replaceCurrentItem(with: audioItem)
            }
            
            indicatorView.state = .playing
            SingleAudioPlayer.shared.play()
            togglePlay(true)
        }
        
        
    }
    
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        print("playback finished correctly")
        stopPlayer()
        
    }
    private func togglePlay(_ playing: Bool){
        
        isPlaying = playing
        //TODO: Change to picture!
        playButton.setTitle(playing ? "Pause!" : "Play!" , for: .normal)
    }
    
    private func stopPlayer(){
        indicatorView.state = .stopped
        SingleAudioPlayer.shared.seek(to: CMTime.zero)
        togglePlay(false)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "currentItem" {
            print("Somebody else started playing")
            stopPlayer()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}



