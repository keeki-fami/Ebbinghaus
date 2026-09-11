//
//  ResultView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/20.
//
import SwiftUI
import ConfettiSwiftUI

struct Appear1 {
    var body = false
    var confetti = false
}

struct ResultView: View {
    @Binding var path: NavigationPath
    @State private var appear1 = Appear1()
    @State private var appear2: Bool = false
    @State private var appear3: Bool = false
    let resultViewData: ResultViewData
    let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
//    window.screen.bounds.height
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
        GeometryReader {geometry in
            ScrollView {
                VStack {
                    LazyVStack {
                        Text("Finish!")
                            .foregroundStyle(.white)
                            .font(.largeTitle.bold())
                            .padding()
                        Text("お疲れ様でした")
                            .foregroundStyle(.white)
                            .opacity(appear1.body ? 1 : 0)
                            .animation(.linear(duration: 0.5), value: appear1.body)
                    }
                    .frame(height: geometry.size.height)
                    .task() {
                            try? await Task.sleep(nanoseconds: 500000000) // 0.5秒 1秒10^9ナノ秒
                            appear1.confetti = true
                            try? await Task.sleep(nanoseconds: 250000000)
                            appear1.body = true
                        
                    }
                    .confettiCannon(trigger: $appear1.confetti)
                    
                    LazyVStack {
                        Text("\(resultViewData.nextPhase.rawValue-1)回目の復習")
                            .foregroundStyle(.white)
                            .font(.largeTitle.bold())
                            .padding()
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
                    }
                    .frame(height: geometry.size.height)
                    .opacity(appear2 ? 1 : 0)
                    .onAppear() {
                        appear2 = true
                    }
                    
                    LazyVStack {
                        Text("正答率")
                            .font(.title)
                        Text("\(resultViewData.correct*100 / (resultViewData.correct + resultViewData.incorrect))%")
                            .font(.largeTitle.bold())
                            .padding()
                        Text("正解した問題数: \(resultViewData.correct)")
                        Text("間違えた問題数: \(resultViewData.incorrect)")
                    }
                    .foregroundStyle(.white)
                    .frame(height: geometry.size.height)
                    .opacity(appear3 ? 1 : 0)
                    .onAppear() {
                        appear3 = true
                    }
                    // %回目で復習を辞めた人は...
                    
                    VStack {
                        Text("間違えた問題")
                            .font(.largeTitle.bold())
                        Text("現在、間違えた回数が最も多い問題です。次は正解しよう！")
                            .padding()
                    }
                    .foregroundStyle(.white)
                    .frame(height: geometry.size.height)
                    
                    if let date = nextDate {
                        Text("Next - \(date)")
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    VStack {
                        HStack {
                            Button(action: {
                                shareOnTwitter()
                            }, label: {
                                Image("X_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            })
                            Text("Xで継続記録をシェア")
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(maxWidth: 250, maxHeight: .infinity)
                    
                    Button("ホーム面に戻る") {
                        let num = path.count
                        path.removeLast(num)
                    }
                    .foregroundStyle(.white)
                    .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background() {
                Color(red: 127/255, green: 163/255, blue: 242/255)
                    .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    func shareOnTwitter() {
        let text = "O回目の復習完了！ \"EbbingHaus\"を使って忘却曲線に沿った復習をしよう！\n\n#EbbingHaus \n#忘却曲線 \n#復習"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        if let encodedText = encodedText, let url = URL(string: "https://x.com/compose/post?text=\(encodedText)") {
            UIApplication.shared.open(url)
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
