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
                 item.notifyDate - date > 0
             })
             overlayColor = Color(red: 119/255, green: 192/255, blue: 255/255)
             backgroundColor = Color(red: 218/255, green: 237/255, blue: 255/255)
             title = String(localized: "others.beforeNotify.title")
             description = String(localized: "others.beforeNotify.text")
             
         } else {
             _problemSet = Query(filter: #Predicate<ProblemSet>{ item in
                 item.notifyDate - date <= -1*60*60*24.0
             })
             overlayColor = Color(red: 172/255, green: 31/255, blue: 33/255)
             backgroundColor = Color(red: 255/255, green: 218/255, blue: 228/255)
             title = String(localized: "others.expired.title")
             description = String(localized: "others.expired.text")
         }
        
    }
    
    var body: some View {
        ScrollView {
            Rectangle()
                .fill(.clear)
                .frame(height: 150)
            
            if problemSet.isEmpty {
                VStack {
                    Text(String(localized: "others.nothing"))
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
                        Button(String(localized: "button.delete"), role: .destructive) {
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
        .alert(String(localized: "button.caution") , isPresented: $alert) {
            Button(String(localized: "button.cancel")) {
                
            }
            Button(String(localized: "button.start")) {
                 UserDefaults.standard.set(false, forKey: "isUpdateStatus")
                if let problem = problem {
                    path.append(problem)
                }
                print("path: \(path)")
            }
        } message: {
            Text(String(localized: "alert.notUpdate"))
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



