//
//  ContentView.swift
//  showReel2023
//
//  Created by Peter Rogers on 17/06/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        ZStack {
            if viewModel.showList {
                
                ListView(model: viewModel).onTapGesture {
                    
                }                       }
            else {
                PlayerView(player: viewModel.player).onTapGesture {
                    viewModel.showList = true
                    viewModel.pausePlayer()
                    print("unhide requested")
                    // NSCursor.unhide()
                    
                }
            }
            if viewModel.showCaption{
                CaptionView().environmentObject(viewModel)
            }
        }
        
        
    }
}

struct CaptionView: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {

        ZStack{
            Rectangle().fill(.black)
            VStack{
                Text("\(viewModel.vids[viewModel.videoCount].title)" as String)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 100)
                    .padding(.bottom, 20)
            Text("\(viewModel.vids[viewModel.videoCount].name)" as String)
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 100)
            }
        }.transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                                 removal: .opacity.animation(.easeInOut(duration: 1))))
    }
}

struct VideoView: View {
    var body: some View {
        Rectangle().fill(.red)
        Text("video View")
            .font(.largeTitle)
    }
}

struct ListView: View {
    @ObservedObject var model:ViewModel
    // @Environment(\.dismiss) var dismiss
    var body: some View {
        
        
        VStack{
            List {
                ForEach(Array(model.vids.enumerated()), id: \.1.id) { (index, item) in
                    HStack {
                      
                        if(index == model.videoCount){
                            Text(item.name).font(.largeTitle).lineLimit(1).foregroundColor(.red)
                            Text(", ").font(.largeTitle).lineLimit(1).foregroundColor(.red)
                            Text(item.title).font(.largeTitle).lineLimit(1).foregroundColor(.red)
                        }
                        else{
                            Text(item.name).font(.largeTitle).lineLimit(1).foregroundColor(.black)
                            Text(", ").font(.largeTitle).lineLimit(1).foregroundColor(.black)
                            Text(item.title).font(.largeTitle).lineLimit(1).foregroundColor(.black)
                        }
                        
                        Spacer()
                        Button(action: {
                           
                            print(index)
                            model.showList = false
                            model.videoCount = index
                            model.loadNext()
                            print(item.title)
                        },label: {
                            Image(systemName: "play.rectangle")
                                .font(Font.system(.largeTitle))
                                .foregroundStyle(.red)
                        }).buttonStyle(.plain)
                            .padding()
                        //Spacer()
                        
                    }
                    .padding()
                    .listRowBackground(Color.white)
                }.background(.white)
                
            }
            
            Button(action: {
               
                print(index)
                model.showList = false
                model.player.play()
               
               
            },label: {
                Image(systemName: "xmark.circle")
                    .font(Font.system(.largeTitle))
                    .foregroundStyle(.red)
            }).buttonStyle(.plain)
                .padding(10)
            Spacer()
            
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
