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
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(problem)
                    .font(.title2)
                Text(answer)
                    .fontWeight(.medium)
            }
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .accessibilityHidden(true)
        }
        .padding()
        .frame(width: 300, alignment: .leading)
        .frame(minHeight: 100)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
    }
}
