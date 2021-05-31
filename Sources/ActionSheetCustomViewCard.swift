/**
 *  ActionSheetCustomViewCard
 *
 *  Copyright (c) 2021 Mahmud Ahsan. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import SwiftUI
import Combine

public struct ActionSheetCustomViewCard<Content: View>: View {
    @State var offset = UIScreen.main.bounds.height
    @State var isDragging = false
    
    @Binding var isShowing: Bool
    
    let content: Content
    let heightToDisappear = UIScreen.main.bounds.height
    let cellHeight: CGFloat = 50
    let backgroundColor: Color
    let outOfFocusOpacity: CGFloat
    let minimumDragDistanceToHide: CGFloat
    
    public init(
        @ViewBuilder content: ()->Content,
        isShowing: Binding<Bool>,
        backgroundColor: Color = Color.white,
        outOfFocusOpacity: CGFloat = 0.7,
        minimumDragDistanceToHide: CGFloat = 150
    ) {
        self.content = content()
        _isShowing = isShowing
        self.backgroundColor = backgroundColor
        self.outOfFocusOpacity = outOfFocusOpacity
        self.minimumDragDistanceToHide = minimumDragDistanceToHide
    }
    
    func hide() {
        offset = heightToDisappear
        isDragging = false
        isShowing = false
    }
        
    var topHalfMiddleBar: some View {
        Capsule()
            .frame(width: 36, height: 5)
            .foregroundColor(Color.black)
            .padding(.vertical, 5.5)
            .opacity(0.2)
    }
    
    
    func dragGestureOnChange(_ value: DragGesture.Value) {
        isDragging = true
        print("start Y: \(value.startLocation.y) | end Y: \(value.location.y) | translation: \(value.translation.height)")
        if value.translation.height > 0 {
            offset = value.location.y
            let diff = abs(value.location.y - value.startLocation.y)
            
            let conditionOne = diff > minimumDragDistanceToHide
            let conditionTwo = value.location.y >= 200
            
            
            if conditionOne || conditionTwo {
                hide()
            }
        }
    }
    
    var interactiveGesture: some Gesture {
        DragGesture()
            .onChanged({ (value) in
                dragGestureOnChange(value)
            })
            .onEnded({ (value) in
                isDragging = false
            })
    }
    
    var outOfFocusArea: some View {
        Group {
            if isShowing {
                GreyOutOfFocusView(opacity: outOfFocusOpacity) {
                    self.isShowing = false
                }
            }
        }
    }
    
    var customView: some View {
        content
    }
    
    var sheetView: some View {
        VStack {
            Spacer()
            
            VStack (spacing: 14){
                topHalfMiddleBar
                customView
                Text("").frame(height: 20) // empty space
            }
            .background(backgroundColor)
            .cornerRadius(10)
            .offset(y: offset)
            .gesture(interactiveGesture)
        }
    }
    
    var bodyContent: some View {
        ZStack {
            outOfFocusArea
            sheetView
        }
    }
    
    func onUpdateIsShowing(_ isShowing: Bool) {
        if isShowing && isDragging {
            return
        }
        
        DispatchQueue.main.async {
            offset = isShowing ? 0 : heightToDisappear
        }
    }
    
    public var body: some View {
        Group {
            if isShowing {
                bodyContent
            }
        }
        .animation(.default)
        .onReceive(Just(isShowing), perform: { isShowing in
            onUpdateIsShowing(isShowing)
        })
    }
}

struct ActionSheetCustomViewCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ActionSheetCustomViewCard(content: {
                VStack {
                    HStack {
                        Spacer()
                    }
                    HStack {
                        ZStack (alignment: .top){
                            HStack (alignment: .top){
                                Button(action: {
                                    //
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
                isShowing: .constant(true),
                outOfFocusOpacity: 0.2
            )
        }
    }
}
