//
//  AnimationView.swift
//  Ebbinghaus
//  
//  Created by keeki-fami on 2026/09/09
//  
//

import SwiftUI

struct AnimeView: View {
    @State private var count = 0
    var body: some View {
        TimelineView(.periodic(from: .now, by: 2.0)) { context in
            if count % 2 == 0{
                Image("bird1")
            } else {
                Image("bird2")
            }

        }
    }
}

#Preview {
    AnimeView()
}
