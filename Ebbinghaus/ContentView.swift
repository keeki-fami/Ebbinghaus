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

enum ProblemSetPhase {
    case phase1
    case phase2
    case phase3
}


struct AddProblemSetView: View {
    
    enum Field: Hashable {
        case setName
    }
    
    @State private var setName: String = ""
    @State private var nowPhase = ProblemSetPhase.phase1
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: Field?
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text(nowPhase == .phase1 ? "問題セットの名前を入力してください" : nowPhase == .phase2 ? "問題を追加してください。" : "nil")
                    .fontWeight(.thin)
                
                if nowPhase == .phase2 {
                    Text("\(setName)")
                        .fontWeight(.thin)
                        .padding()
                }
                
                Spacer()
                // 問題セット名
                if nowPhase == .phase1 {
                    TextField("問題セット名を入力", text: $setName)
                        .font(.largeTitle)
                        .textFieldStyle(.plain)
                        .focused($focus, equals: .setName)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                } else if nowPhase == .phase2 {
                    ScrollView {
                        VStack {
                            NavigationLink(destination: {
                                ProblemCreatingView()
                            }, label: {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 60, height: 60)
                                    .shadow(
                                        color: .black.opacity(0.25),
                                        radius: 10, x: 0, y: 0
                                    )
                                    .overlay() {
                                        Text("+")
                                            .fontWeight(.thin)
                                    }
                                    .padding()
                            })
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                    }
                }
                
                Spacer()
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
                Button(action: {
                    if nowPhase == .phase1 {
                        nowPhase = .phase2
                    } else if nowPhase == .phase2 {
                        nowPhase = .phase3
                    } else {
                        dismiss()
                    }
                    
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.25), radius: 5)
                        .frame(maxWidth: 350,  maxHeight: 50)
                        .padding()
                        .overlay() {
                            Text("Next")
                                .fontWeight(.thin)
                                .foregroundStyle(.black)
                        }
                })
            }
            //            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                focus = nil
            }
            .onAppear {
                focus = .setName
            }
            .border(.red)
            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading,
                    content: {
                        if nowPhase == .phase2 {
                            Button("戻る") {
                                nowPhase = .phase1
                            }
                        }
                    })
            }
        }
    }
}

struct ProblemCreatingView: View {
    @State private var problem = ""
    @State private var answer = ""
    @State private var keyword: [String] = []
    @FocusState private var focus: Field?
    @Environment(\.dismiss) var dismiss
    
    enum Field: Hashable {
        case problem
        case answer
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("問題の作成をしてください。")
                    .fontWeight(.thin)
                VStack {
                    HStack {
                        Text("問題")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                        Spacer()
                    }
                    HStack {
                        TextField("問題の内容を入力してください。", text: $problem, axis: .vertical)
                            .textFieldStyle(.plain)
                            .focused($focus, equals: .problem)
                        Spacer()
                    }
                }
                .padding()
                VStack {
                    HStack {
                        Text("解答")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                        Spacer()
                    }
                    HStack {
                        TextField("解答例を入力してください。", text: $answer, axis: .vertical)
                            .textFieldStyle(.plain)
                            .focused($focus, equals: .answer)
                        Spacer()
                    }
                }
                .padding()
                VStack {
                    HStack {
                        Text("キーワード")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                        Spacer()
                    }
                        ForEach(keyword.indices, id: \.self) { idx in
                            HStack {
                                TextField("キーワード\(idx+1)", text: $keyword[idx], axis: .vertical)
                                    .textFieldStyle(.plain)
                                Spacer()
                            }
                        }
                        .onDelete { indexSet in
                            keyword.remove(atOffsets: indexSet)
                        }
                    Button (action: {
                        keyword.append("")
                    }, label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 60, height: 60)
                            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 0)
                            .overlay() {
                                Text("+")
                                    .font(.largeTitle)
                                    .fontWeight(.thin)
                            }
                    })
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture{
                focus = nil
            }
        }
    }
}

struct ProblemCardView: View {
    var body: some View {
        Rectangle()
            .fill(
                Color(
                    red: 237/255,
                    green: 240/255,
                    blue: 241/255
                )
            )
            .frame(
                width: 300,
                height: 100
            )
            .overlay() {
                HStack {
                    VStack(alignment: .leading) {
                        Text("aaaaaaa")
                            .font(.largeTitle)
                        Text("bbbbb")
                            .fontWeight(.thin)
                    }
                    Spacer()
                }
                .padding()
            }
            .overlay(alignment: .trailing) {
                Text(">")
                    .padding()
                    .frame(maxWidth :50, maxHeight: .infinity)
                    .border(.red)
                    .background(
                        LinearGradient(
                            colors: [
                                .clear,
                                Color(
                                    red: 237/255,
                                    green: 240/255,
                                    blue: 241/255
                                )],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
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
//        ProblemCardView()
//    ProblemCreatingView()
}
