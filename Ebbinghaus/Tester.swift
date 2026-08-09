//
//  Tester.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/10.
//

import SwiftUI

struct ClickEffectTestView: View {
    @State private var effect = false
    @State private var counter = 0
    struct backgroundAnimator {
        var opacity = 0.0
    }
    var body: some View {
        ZStack {
            Rectangle()
                .fill(counter % 2 == 0 ? .green : .red)
                .keyframeAnimator(initialValue: backgroundAnimator(), trigger: effect, content: { content, value in
                    content
                        .opacity(value.opacity)
                    
                } , keyframes: { _ in
                    KeyframeTrack(\.opacity) {
                        MoveKeyframe(0.5)
                        CubicKeyframe(0.0, duration: 1)
                    }
                    
                })
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThickMaterial)
                    .frame(width: 400, height: 300)
                    .overlay() {
                        VStack {
                            Button("\(counter)") {
                                counter += 1
                            }
                            Button("effect") {
                                effect.toggle()
                            }
                        }
                    }
            }
        }
        
    }
}

struct Tester: View {
    let fontStyle: [Font.Weight] = [
        .ultraLight,
        .thin,
        .light,
        .regular,
        .medium,
        .semibold,
        .bold,
        .heavy,
        .black
    ]
    let font: [Font] = [
        .largeTitle,
        .title,
        .title2,
        .title3,
        .headline,
        .body,
        .subheadline
    ]
    // thin 良さそう
    var body: some View {
        ScrollView {
            ForEach(fontStyle, id: \.self) { font in
                HStack {
                    Text("abcd")
                    Spacer()
                    Text("あいうえ")
                }
                .padding(10)
                .fontWeight(font)
            }
            ForEach(font, id: \.self) { font in
                HStack {
                    Text("abcd")
                    Spacer()
                    Text("あいうえ")
                }
                .padding(10)
                .font(font)
            }
        }
    }
}

struct TextEditorText: View {
    @State private var inputText: String = ""
    var body: some View {
        TextEditor(text: $inputText)
            .frame(width: 350, height: 200)
            .overlay() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.25).shadow(.inner(color: .black.opacity(0.25), radius: 5, x: 5, y: 5)))
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            }
            .padding()
        TextField("222", text: $inputText, axis: .vertical)
            .textFieldStyle(textFields())
            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .background(Color.red)
//            .background(.white.shadow(.inner(color: .black.opacity(0.25), radius: 20, x: 5, y: 5)))
            .lineLimit(5...10)
            .padding()
    }
}
struct textFields: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .overlay() {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                    .background(.white.opacity(0.25).shadow(.inner(color: .black.opacity(0.25), radius: 5, x: 5, y: 5)))
                    .allowsHitTesting(false)
            }
    }
}
#Preview {
    Tester()
//    ClickEffectTestView()
//    TextEditorText()
}
