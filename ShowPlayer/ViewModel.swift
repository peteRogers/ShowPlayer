//
//  ViewModel.swift
//  showReel2023
//
//  Created by Peter Rogers on 17/06/2023.
//

import Foundation
import AVFoundation
import Combine
import AppKit

class ViewModel: ObservableObject {
    @Published var videoCount = 0
    @Published var vids = [VidInfo]()
    @Published var currentStatus = PlayerStatus.notLoaded
    @Published var showList = false
    @Published var showCaption = true
    private var itemObservation: AnyCancellable?
    let player = AVPlayer()
    
    
    
    init(){
        getVideoList()
        loadNext()
        
        playItem()
        NSCursor.hide()
        
    }
    
   
    func getVideoList(){
        do{
            let json = try loadData(name: "vids")
            for j in json{
                let v = getVideoAsset(filename: j.filename)
                let vidInfo = VidInfo(title: j.title, filename: j.filename, name: j.name, item: v, time: v.duration)
                self.vids.append(vidInfo)
            }
        }catch JSONError.jsonError{
            print("no json")
        }catch JSONError.fileLoadError{
            print("no json")
        }catch{
            print("unexpected error")
        }
    }
   
    func loadData(name:String) throws -> [JSONIN]{
        guard let url =  Bundle.main.url(forResource: name, withExtension: "json")
        else{
            throw JSONError.fileLoadError
        }
        guard let jsonData = try? Data(contentsOf: url)
        else{
            throw JSONError.jsonError
        }
        guard let decodedData:[JSONIN] = try? JSONDecoder().decode([JSONIN].self,
                                                                   from: jsonData)
        else{
            throw JSONError.jsonError
        }
        return decodedData
    }
    
    private func getVideoAsset(filename: String)->AVAsset{
        let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil)
       // print(fileUrl)
        let asset = AVAsset(url: fileUrl!)
        let keys = ["duration"]
        asset.loadValuesAsynchronously(forKeys: keys){
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "duration", error: &error)
            switch status{
            case .loaded:
                print("loaded")
                break
            default:
                print("whaaat")
                break
            }
        }
        return asset
    }
   
    func pausePlayer(){
        
        player.pause()
        showList = true
        itemObservation?.cancel()
    }
    
    
    
    func playItem(){
        player.play()
       
        print("from Player")
        itemObservation = player.publisher(for: \.timeControlStatus).sink { newStatus in
            if(newStatus == .paused){
                self.currentStatus = .paused
                self.itemObservation?.cancel()
                if(self.showList == false){
                    self.videoCount += 1
                    if(self.videoCount == self.vids.count){
                        self.videoCount = 0
                    }
                    self.loadNext()
                }
            }
            if(newStatus == .playing){
                self.currentStatus = .playing
            }
        }
    }
    
    func loadNext(){
        do{
            let av = try deliverAsset()
            player.replaceCurrentItem(with: AVPlayerItem(asset:av))
           // NSCursor.unhide()
            showCaption = true
            let _ = Timer.scheduledTimer(withTimeInterval: 2, repeats:false) { timer in
                self.showCaption = false
                self.playItem()
                
            }
        }catch ArrayError.noItem{
            print("no item in array")
        }catch{
            print("unknown error")
        }
    }
    
    func deliverAsset() throws -> AVAsset{
        guard let v = vids[videoCount].item else{
            throw ArrayError.noItem
        }
        return v
    }
    
}//end View Model



struct JSONIN: Codable {
    let title: String
    let filename: String
    let name: String
}

struct VidInfo:Identifiable {
    var title: String
    var filename: String
    var name: String
    var item:AVAsset?
    var time: CMTime?
    var id = UUID()
}

enum JSONError: Error, Equatable {
    case fileLoadError
    case jsonError
}

enum ArrayError: Error{
    case noItem
}

enum PlayerStatus{
    case playing, paused, loading, notLoaded, waiting
}


