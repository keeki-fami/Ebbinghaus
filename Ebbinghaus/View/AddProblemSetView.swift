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
    
    enum AddMethod {
        case manual
        case capture
    }
    
    @State private var setName: String = ""
    @State private var nowPhase = ProblemSetPhase.phase1
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @FocusState private var focus: Field?
    @State var problemCreatingViewModel = ProblemCreatingViewModel()
    @Binding var path: NavigationPath
    @State private var selectedAddMethod: AddMethod = .manual
    
    enum Screen: Hashable {
        case complete
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(nowPhase == .phase2 ? "問題集の名前を入力してください" : nowPhase == .phase1 ? "問題を追加してください。" : "nil")
                .fontWeight(.medium)
            Spacer()
            // 問題セット名
            if nowPhase == .phase2 {
                TextField("問題セット名を入力", text: $setName)
                    .font(.largeTitle)
                    .textFieldStyle(.plain)
                    .focused($focus, equals: .setName)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
            } else if nowPhase == .phase1 {
                ScrollView {
                    VStack {
                        ForEach(problemCreatingViewModel.problems) { problem in
                            ProblemCardView(
                                problem: problem.problem,
                                answer: problem.answer
                            )
                        }
                        Menu {
                            Button {
                                selectedAddMethod = .manual
                            } label: {
                                Text("手動で入力する")
                            }
                            
                            Button {
                                selectedAddMethod = .capture
                            } label: {
                                Text("写真で撮影する")
                            }
                        } label: {
                            Circle()
                                .fill(.white)
                                .frame(width: 60, height: 60)
                                .shadow(
                                    color: .black.opacity(0.25),
                                    radius: 10,
                                    x: 0,
                                    y: 0
                                )
                                .overlay {
                                    Text("+")
                                        .font(.system(size: 28, weight: .medium))
                                }
                                .padding()
                        }
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
                    nowPhase = .phase2
                } else if nowPhase == .phase2 {
                    //                      nowPhase = .phase3
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                    let problemset = ProblemSet(setName: setName, problem: problemCreatingViewModel.problems, notifyDate: tomorrow.timeIntervalSince1970, status: .phase1)
                    
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
                            .fontWeight(.medium)
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
            .fontWeight(.medium)
        })
        
        //            .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            focus = nil
        }
        .onAppear {
            focus = .setName
        }
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

#Preview {
    @Previewable @State var path = NavigationPath()
    AddProblemSetView(path: $path)
}
