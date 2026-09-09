//
//  OtherView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/09/08
//
//

import SwiftUI
import SwiftData

enum OtherViewType: Hashable {
    case willDo
    case haveToDo
}

struct ToOtherViewData {
    var vietType: OtherViewType
    var problemData: ProblemSet
}

struct CardColor {
    var light: Color
    var dark: Color
}

struct OtherView: View {
    @Query private var dontHaveToDoProblemSet: [ProblemSet]
    @Binding var path: NavigationPath
    var viewType: OtherViewType
    let overlayColor: Color
    let backgroundColor: Color
    
    init(viewType: OtherViewType, path: Binding<NavigationPath>) {
        let date = Date().timeIntervalSince1970
        _dontHaveToDoProblemSet = Query(filter: #Predicate<ProblemSet> { item in
            item.notifyDate - date > 60*60*24.0
        })
        self.viewType = viewType
        self._path = path
        
        if viewType == .willDo {
            overlayColor = Color(red: 119/255, green: 192/255, blue: 255/255)
            backgroundColor = Color(red: 218/255, green: 237/255, blue: 255/255)
            
        } else {
            overlayColor = Color(red: 172/255, green: 31/255, blue: 33/255)
            backgroundColor = Color(red: 255/255, green: 218/255, blue: 228/255)
        }
        
    }
    
    var body: some View {
            ScrollView {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 150)
                CardView(setName: "aa", rest: 199994, phase: .phase4, viewType: viewType)
                CardView(setName: "aa", rest: 199994, phase: .phase4, viewType: viewType)
                
            }
            .background(
                backgroundColor.ignoresSafeArea()
            )
            .overlay(alignment: .top) {
                ZStack {
                    Triangle()
                        .fill(overlayColor)
                        .frame(height: 250)
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

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        let point = CGPoint(x: rect.maxX, y: rect.minY)
        var path = Path()
        
        
        path.move(to: point)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 200))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 250))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
    
}



