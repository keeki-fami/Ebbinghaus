//
//  ProblemView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/20.
//
import SwiftUI

struct ProblemView: View {
    var problemSet: ProblemSet
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
