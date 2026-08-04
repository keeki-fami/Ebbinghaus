//
//  CardView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/10.
//

import SwiftUI

struct CardView: View {
    let setName: String
    let rest: TimeInterval
    let phase: Phase
    var restday: Int {
        return Int(rest/(60*60*24))
    }
    var resthour: Int {
        let resth = Int(rest)%(60*60*24)
        return Int(resth/(60*60))
    }
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(width: 300, height: 150)
            .shadow(color: .black.opacity(0.25), radius: 5)
            .overlay() {
                VStack {
                    HStack {
                        Text("\(setName)")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding([.top])
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("next - \(restday)日 \(resthour)時間後")
                            .foregroundStyle(.black)
                            .fontWeight(.thin)
                        Spacer()
                        HStack {
                            ForEach(1..<6) { i in
                                if i < phase.rawValue {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .frame(width: 10, height: 10)
                                        .padding([.leading], 2)
                                } else {
                                    Circle()
                                        .fill(.gray)
                                        .frame(width: 10, height: 10)
                                }
                            }
                    
                        }
                    }
                }
                .padding(20)
            }
    }
}

struct MiniCardView: View {
    let setName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(width: 200, height: 100)
            .shadow(color: .black.opacity(0.25), radius: 5)
            .overlay() {
                Text(setName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20)
            }
    }
}

#Preview {
    VStack {
        CardView(setName: "aaa", rest: 2600000.0, phase: .phase3)
            .padding()
        MiniCardView(setName: "aaa")
            .padding()
    }
}
