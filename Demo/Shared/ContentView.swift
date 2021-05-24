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
            Text("Hello")
        },
            isShowing: $showingSheet,
            outOfFocusOpacity: 0.2
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
