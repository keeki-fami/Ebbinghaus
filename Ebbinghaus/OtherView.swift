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
    @Environment(\.modelContext) private var context
    @Query private var problemSet: [ProblemSet]
    @Binding var path: NavigationPath
    @State private var alert = false
    @State private var problem: ProblemSet?
    var viewType: OtherViewType
    let overlayColor: Color
    let backgroundColor: Color
    let title: String
    let description: String
    
    init(viewType: OtherViewType, path: Binding<NavigationPath>) {
        let date = Date().timeIntervalSince1970
        self.viewType = viewType
        self._path = path
        if viewType == .willDo {
            _problemSet = Query(filter: #Predicate<ProblemSet> { item in
                item.notifyDate - date > 60*60*24.0
            })
            overlayColor = Color(red: 119/255, green: 192/255, blue: 255/255)
            backgroundColor = Color(red: 218/255, green: 237/255, blue: 255/255)
            title = "期限前の問題"
            description = "明日以降に復習すると良い問題集です。"
            
        } else {
            _problemSet = Query(filter: #Predicate<ProblemSet>{ item in
                item.notifyDate - date <= 0
            })
            overlayColor = Color(red: 172/255, green: 31/255, blue: 33/255)
            backgroundColor = Color(red: 255/255, green: 218/255, blue: 228/255)
            title = "期限切れの問題"
            description = "良い復習の機会を逃してしまった問題集です。まだ間に合います！"
        }
        
    }
    
    var body: some View {
        ScrollView {
            Rectangle()
                .fill(.clear)
                .frame(height: 150)
            
            if problemSet.isEmpty {
                VStack {
                    Text("問題集はありません。")
                }
                .frame(height: 300)
            } else {
                ForEach(problemSet) { card in
                    Button(action: {
                        if viewType == .haveToDo {
                            path.append(card)
                        } else {
                            problem = card
                            alert = true
                        }
                    }, label: {
                        CardView(
                            setName: card.setName,
                            rest: card.notifyDate,
                            phase: card.status,
                            viewType: viewType
                        )
                    })
                    .contextMenu {
                        Button("削除", role: .destructive) {
                            if let idx = problemSet.firstIndex(of: card) {
                                let element = problemSet[idx]
                                withAnimation {
                                    context.delete(element)
                                    try? context.save()
                                }
                            }
                        }
                    }
                }
            }
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
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 0)
                    .overlay(alignment: .topLeading){
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.title.bold())
                            Text(description)
                        }
                        .padding(.leading)
                        .foregroundStyle(.white)
                    }
                
            }
            
        }
        .alert("注意" , isPresented: $alert) {
            Button("キャンセル") {
                
            }
            Button("始める") {
                 UserDefaults.standard.set(false, forKey: "isUpdateStatus")
                if let problem = problem {
                    path.append(problem)
                }
                print("path: \(path)")
            }
        } message: {
            Text("今回はphaseが更新されません")
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



