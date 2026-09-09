//
//  PracticeVie.swift
//  Ebbinghaus
//  
//  Created by keeki-fami on 2026/09/08
//  
//

import SwiftUI

struct PracticeView: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            .background (
                Color.red
                    .ignoresSafeArea()
            )
        Rectangle()
    }
}

#Preview {
    PracticeView()
}
