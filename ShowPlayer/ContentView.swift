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
			PlayerView(player: viewModel.player)
				.onTapGesture {
					viewModel.showList = true
					viewModel.pausePlayer()
				}
				.zIndex(0)
			if viewModel.showList {
				Rectangle().fill(.black).edgesIgnoringSafeArea(.all)
				ListView(model: viewModel)
					.padding(.horizontal, 100)
					.padding(.top, 100)
					.zIndex(1)
			}
			if viewModel.showCaption {
				CaptionView()
					.environmentObject(viewModel)
					.zIndex(2)
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

//struct ListView: View {
//	@ObservedObject var model:ViewModel
//	// @Environment(\.dismiss) var dismiss
//	var body: some View {
//		
//		
//		VStack{
//			List {
//				ForEach(Array(model.vids.enumerated()), id: \.1.id) { (index, item) in
//					HStack {
//						if(index == model.videoCount){
//							Text(item.name).font(.largeTitle).lineLimit(1).foregroundColor(.red)
//							Text(", ").font(.largeTitle).lineLimit(1).foregroundColor(.red)
//							Text(item.title).font(.largeTitle).lineLimit(1).foregroundColor(.red)
//						}
//						else{
//							Text(item.name).font(.largeTitle).lineLimit(1).foregroundColor(.black)
//							Text(", ").font(.largeTitle).lineLimit(1).foregroundColor(.black)
//							Text(item.title).font(.largeTitle).lineLimit(1).foregroundColor(.black)
//						}
//						Spacer()
//						Button(action: {
//							print("foofoofoof")
//							model.showList = false
//							model.videoCount = index
//							model.loadNext()
//							print(item.title)
//						},label: {
//							Image(systemName: "play.rectangle")
//								.font(Font.system(.largeTitle))
//								.foregroundStyle(.red)
//						}).buttonStyle(.plain)
//							.padding()
//					}
//					.padding()
//					.listRowBackground(Color.white)
//				}.background(.white)
//				
//			}
//			Button(action: {
//				model.showList = false
//				model.player.play()
//			},label: {
//				Image(systemName: "xmark.circle")
//					.font(Font.system(.largeTitle))
//					.foregroundStyle(.red)
//			}).buttonStyle(.plain)
//				.padding(10)
//			Spacer()
//		}.onAppear{
//			NSCursor.unhide()
//		}.onDisappear{
//			NSCursor.hide()
//		}
//	}

struct ListView: View {
	@ObservedObject var model: ViewModel

	var body: some View {
		VStack {
			HStack{
				Spacer()
				Button(action: {
					model.showList = false
					model.player.play()
				}) {
					Image(systemName: "xmark.circle")
						.font(Font.system(.largeTitle))
						.foregroundStyle(.red)
				}
				.buttonStyle(.plain)
				.padding(10)
			}
			
			List {
				ForEach(Array(model.vids.enumerated()), id: \.1.id) { (index, item) in
					Button(action: {
						print("foofoofoof")
						model.showList = false
						model.videoCount = index
						model.loadNext()
						print(item.title)
					}) {
						HStack {
							if index == model.videoCount {
								Text(item.name)
									.font(.largeTitle)
									.lineLimit(1)
									.foregroundColor(.red)
								Text(", ")
									.font(.largeTitle)
									.lineLimit(1)
									.foregroundColor(.red)
								Text(item.title)
									.font(.largeTitle)
									.lineLimit(1)
									.foregroundColor(.red)
							} else {
								Text("\(item.name). \(item.title)")
									.font(.largeTitle)
									.lineLimit(1)
									.foregroundColor(.black)
							}
							Spacer()
							Image(systemName: "play.circle")
								.font(Font.system(.largeTitle))
								.foregroundStyle(.red)
						}
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 10)
								.fill(Color.white)
								.shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
						)
						.padding(.vertical, 5) // Adds space between rows
						.contentShape(Rectangle()) // Ensures full row is tappable
					}
					.buttonStyle(PlainButtonStyle())
					.listRowSeparator(.hidden)
					.listRowInsets(EdgeInsets()) // removes default insets
					.listRowBackground(Color.clear) // needed to preserve background padding
				}
			}
			.listStyle(PlainListStyle()) // cleaner look without section padding



			Spacer()
		}
		.onAppear {
			NSCursor.unhide()
		}
		.onDisappear {
			NSCursor.hide()
		}
	}
}
