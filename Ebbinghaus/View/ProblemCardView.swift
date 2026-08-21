//
//  ProblemCardView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/20.
//
import SwiftUI

struct ProblemCardView: View {
    let problem: String
    let answer: String
    var body: some View {
        Rectangle()
            .fill(
                Color(
                    red: 237/255,
                    green: 240/255,
                    blue: 241/255
                )
            )
            .frame(
                width: 300,
                height: 100
            )
            .overlay() {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(problem)")
                            .font(.largeTitle)
                        Text("\(answer)")
                            .fontWeight(.thin)
                    }
                    Spacer()
                }
                .padding()
            }
            .overlay(alignment: .trailing) {
                Text(">")
                    .padding()
                    .frame(maxWidth :50, maxHeight: .infinity)
                    .background(
                        LinearGradient(
                            colors: [
                                .clear,
                                Color(
                                    red: 237/255,
                                    green: 240/255,
                                    blue: 241/255
                                )],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
    }
}
