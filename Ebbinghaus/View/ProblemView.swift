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
    @State private var isSuccess: Bool = false
    
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
        if nowSolvePhase == .solved {
            Button(isSuccess ? "不正解として処理する" : "正解として処理する") {
                if nowProblem + 1 ==  problemSet.problem.count {
                    path.append(Result.result)
                } else {
                    nowProblem += 1
                    withAnimation {
                        nowSolvePhase = .solving
                    }
                }
            }
        }
        Button(action: {
            if nowSolvePhase == .solved {
                if nowProblem + 1 ==  problemSet.problem.count {
                    path.append(Result.result)
                } else {
                    withAnimation {
                        nowProblem += 1
                    }
                    nowSolvePhase = .solving
                }
            } else {
                if focus != nil {
                    focus = nil
                } else {
                    // 問題の生後判定をする。
                    withAnimation {
                        nowSolvePhase = .solved
                    }

                }
            }
        }, label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: 300, height: 50)
                .shadow(color: .black.opacity(0.25), radius: 10)
                .overlay() {
                    if nowSolvePhase == .solved {
                        Text("次へ")
                    } else {
                        Text(focus == nil ? "解答" : "OK")
                    }
                }
                .padding()
        })
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
