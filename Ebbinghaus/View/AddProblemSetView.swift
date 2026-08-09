//
//  AddProblemSetView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/20.
//
import SwiftUI
import SwiftData

struct AddProblemSetView: View {
    
    enum Field: Hashable {
        case setName
    }
    
    @State private var setName: String = ""
    @State private var nowPhase = ProblemSetPhase.phase1
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @FocusState private var focus: Field?
    @State var problemCreatingViewModel = ProblemCreatingViewModel()
    @State private var path = NavigationPath()
    
    enum Screen: Hashable {
        case complete
    }
    
    var body: some View {
        NavigationStack(path: $path) {
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
                            ForEach(problemCreatingViewModel.problems) { problem in
                                ProblemCardView(
                                    problem: problem.problem,
                                    answer: problem.answer
                                )
                            }
                            NavigationLink(destination: {
                                ProblemCreatingView(
                                    problemCreatingViewModel: $problemCreatingViewModel
                                )
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

                Button(action: {
                    if nowPhase == .phase1 {
                        if let _ = focus {
                            focus = nil
                        } else {
                            nowPhase = .phase2
                        }
                    } else if nowPhase == .phase2 {
//                      nowPhase = .phase3
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                        let problemset = ProblemSet(setName: setName, problem: problemCreatingViewModel.problems, notifyDate: tomorrow, status: .phase1)
                        
                        modelContext.insert(problemset)
                        problemset.problem.forEach {
                            $0.problemSet = problemset
                        }
                        path.append(Screen.complete)
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
                            Text(focus == nil ? "Next" : "決定")
                                .fontWeight(.thin)
                                .foregroundStyle(.black)
                        }
                })
            }
            .navigationDestination(for: Screen.self, destination: {_ in
                VStack {
                    Spacer()
                    MiniCardView(
                        setName: setName
                    )
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
            })
            
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
#if os(macOS)
                ToolbarItem(
                    placement: .automatic,
                    content: {
                        if nowPhase == .phase2 || nowPhase == .phase1 {
                            Button("戻る") {
                                if nowPhase == .phase2 {
                                    nowPhase = .phase1
                                } else {
                                    dismiss()
                                }
                            }
                        }
                    })
#else
                ToolbarItem(
                    placement: .topBarLeading,
                    content: {
                        if nowPhase == .phase2 || nowPhase == .phase1 {
                            Button("戻る") {
                                if nowPhase == .phase2 {
                                    nowPhase = .phase1
                                } else {
                                    dismiss()
                                }
                            }
                        }
                    })
#endif
            }
        }
    }
}
