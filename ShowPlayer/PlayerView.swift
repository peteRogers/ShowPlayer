//
//  PlayerView.swift
//  showReel2023
//
//  Created by Peter Rogers on 17/06/2023.
//

import Foundation
import UIKit
import AVFoundation
import SwiftUI


class PlayerUIView: UIView{
    private let playerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(player: AVPlayer) {
        self.player = player
        super.init(frame: .zero)
        self.backgroundColor = .black
       // player.isMuted = true // just in case
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        player.actionAtItemEnd = .pause
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspect
       
    }
    
}

struct PlayerView: UIViewRepresentable {
    var player:AVPlayer?
    init(player:AVPlayer ) {
        self.player = player
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
     
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player:player!)
    }
}

