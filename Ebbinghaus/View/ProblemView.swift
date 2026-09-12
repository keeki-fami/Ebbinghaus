//
//  ProblemView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/20.
//
import SwiftUI
import SwiftData

struct ProblemView: View {
    enum Focus {
        case textEd
    }
    var problemSet: ProblemSet
    @FocusState private var focus: Focus?
    @State private var nowSolvePhase: SolvePhase = .solving
    @State private var nowProblem: Int = 0
    @State private var progressVar: Int = 0
    @State private var inputText: String = ""
    @Binding var path: NavigationPath
    @State private var isSuccess: Bool = false
    @State private var isAnimated: Bool = false
    @State private var checkList: [String: Bool] = .init()
    @State private var correctCount = 0
    @Environment(\.modelContext) var context
    @State private var incorrectProblem: IncorrectProblem?
    
    
    struct backgroundAnimator {
        var opacity = 0.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            
            ZStack {
                VStack {
                    ProgressView(value: Double(progressVar)/Double(problemSet.problem.count))
                        .padding()
                    Spacer()
                    Group {
                        if problemSet.problem.count > 0 {
                            ScrollView {
                                Text("\(problemSet.problem[nowProblem].problem)")
                                Text(problemSet.problem[nowProblem].problemType == .wordProblem ? "文章題" : "一問一答")
                                    .fontWeight(.thin)
                                
                                TextField("回答を入力", text: $inputText, axis: .vertical)
                                    .textFieldStyle(textFields())
                                    .lineLimit(5...10)
                                    .focused($focus, equals: .textEd)
                                    .padding()
                                //                                .padding()
                                
                                if nowSolvePhase == .solved {
                                    if isSuccess {
                                        Text("🥳正解!")
                                            .foregroundStyle(.green)
                                            .fontWeight(.bold)
                                    } else {
                                        Text("😱不正解...")
                                            .font(Font.largeTitle.bold())
                                            .foregroundStyle(.gray)
                                            .fontWeight(.bold)
                                    }
                                    VStack {
                                        Text("答え")
                                            .foregroundStyle(.gray)
                                            .fontWeight(.medium)
                                        Text("\(problemSet.problem[nowProblem].answer)")
                                            .padding()
                                    }
                                    .padding()
                                    .frame(width: geometry.size.width*0.8)
                                    .background(Color(red: 242/255, green: 244/255, blue: 245/255))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay() {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blue, lineWidth: 1)
                                    }
                                    if problemSet.problem[nowProblem].problemType == .wordProblem {
                                        LazyVStack {
                                            Text("キーワードチェック")
                                                .fontWeight(.medium)
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
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                    //                if nowSolvePhase == .solved {
                    //                    Button(isSuccess ? "不正解として処理する" : "正解として処理する") {
                    //                        handleSubButton()
                    //                    }
                    //                }
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
                .background(
                    Color.blue.opacity(0.1)
                        .ignoresSafeArea()
                )
                //            .background(
                //                (isSuccess ? Color.green.opacity(0.5) : Color.red.opacity(0.5))
                //                    .ignoresSafeArea()
                //                    .keyframeAnimator(initialValue: backgroundAnimator(), trigger: isAnimated, content: { content, value in
                //                        content
                //                            .opacity(value.opacity)
                //
                //                    } , keyframes: { _ in
                //                        KeyframeTrack(\.opacity) {
                //                            MoveKeyframe(0.5)
                //                            LinearKeyframe(0.5, duration: 0.25)
                //                            CubicKeyframe(0.0, duration: 1)
                //                        }
                //
                //                    })
                //            )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func updateProblemSetStatus() {
        let nowPhase = problemSet.status
        switch nowPhase {
        case .phase1:
            problemSet.status = .phase2
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*3-1
        case .phase2:
            problemSet.status = .phase3
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*7-1
        case .phase3:
            problemSet.status = .phase4
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*14-1
        case .phase4:
            problemSet.status = .phase5
            problemSet.notifyDate = Date().timeIntervalSince1970 + 60*60*24*30-1
        case .phase5:
            problemSet.status = .complete
        default:
            print("")
        }
    }
    
    func generateTrigger(phase: Phase) -> TimeInterval {
        switch phase {
        case .phase1:
            return 60*60*24-1
        case .phase2:
            return 60*60*24*2-1
//            return 15
        case .phase3:
            return 60*60*24*6-1
        case .phase4:
            return 60*60*24*13-1
        case .phase5:
            return 60*60*24*29-1
        default:
            // completeも
            return 0
        }
    }
    
    func handleMainButton() {
        if nowSolvePhase == .solved {
            // 問題終了
            if nowProblem + 1 ==  problemSet.problem.count {
                
                var resultViewData: ResultViewData
                if UserDefaults.standard.bool(forKey: "isUpdateStatus") {
                    updateProblemSetStatus()
                }
                
                // completeになった場合は、削除
                if problemSet.status == .complete {
                    context.delete(problemSet)
                    
                    let problemCount = problemSet.problem.count
                    resultViewData = ResultViewData(
                        nextPhase: problemSet.status,
                        problemSet: problemSet.setName,
                        next: nil,
                        correct: correctCount,
                        incorrect: problemCount - correctCount
                    )
                } else {
                    
                    // 通知登録処理
                    let notificationContent = UNMutableNotificationContent()
                    notificationContent.title = "Ebbinghaus"
                    print("\(problemSet.setName) | \(problemSet.status.rawValue)回目の復習をしましょう！")
                    notificationContent.body = "\(problemSet.setName) | \(problemSet.status.rawValue)回目の復習をしましょう！"
                    let time = generateTrigger(phase: problemSet.status)
                    print("\(time)秒後")
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) {error in
                        if let error = error {
                            print("error is occured: \(error.localizedDescription)")
                        }
                    }
                    
                    let problemCount = problemSet.problem.count
                    resultViewData = ResultViewData(
                        nextPhase: problemSet.status,
                        problemSet: problemSet.setName,
                        next: problemSet.notifyDate,
                        correct: correctCount,
                        incorrect: problemCount - correctCount,
                        incorrectProblem: incorrectProblem
                    )
                    
                }
                path.append(resultViewData)
                
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
                // 文章題
                var generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
                if problemSet.problem[nowProblem].problemType == .wordProblem {
                    if checkKeyword() {
                        correctCount += 1
                        isSuccess = true
                        generator.prepare()
                        generator.notificationOccurred(.success)
                    } else {
                        isSuccess = false
                        let problem = problemSet.problem[nowProblem]
                        incorrectProblem = IncorrectProblem(
                            problem: problem.problem,
                            answer: inputText,
                            correctAnswer: problem.answer
                        )
                        generator.prepare()
                        generator.notificationOccurred(.error)
                        problemSet.problem[nowProblem].missCount += 1
                    }
                } else {
                    // 一問一答
                    if problemSet.problem[nowProblem].answer == inputText {
                        isSuccess = true
                        generator.prepare()
                        generator.notificationOccurred(.success)
                    } else {
                        generator.prepare()
                        generator.notificationOccurred(.error)
                        isSuccess = false
                        let problem = problemSet.problem[nowProblem]
                        incorrectProblem = IncorrectProblem(
                            problem: problem.problem,
                            answer: inputText,
                            correctAnswer: problem.answer
                        )
                        problemSet.problem[nowProblem].missCount += 1
                    }
                    
                }
                withAnimation {
                    progressVar += 1
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
