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

struct ResultView: View {
    var body: some View {
        VStack {
            Text("Finish!")
            Text("お疲れ様でした")
                .foregroundStyle(Color(red: 157/255, green: 157/255, blue: 157/255))
                .fontWeight(.thin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(.red)
        Text("Next - 2222/2/2")
        Spacer()
        VStack {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                Text("Xでシェア")
            }
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                Text("StudyPlusでシェア")
            }
        }
        .frame(maxWidth: 300, maxHeight: .infinity)
        .border(.red)
        
        NavigationLink {
            ContentView()
        } label: {
            Text("ホーム画面に戻る")
        }
        .padding()
        .border(.red)

    }
}

struct ProblemView: View {
    var problemSet: ProblemSet
    @State private var nowSolvePhase: SolvePhase = .solving
    @State private var nowProblem: Int = 0
    @State private var inputText: String = ""
    var body: some View {
        NavigationStack {
            ProgressView(value: Double(nowProblem)/Double(problemSet.problem.count))
                .padding()
            Spacer()
            Group {
                ScrollView {
                    Text("\(problemSet.problem[nowProblem].problem)")
                    TextField(
                        "解答",
                        text: $inputText,
                        axis: .vertical
                    )
                    .textFieldStyle(.roundedBorder)
                    if nowSolvePhase == .solved {
                        Text("\(problemSet.problem[nowProblem].answer)")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(.gray)
            Spacer()
            if nowSolvePhase == .solving {
                Button(action: {
                    withAnimation {
                        nowSolvePhase = .solved
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 300, height: 50)
                        .shadow(color: .black.opacity(0.25), radius: 10)
                        .overlay() {
                            Text("解答")
                        }
                        .padding()
                })
            } else {
                if nowProblem == problemSet.problem.count - 1 {
                    HStack {
                        NavigationLink(destination: {
                            ResultView()
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red)
                                .shadow(color: .black.opacity(0.25), radius: 10)
                        })
                        NavigationLink(destination: {
                            ResultView()
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.green)
                                .shadow(color: .black.opacity(0.25), radius: 10)
                        })
                    }
                    .frame(width: 300, height: 50)
                    .padding()
                } else {
                    HStack {
                        Button(action: {
                            handleButton()
                            // TODO: 間違えたことにする
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red)
                                .shadow(color: .black.opacity(0.25), radius: 10)
                        })
                        Button(action: {
                            handleButton()
                            // TODO: 成功用処理
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.green)
                                .shadow(color: .black.opacity(0.25), radius: 10)
                        })
                    }
                    .frame(width: 300, height: 50)
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    func handleButton() {
        withAnimation {
            nowSolvePhase = .solved
        }
        if nowProblem+1 < problemSet.problem.count {
            withAnimation {
                nowProblem+=1
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var problemSet: [ProblemSet]
    @State private var isSheet = false
    @State private var isNavigation = false
    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    ForEach(problemSet, id: \.id) { set in
                        NavigationLink(destination: ProblemView(problemSet: set), isActive: $isNavigation) {
                            CardView()
                        }
                        .onAppear {
                            print("appear")
                        }
                    }
                    .padding([.top], 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    isSheet = true
                }, label: {
                    Circle()
                        .fill(.blue)
                        .frame(width: 100, height: 100)
                })
                .padding(30)
            }
            .navigationTitle("Home")
            
        }
        .sheet(isPresented: $isSheet) {
            AddProblemSetView()
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
                notifyDate: Date(),
                status: .phase1
            )
        )
        container.mainContext.insert(
            ProblemSet(
                setName: "Math",
                problem: [ProblemData(problem: "2+2=", answer: "4", keyword: ["4"])],
                notifyDate: Date(),
                status: .phase1
            )
        )
        return container
    } catch {
        fatalError("failed to create container")
    }
}()

struct AddProblemSetView: View {
    @State private var setName: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                TextField("名前", text: $setName)
                    .textFieldStyle(.automatic)
                Button("Add") {
                    
                }
                NavigationLink(destination: {
                    VStack {
                        Spacer()
                        MiniCardView()
                            .padding(20)
                        Text("Congratulation!")
                            .padding(5)
                        Text("あなただけの問題セットが作られました")
                            .foregroundStyle(Color(red: 157/255, green: 157/255, blue: 157/255))
                            .padding(5)
                        Spacer()
                        Button("ホームに戻る") {
                            dismiss()
                        }
                        .padding(30)
                    }
                    .fontWeight(.thin)
                }) {
                    Text("完成")
                }
            }
            .navigationTitle("新規作成")
        }
    }
}

let container = try? ModelContainer(
    for: ProblemSet.self, ProblemData.self,
    configurations: .init(isStoredInMemoryOnly: true)
)

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
