//
//  Tester.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/10.
//

import SwiftUI

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

#Preview {
    Tester()
}
