//
//  ProblemView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/20.
//
import SwiftUI

struct ProblemView: View {
    enum Focus {
        case textEd
    }
    var problemSet: ProblemSet
    @FocusState private var focus: Focus?
    @State private var nowSolvePhase: SolvePhase = .solving
    @State private var nowProblem: Int = 0
    @State private var inputText: String = ""
    @Binding var path: NavigationPath
    
    var body: some View {
        ProgressView(value: Double(nowProblem)/Double(problemSet.problem.count))
            .padding()
        Spacer()
        Group {
            if problemSet.problem.count > 0 {
                ScrollView {
                    Text("\(problemSet.problem[nowProblem].problem)")
                    TextEditor(text: $inputText)
                        .frame(width: 350, height: 200)
                        .overlay() {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        }
                        .focused($focus, equals: .textEd)
                        .padding()
                    
                    
                    .textFieldStyle(.roundedBorder)
                    if nowSolvePhase == .solved {
                        Text("\(problemSet.problem[nowProblem].answer)")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //            .background(.gray)
        Spacer()
        if nowSolvePhase == .solving {
            Button(action: {
                if focus != nil {
                    focus = nil
                } else {
                    withAnimation {
                        nowSolvePhase = .solved
                    }
                }
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 300, height: 50)
                    .shadow(color: .black.opacity(0.25), radius: 10)
                    .overlay() {
                        Text(focus == nil ? "解答" : "OK")
                    }
                    .padding()
            })
        } else {
            if nowProblem == problemSet.problem.count - 1 {
                HStack {
                    Button(action: {
                        path.append(Result.result)
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.red)
                            .shadow(color: .black.opacity(0.25), radius: 10)
                    })
                    Button(action: {
                        path.append(Result.result)
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
        //        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
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
