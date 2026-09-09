//
//  ContentView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/08.
//

import SwiftUI
import SwiftData

enum SolvePhase {
    case solving
    case solved
}

enum Result: Hashable {
    case result
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSince1970 - rhs.timeIntervalSince1970
    }
}

struct ResultViewData: Hashable {
    var nextPhase: Phase
    var problemSet: String
    var next: TimeInterval
    var correct: Int
    var incorrect: Int
}

struct TitleView: View {
    let text: String
    var textColor:Color = .black
    var body: some View {
        HStack {
            Text(text)
                .font(Font.title.bold())
                .padding()
            Spacer()
        }
    }
}

struct NothingToDoTodayView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 50)
            Text("🎉")
                .font(.largeTitle)
                .padding()
            Spacer()
            Group {
                    Text("今日の問題は")
                    Text("全て完了しました！")
            }
            .foregroundStyle(.black)
            .font(.title2)
            .fontWeight(.bold)
            Rectangle()
                .fill(.clear)
                .frame(height: 25)
            Group {
                Text("素晴らしい！")
                Text("EbbingHausの忘却曲線に沿って、")
                Text("あなたの学習は着実に成果になっています。")
            }
            .fontWeight(.thin)
            .font(.body)
            .foregroundStyle(.black)
        }
    }
}

struct ContentView: View {
//    @Environment(\.modelContext) private var context
    @State private var isSheet = false
    @State private var isNavigation = false
    @State private var presented: [ProblemSet] = []
    @State var path = NavigationPath()
    @State private var alert = false
    @State private var problem: ProblemSet?
    @Query private var havetoDoProblemSet: [ProblemSet]
    @AppStorage("isUpdateStatus") var isUpdateStatus: Bool = true
    
    init() {
        let date = Date().timeIntervalSince1970
        _havetoDoProblemSet = Query(filter: #Predicate<ProblemSet>{ item in
            (0.0 < item.notifyDate - date) && ( item.notifyDate - date <= 60*60*24.0 )
        })
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 100)
                Group {
                    if havetoDoProblemSet.isEmpty {
                        NothingToDoTodayView()
                    } else {
                        VStack {
                            TitleView(text: "今日の問題集")
                            VStack {
                                ForEach(havetoDoProblemSet, id: \.id) { set in
                                    Button(action: {
                                        isUpdateStatus = true
                                        print("appending to path: \(set)")
                                        path.append(set)
                                    }, label: {
                                        CardView(
                                            setName: set.setName,
                                            rest: set.rest,
                                            phase: set.status,
                                            viewType: .willDo
                                        )
                                    })
                                }
                                .padding([.top, .bottom], 5)
                            }
                            .padding([.top, .bottom], 20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    }
                    
                    TitleView(text: "その他")
                    Button(action: {
                        let content = OtherViewType.willDo
                        path.append(content)
                    }, label: {
                        WillSolveCardView()
                    })
                    Button(action: {
                        let content = OtherViewType.haveToDo
                        path.append(content)
                    }, label: {
                        HaveToSolveCardView()
                    })
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
//            .ignoresSafeArea()
            .background(
                Color.blue.opacity(0.1)
                .ignoresSafeArea()
            )
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 500, height: 100)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                    .overlay(alignment: .bottom) {
                        Text("EbbingHaus")
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .ignoresSafeArea()
            }
            .overlay(alignment: .bottomTrailing) {
                    Button(action: {
                        path.append("add")
                        isSheet = true
                    }, label: {
                        Circle()
                            .fill(.blue)
                            .frame(width: 75, height: 75)
                            .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 0)
                            .overlay() {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.white)
                            }
                    })
                    .padding(30)
            }
            .navigationDestination(for: ProblemSet.self) { set in
                ProblemView(problemSet: set, path: $path)
            }
            .navigationDestination(for: ResultViewData.self) { resultViewData in
                ResultView(path: $path, resultViewData: resultViewData)
            }
            .navigationDestination(for: OtherViewType.self) { content in
                OtherView(viewType: content, path: $path)
            }
            .navigationDestination(for: String.self) { _ in
                AddProblemSetView(path: $path)
            }
            
        }
    }
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: ProblemSet.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true),
        )
        container.mainContext.insert(
            ProblemSet(
                setName: "Math",
                problem: [
                    ProblemData(problem: "1+1=", answer: "2", keyword: ["2"]),
                    ProblemData(problem: "2+1=", answer: "3", keyword: ["3"]),
                    ProblemData(problem: "3+1=", answer: "4", keyword: ["4"]),
                    ProblemData(problem: "4+1=", answer: "5", keyword: ["5"])],
                notifyDate: Date().timeIntervalSince1970,
                status: .phase1
            )
        )
        container.mainContext.insert(
            ProblemSet(
                setName: "Math",
                problem: [ProblemData(problem: "2+2=", answer: "4", keyword: ["4"])],
                notifyDate: Date().timeIntervalSince1970,
                status: .phase1
            )
        )
        return container
    } catch {
        fatalError("failed to create container")
    }
}()

@MainActor
let previewContainerEmpty: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: ProblemSet.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true),
        )
        return container
    } catch {
        fatalError("failed to create container")
    }
}()

enum ProblemSetPhase {
    case phase1
    case phase2
    case phase3
}


let container = try? ModelContainer(
    for: ProblemSet.self, ProblemData.self,
    configurations: .init(isStoredInMemoryOnly: true)
)

#Preview {
    ContentView()
        .modelContainer(previewContainer)
    //        ProblemCardView()
    //    ProblemCreatingView()
}
