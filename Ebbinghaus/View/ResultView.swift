//
//  ResultView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/20.
//
import SwiftUI

struct ResultView: View {
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            VStack {
                Text("Finish!")
                    .fontWeight(.light)
                    .font(.title)
                    .padding()
                Text("お疲れ様でした")
                    .foregroundStyle(Color(red: 157/255, green: 157/255, blue: 157/255))
                    .fontWeight(.thin)
            }
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text("Next - 2222/2/2")
            Spacer()
            VStack {
                Button(action: {
                    shareOnTwitter()
                }, label: {
                    HStack {
                        Image("X_logo")
                            .resizable()
                            .scaledToFit()
                        //                    .clipShape(Circle())
                            .frame(width: 30, height: 30)
                        //                Circle()
                        //                    .frame(width: 30, height: 30)
                        Spacer()
                        Text("Xでシェア")
                    }
                    .padding()
                })
//                HStack {
//                    Image("Studyplus_logo")
//                        .resizable()
//                        .scaledToFit()
//                    //                    .clipShape(Circle())
//                        .frame(width: 30, height: 30)
//                    //                Circle()
//                    //                    .frame(width: 30, height: 30)
//                    Spacer()
//                    Text("StudyPlusでシェア")
//                }
//                .padding()
            }
            .frame(maxWidth: 250, maxHeight: .infinity)
            
            Button("ホーム面に戻る") {
                if path.count >= 2 {
                    path.removeLast(2)
                } else {
                    path.removeLast(path.count)
                }
            }
            .padding()
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
    ResultView(path: $path)
}
