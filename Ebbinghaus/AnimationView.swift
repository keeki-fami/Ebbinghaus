//
//  AnimationView.swift
//  Ebbinghaus
//  
//  Created by keeki-fami on 2026/09/08
//  
//
import SwiftUI

struct AnimationView: View {
    struct StampAnimation {
        var positionY: CGFloat
        var rotatingAngle: CGFloat
    }
    @State private var trigger = false
    @State private var offsetY: CGFloat = 500.0
    let high = [200.0, 400.0, 400.0, 200.0]
    var body: some View {
//        GeometryReader {geometry in
            HStack {
                ForEach(0..<4) { i in
                    Text("🎉")
                        .font(Font.system(size: 75))
                        .offset(y: offsetY)
                        .animation(.timingCurve(.circularEaseOut, duration: 1.0), value: offsetY)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay() {
                Button("tao") {
                    Task {
                        offsetY = 0
                        try await Task.sleep(nanoseconds: 1000000000)
                        offsetY = 500.0
                    }
                    trigger.toggle()
                }
            }
//        }
    }
}

#Preview {
    AnimationView()
}
