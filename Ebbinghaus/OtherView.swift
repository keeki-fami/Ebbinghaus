//
//  OtherView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/09/08
//
//

import SwiftUI
import SwiftData

struct OtherView: View {
    @Query private var dontHaveToDoProblemSet: [ProblemSet]
    init() {
        let date = Date().timeIntervalSince1970
        _dontHaveToDoProblemSet = Query(filter: #Predicate<ProblemSet> { item in
            item.notifyDate - date > 60*60*24.0
        })
    }
    
    let backgroundBlue = Color(red: 119/255, green: 192/255, blue: 255/255)
    let sheetBlue = Color(red: 218/255, green: 237/255, blue: 255/255)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 150)
                CardView(setName: "aa", rest: 199994, phase: .phase4)
                CardView(setName: "aa", rest: 199994, phase: .phase4)
                
            }
            .background(
                sheetBlue.ignoresSafeArea()
            )
            .overlay(alignment: .top) {
                ZStack {
                    Triangle()
                        .fill(backgroundBlue)
                        .frame(height: 200)
                        .ignoresSafeArea()
                        .border(.green)
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 0)
                        .overlay(alignment: .topLeading){
                            VStack(alignment: .leading) {
                                Text("期限前の問題")
                                    .font(.title.bold())
                                Text("今日以降に復習すると、記憶定着に最適な問題集です。")
                            }
                            .padding(.leading)
                            .foregroundStyle(.white)
                            .border(.blue)
                        }

                }
                
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        let point = CGPoint(x: rect.maxX, y: rect.minY)
        var path = Path()
        
        
        path.move(to: point)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 150))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 200))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
    
}



#Preview {
    OtherView()
        .modelContainer(previewContainer)
}
