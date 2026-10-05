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
                    Text(String(localized: "result.text"))
                        .foregroundStyle(.white)
                }
                .frame(height: geometry.size.height/4)
                Text(String(localized: "result.feedback.text"))
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
                            Text(String(localized: "result.button.x"))
                                .underline()
                                .foregroundStyle(.white)
                        })

                Button("< " + String(localized: "button.toHome")) {
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
        let text = String(
            format: String(localized: "result.xPost"),
            resultViewData.nextPhase.rawValue - 1, resultViewData.problemSet
        )
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
                Text(String(localized: "result.feedback3.title"))
                    .font(.largeTitle.bold())
                if let incorrectProblem = incorrectProblem {
                    Text(String(localized: "result.feedback3.text"))
                        .padding()
                    VStack(alignment: .leading) {
                        Text(String(localized: "result.feedback3.problem") + " - \(incorrectProblem.problem)")
                            .padding(.bottom)
                        Text(String(localized: "result.feedback3.correctAnswer") + " - \(incorrectProblem.correctAnswer)")
                            .padding(.bottom)
                        Text(String(localized: "result.feedback3.yourAnswer") +  " - \(incorrectProblem.answer)")
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
                        Text(String(localized: "result.noMiss"))
                        Text(String(localized: "result.great"))
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
             Text(String(localized: "result.feedback2.title1"))
                 .font(.largeTitle.bold())
             
             Text("\(resultViewData.correct*100 / (resultViewData.correct + resultViewData.incorrect))%")
                 .font(.largeTitle.bold())
                 .padding()
             VStack {
                 Text(String(localized: "result.feedback2.correctText") + ": \(resultViewData.correct)")
                 Text(String(localized: "result.feedback2.incorrectText") + ": \(resultViewData.incorrect)")
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
        formatter.dateFormat = String(localized: "result.feedback4.dateFormatter")
        return formatter.string(from: date)
    }
     var body: some View {
         if let date = nextDate {
             VStack {
                 Text(String(localized: "result.feedback4.title"))
                     .font(.title.bold())
                 Text("\(date)")
                     .font(.largeTitle.bold())
                     .padding()
                 Text(String(localized: "result.feedback4.text"))
             }
             .foregroundStyle(.white)
         }
     }
}

struct ResultViewCount: View {
     let resultViewData: ResultViewData
     var message: String {
          if resultViewData.nextPhase.rawValue == 6 {
              String(localized: "result.feedback2.5times")
          } else {
              String(localized: "result.feedback1.text1")
          }
      }
     var body: some View {
         VStack {
//             Text("\(resultViewData.nextPhase.rawValue-1)回目の復習")
             Text(
                String(
                    format: String(localized: "result.feedback1.title"),
                    resultViewData.nextPhase.rawValue-1)
             )
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
             Text(String(localized: "result.feedback1.text1"))
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
