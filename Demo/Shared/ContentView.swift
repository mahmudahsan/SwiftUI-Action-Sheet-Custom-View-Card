//
//  ContentView.swift
//  Shared
//
//  Created by Mahmud Ahsan
//

import SwiftUI

struct ContentView: View {
    @State var showingSheet = false
    
    var content: some View {
        VStack {
            Text("Custom Info Sheet")
                .font(.largeTitle)
                .padding()
            Button(action: {
                showingSheet = true
            }) {
                Text("Open Sheet")
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func hideActionSheet() {
        showingSheet = false
    }
    
    var actionSheet: some View {
        ActionSheetCustomViewCard(content: {
            VStack {
                HStack {
                    Spacer()
                }
                HStack {
                    ZStack (alignment: .top){
                        HStack (alignment: .top){
                            Button(action: {
                                self.hideActionSheet()
                            }, label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                    .foregroundColor(.black)
                            })
                            .frame(width: 20)
                            .padding(.top, 2)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        Text("Why do I need to connect to do the job?")
                            .multilineTextAlignment(.center)
                            .font(Font.system(size: 16.0, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 72)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 18)
                
                Text("orem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam a tempor nibh. Morbi porttitor leo nulla, vitae fringilla mauris molestie vel. Fusce lobortis, quam id luctus rutrum, urna sem tincidunt augue, sit amet varius diam odio quis massa.")
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 40)
                    .foregroundColor(.gray)
            }
            
        },
            isShowing: $showingSheet,
            outOfFocusOpacity: 0.2,
            showFullScreen: false
        )
    }
    
    var sheetView: some View {
        VStack {
            Spacer()
            actionSheet
        }
    }
    
    var body: some View {
        ZStack {
            content
            sheetView
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
