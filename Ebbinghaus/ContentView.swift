//
//  ContentView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/08.
//

import SwiftUI
import SwiftData

enum SolvePhase {
    case solving
    case solved
}

enum Result: Hashable {
    case result
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var problemSet: [ProblemSet]
    @State private var isSheet = false
    @State private var isNavigation = false
    @State private var presented: [ProblemSet] = []
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                Group {
                    ForEach(problemSet, id: \.id) { set in
                        Button(action: {
                            print("appending to path: \(set)")
                            path.append(set)
                        }, label: {
                            CardView(
                                setName: set.setName,
                                rest: set.rest,
                                phase: set.status,
                            )
                        })
                        .onAppear {
                            print("problemSet")
                            print("path: \(path)")
                        }
//                        .onChange(of: path) { path in
//                            print(path)
//                        }
                    }
                    .padding([.top], 10)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    isSheet = true
                }, label: {
                    Circle()
                        .fill(.blue)
                        .frame(width: 75, height: 75)
                        .overlay() {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                        }
                })
                .padding(30)
            }
            .navigationDestination(for: ProblemSet.self) { set in
                ProblemView(problemSet: set, path: $path)
            }
            .navigationDestination(for: Result.self) { result in
                ResultView(path: $path)
            }
            .navigationTitle("Home")
            
        }
        .sheet(isPresented: $isSheet) {
            AddProblemSetView()
                .interactiveDismissDisabled()
        }
    }
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: ProblemSet.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true),
        )
        container.mainContext.insert(
            ProblemSet(
                setName: "Math",
                problem: [
                    ProblemData(problem: "1+1=", answer: "2", keyword: ["2"]),
                    ProblemData(problem: "2+1=", answer: "3", keyword: ["3"]),
                    ProblemData(problem: "3+1=", answer: "4", keyword: ["4"]),
                    ProblemData(problem: "4+1=", answer: "5", keyword: ["5"])],
                notifyDate: Date(),
                status: .phase1
            )
        )
        container.mainContext.insert(
            ProblemSet(
                setName: "Math",
                problem: [ProblemData(problem: "2+2=", answer: "4", keyword: ["4"])],
                notifyDate: Date(),
                status: .phase1
            )
        )
        return container
    } catch {
        fatalError("failed to create container")
    }
}()

enum ProblemSetPhase {
    case phase1
    case phase2
    case phase3
}


let container = try? ModelContainer(
    for: ProblemSet.self, ProblemData.self,
    configurations: .init(isStoredInMemoryOnly: true)
)

#Preview {
        ContentView()
            .modelContainer(previewContainer)
//        ProblemCardView()
//    ProblemCreatingView()
}
