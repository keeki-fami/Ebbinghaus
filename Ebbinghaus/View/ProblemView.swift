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
    @State private var isAnimated: Bool = false
    @State private var checkList: [String: Bool] = .init()

    
    struct backgroundAnimator {
        var opacity = 0.0
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSuccess ? .green.opacity(0.5) : .red.opacity(0.5))
                .keyframeAnimator(initialValue: backgroundAnimator(), trigger: isAnimated, content: { content, value in
                    content
                        .opacity(value.opacity)
                    
                } , keyframes: { _ in
                    KeyframeTrack(\.opacity) {
                        MoveKeyframe(0.5)
                        CubicKeyframe(0.0, duration: 1)
                    }
                    
                })
            VStack {
                ProgressView(value: Double(nowProblem)/Double(problemSet.problem.count))
                    .padding()
                Spacer()
                Group {
                    if problemSet.problem.count > 0 {
                        ScrollView {
                            Text("\(problemSet.problem[nowProblem].problem)")
                            
                            TextField("回答を入力", text: $inputText, axis: .vertical)
                                .textFieldStyle(textFields())
                                .lineLimit(5...10)
                                .focused($focus, equals: .textEd)
                                .padding()
//                                .padding()
                            
                                .textFieldStyle(.roundedBorder)
                            if nowSolvePhase == .solved {
                                VStack {
                                    Text("答え")
                                        .fontWeight(.thin)
                                        .padding()
                                    Text("\(problemSet.problem[nowProblem].answer)")
                                        .padding()
                                }
                                LazyVStack {
                                    Text("キーワードチェック")
                                        .fontWeight(.thin)
                                        .padding()
                                    ForEach(problemSet.problem[nowProblem].keyword, id: \.self) { keyword in
                                        if let check = checkList[keyword], !check {
                                            Text("\(keyword) : ❌")
                                        } else {
                                            Text("\(keyword) : ✅")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
                if nowSolvePhase == .solved {
                    Button(isSuccess ? "不正解として処理する" : "正解として処理する") {
                        handleSubButton()
                    }
                }
                Button(action: {
                    handleMainButton()
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
            }
        }
    }
    
    func updateProblemSetStatus() {
        let nowPhase = problemSet.status
        switch nowPhase {
        case .phase1:
            problemSet.status = .phase2
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*3
        case .phase2:
            problemSet.status = .phase3
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*7
        case .phase3:
            problemSet.status = .phase4
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*14
        case .phase4:
            problemSet.status = .phase5
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*30
        case .phase5:
            print("aaa")
        
        }
    }
    
    func handleMainButton() {
        if nowSolvePhase == .solved {
            if nowProblem + 1 ==  problemSet.problem.count {
                if problemSet.notifyDate - Date().timeIntervalSince1970 <= 60*60*24 {
                    updateProblemSetStatus()
                }
                path.append(Result.result)
                
            } else {
                withAnimation {
                    nowProblem += 1
                }
                nowSolvePhase = .solving
            }
            inputText = ""
        } else {
            if focus != nil {
                focus = nil
            } else {
                // 正誤判定
                if checkKeyword() {
                    isSuccess = true
                } else {
                    isSuccess = false
                }
                withAnimation {
                    nowSolvePhase = .solved
                }
                isAnimated.toggle()
                
            }
        }
    }
    
    func handleSubButton() {
        if nowProblem + 1 ==  problemSet.problem.count {
            path.append(Result.result)
        } else {
            nowProblem += 1
            withAnimation {
                nowSolvePhase = .solving
            }
        }
    }
    
    func checkKeyword() -> Bool {
        var flag = true
        let keywords = problemSet.problem[nowProblem].keyword
        checkList = Dictionary.init()
        for (i, word) in keywords.enumerated() {
            if !inputText.contains(word) {
                flag = false
                checkList[word] = false
            } else {
                checkList[word] = true
            }
        }
        return flag
    }
}

//struct textFields: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .overlay() {
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(.gray.opacity(0.5), lineWidth: 1)
//                    .background(.white.opacity(0.25).shadow(.inner(color: .black.opacity(0.25), radius: 5, x: 5, y: 5)))
//                    .allowsHitTesting(false)
//            }
//    }
//}
