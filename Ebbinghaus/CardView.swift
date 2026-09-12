//
//  CardView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/10.
//

import SwiftUI

struct CardView: View {
    let setName: String
    let rest: TimeInterval
    let phase: Phase
    let viewType: OtherViewType
    let date = Date()
    var cardColor: CardColor {
        return getCardColorSet(viewType: viewType)
    }
    
    var restday: Int {
        return Int((rest - date.timeIntervalSince1970)/(60*60*24))
    }
    var resthour: Int {
        let resth = Int(rest - date.timeIntervalSince1970)%(60*60*24)
        return Int(resth/(60*60))
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: cardColor.light, location: 0.0),
                        .init(color: cardColor.dark, location: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 300, height: 150)
            .shadow(color: .black.opacity(0.25), radius: 5)
            .overlay() {
                VStack {
                    HStack {
                        Text("\(setName)")
                            .foregroundStyle(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding([.top])
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text("\(restday)日 \(resthour)時間後")
                            .foregroundStyle(.white)
//                            .fontWeight(.default)
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
                                        .fill(phase.rawValue >= i ? (phase.rawValue == i ? .yellow : .green) : .gray)
                                        .frame(width: 10, height: 10)
                                }
                            }
                    
                        }
                    }
                }
                .padding(20)
            }
    }
    
    func getCardColorSet(viewType: OtherViewType) -> CardColor {
        if viewType == .willDo {
            return CardColor(
                light: Color(red: 58/255, green: 118/255, blue: 214/255),
                dark: Color(red: 38/255, green: 62/255, blue: 112/255)
            )
        } else {
            return CardColor(
                light: Color(red: 214/255, green: 58/255, blue: 84/255),
                dark: Color(red: 112/255, green: 30/255, blue: 44/255)
            )
        }
    }
}

struct MiniCardView: View {
    let setName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(stops: [
                    .init(color: Color(red: 58/255, green: 118/255, blue: 214/255), location: 0.0),
                    .init(color: Color(red: 38/255, green: 62/255, blue: 112/255), location: 1.0)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .frame(width: 200, height: 100)
            .shadow(color: .black.opacity(0.25), radius: 5)
            .overlay() {
                Text(setName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(20)
                    .foregroundStyle(Color.white)
            }
    }
}

struct CardStackingView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 226/255, green: 238/255, blue: 251/255))
                .frame(width: 100, height: 50)
                .rotationEffect(Angle(degrees: 35))
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 131/255, green: 214/255, blue: 244/255))
                .frame(width: 100, height: 50)
                .rotationEffect(Angle(degrees: 15))
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 64/255, green: 147/255, blue: 240/255))
                .frame(width: 100, height: 50)
                .rotationEffect(Angle(degrees: -5))
        }
    }
}

struct WillSolveCardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(red: 52/255, green: 119/255, blue: 244/255))
            .frame(width: 275, height: 200)
            .overlay() {
                VStack{
                    CardStackingView()
                        .padding()
                    Text("通知前の問題")
                        .font(.title3)
                    Text("今日以降、復習すると良い問題です。")
//                        .fontWeight(.thin)
                        .font(.caption)
                }
                .foregroundStyle(.white)
            }
        
    }
}

struct HaveToSolveCardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(red: 214/255, green: 58/255, blue: 84/255))
            .frame(width: 275, height: 200)
            .overlay() {
                VStack{
                    Text("⚠️")
                        .font(.largeTitle)
                    Text("期限後の問題")
                        .font(.title3)
                    Text("期限が過ぎた問題です。すぐに復習しましょう！")
//                        .fontWeight(.thin)
                        .font(.caption)
                }
                .foregroundStyle(.white)
            }
        
    }
}

#Preview {
    ScrollView {
        CardView(setName: "aaa", rest: 2600000.0, phase: .phase3, viewType: .willDo)
            .padding()
        CardView(setName: "aaa", rest: 2600000.0, phase: .phase3, viewType: .haveToDo)
            .padding()
        MiniCardView(setName: "aaa")
            .padding()
        CardStackingView()
            .padding()
        WillSolveCardView()
            .padding()
        HaveToSolveCardView()
            .padding()
    }
}
