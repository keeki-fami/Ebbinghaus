//
//  ProblemCardView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/20.
//
import SwiftUI

struct ProblemCardView: View {
    let problem: String
    let answer: String
    var body: some View {
        Rectangle()
            .fill(
                .white
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
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                .padding()
            }
            .overlay(alignment: .trailing) {
                Text(">")
                    .padding()
                    .frame(maxWidth :50, maxHeight: .infinity)
            }
    }
}
