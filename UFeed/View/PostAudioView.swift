import UIKit

import NAKPlaybackIndicatorView
import AVFoundation

class PostAudioView: UIView {
    
    var isPlaying = false
    
    var audioItem : AVPlayerItem    
    
    lazy var playButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
        
        button.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        
        return button
    }()
    
    lazy var indicatorView: NAKPlaybackIndicatorView = {
        let indicator = NAKPlaybackIndicatorView(style: NAKPlaybackIndicatorViewStyle.iOS10())
        
        return indicator!
    }()
    
    lazy var audioNameLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    lazy var durationLabel : UILabel = {
        let time = UILabel()
        return time
    }()
    
    init(audioName: String, audioUrl : String, duration : String){
        audioItem = AVPlayerItem(url: URL(string: audioUrl)!)
        super.init(frame: CGRect.zero)
        
        setup(audioName: audioName, duration : duration)
    }
    
    private func setup(audioName: String, duration : String){
        
        audioNameLabel.text = audioName
        durationLabel.text = duration
        
        SingleAudioPlayer.shared.replaceCurrentItem(with: audioItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: audioItem)
        
        SingleAudioPlayer.shared.addObserver(self, forKeyPath: "currentItem", options: .new, context: nil)
        
        
        addSubview(playButton)
        addSubview(indicatorView)
        addSubview(audioNameLabel)
        addSubview(durationLabel)
        
        
        playButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        audioNameLabel.anchor(top: topAnchor, left: playButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        indicatorView.anchor(top: topAnchor, left: audioNameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        durationLabel.anchor(top: audioNameLabel.bottomAnchor, left: playButton.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
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
        playButton.setImage(playing ? #imageLiteral(resourceName: "pauseIcon") : #imageLiteral(resourceName: "playIcon") , for: .normal)
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
