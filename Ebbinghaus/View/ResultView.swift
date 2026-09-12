//
//  ResultView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/20.
//
import SwiftUI
import ConfettiSwiftUI

struct ResultView: View {
    @Binding var path: NavigationPath
    @State private var appear1 = false
    let resultViewData: ResultViewData
    let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
    //    window.screen.bounds.height
    var body: some View {
        GeometryReader {geometry in
            VStack {
                VStack {
                    Text("Finish!")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                        .padding()
                    Text("お疲れ様でした")
                        .foregroundStyle(.white)
                }
                .frame(height: geometry.size.height/4)
                Text("フィードバック")
                    .foregroundStyle(.white)
                TabView {
                    Tab("Account", systemImage: "earth") {
                        ResultViewCount(resultViewData: resultViewData)
                    }
                    Tab("Account", systemImage: "earth") {
                        ResultViewCorrect(resultViewData: resultViewData)
                    }
                    Tab("Account", systemImage: "earth") {
                        ResultViewIncorrect(incorrectProblem: resultViewData.incorrectProblem, geometry: geometry)
                    }
                    Tab("Account", systemImage: "earth") {
                        ResultViewNext(resultViewData: resultViewData)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: geometry.size.height/2)
                .overlay() {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 1)
                }
                .padding()
                // %回目で復習を辞めた人は...
                        Button(action: {
                            shareOnTwitter()
                        }, label: {
                            Text("Xで継続記録をシェア")
                                .underline()
                                .foregroundStyle(.white)
                        })

                Button("< ホーム面に戻る") {
                    let num = path.count
                    path.removeLast(num)
                }
                .underline()
                .foregroundStyle(.white)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .confettiCannon(trigger: $appear1)
        }
        .background() {
            Color(red: 127/255, green: 163/255, blue: 242/255)
                .ignoresSafeArea()
        }
        .onAppear() {
            appear1 = true
        }
        .navigationBarBackButtonHidden(true)
    }
    func shareOnTwitter() {
        let text = "\(resultViewData.nextPhase.rawValue - 1)回目の復習完了！\n\"\(resultViewData.problemSet)\"の復習をしました。\n\n \"EbbingHaus\"を使って忘却曲線に沿った復習をしよう！\n\n#EbbingHaus \n#忘却曲線 \n#復習"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if let encodedText = encodedText, let url = URL(string: "https://x.com/compose/post?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
        
    }
    
}

struct ResultViewIncorrect: View {
    let incorrectProblem: IncorrectProblem?
    let geometry: GeometryProxy
    var body: some View {
        ScrollView {
            VStack {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 10)
                Text("間違えた問題")
                    .font(.largeTitle.bold())
                if let incorrectProblem = incorrectProblem {
                    Text("現在、間違えた回数が最も多い問題です。次は正解しよう！")
                        .padding()
                    VStack(alignment: .leading) {
                        Text("問題 - \(incorrectProblem.problem)")
                            .padding(.bottom)
                        Text("正答 - \(incorrectProblem.correctAnswer)")
                            .padding(.bottom)
                        Text("あなたの回答 - \(incorrectProblem.answer)")
                            .padding(.bottom)
                    }
                    .foregroundStyle(.black)
                    .padding()
                    .frame(width: geometry.size.width*0.8)
                    .background(Color(red: 242/255, green: 244/255, blue: 245/255))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay() {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.blue, lineWidth: 1)
                    }
                } else {
                    VStack {
                        Text("🎉")
                            .font(.title)
                            .padding()
                        Text("間違えた問題はありませんでした。")
                        Text("素晴らしい！")
                    }
                    .padding()
                }
                
            }
            .foregroundStyle(.white)
        }
    }
}

struct ResultViewCorrect: View {
    let resultViewData: ResultViewData
    var body: some View {
        VStack {
            Text("正答率")
                .font(.largeTitle.bold())
            
            Text("\(resultViewData.correct*100 / (resultViewData.correct + resultViewData.incorrect))%")
                .font(.largeTitle.bold())
                .padding()
            VStack {
                Text("正解した問題数: \(resultViewData.correct)")
                Text("間違えた問題数: \(resultViewData.incorrect)")
            }
        }
        .foregroundStyle(.white)
    }
}

struct ResultViewNext: View {
    let resultViewData: ResultViewData
    var nextDate: String? {
        guard let next = resultViewData.next else {
            return nil
        }
        let date = Date(timeIntervalSince1970: next)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    var body: some View {
        if let date = nextDate {
            VStack {
                Text("次回の復習")
                    .font(.title.bold())
                Text("\(date)")
                    .font(.largeTitle.bold())
                    .padding()
                Text("次も頑張りましょう！")
            }
            .foregroundStyle(.white)
        }
    }
}

struct ResultViewCount: View {
    let resultViewData: ResultViewData
    var message: String {
        if resultViewData.nextPhase.rawValue == 6 {
            "5回にわたる復習完了！"
        } else {
            "継続は力なり！"
        }
    }
    var body: some View {
        VStack {
            Text("\(resultViewData.nextPhase.rawValue-1)回目の復習")
                .foregroundStyle(.white)
                .font(.largeTitle.bold())
            HStack {
                ForEach(1..<6) { i in
                    if i < resultViewData.nextPhase.rawValue {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.green)
                            .frame(width: 30, height: 30)
                            .padding([.leading], 2)
                    } else {
                        Circle()
                            .fill(resultViewData.nextPhase.rawValue >= i ? (resultViewData.nextPhase.rawValue == i ? .yellow : .green) : .gray)
                            .frame(width: 30, height: 30)
                        
                    }
                }
            }
            Text("継続は力なり！")
                .foregroundStyle(.white)
                .padding()
        }
    }
}


#Preview {
    @Previewable @State var path = NavigationPath()
    var resultViewData = ResultViewData(
        nextPhase: .phase3,
        problemSet: "Async/Swift",
        next: 100000,
        correct: 5,
        incorrect: 1
    )
    ResultView(path: $path, resultViewData: resultViewData)
}
