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
            Text("Finish!")
            Text("お疲れ様でした")
                .foregroundStyle(Color(red: 157/255, green: 157/255, blue: 157/255))
                .fontWeight(.thin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(.red)
        Text("Next - 2222/2/2")
        Spacer()
        VStack {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                Text("Xでシェア")
            }
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                Text("StudyPlusでシェア")
            }
        }
        .frame(maxWidth: 300, maxHeight: .infinity)
        .border(.red)
        
        Button("ホーム面に戻る") {
            if path.count >= 2 {
                path.removeLast(2)
            } else {
                path.removeLast(path.count)
            }
        }
        .padding()
        .border(.red)
        
    }
}
