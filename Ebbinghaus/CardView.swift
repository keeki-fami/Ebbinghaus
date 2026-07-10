//
//  CardView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/10.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(width: 300, height: 150)
            .shadow(color: .black.opacity(0.25), radius: 10)
            .overlay() {
                VStack {
                    HStack {
                        Text("aaa")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding([.top])
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("aaa - aaa")
                        Spacer()
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                            Circle()
                                .frame(width: 10, height: 10)
                            Circle()
                                .frame(width: 10, height: 10)
                            Circle()
                                .frame(width: 10, height: 10)
                            Circle()
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                .padding(20)
            }
    }
}

struct MiniCardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(width: 200, height: 100)
            .shadow(color: .black.opacity(0.25), radius: 10)
            .overlay() {
                Text("aaa")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20)
            }
    }
}

#Preview {
    VStack {
        CardView()
        MiniCardView()
    }
}
