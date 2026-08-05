//
//  ProblemCreatingView.swift
//  Ebbinghaus
//
//  Created by 櫻田聖和 on 2026/07/20.
//
import SwiftUI

@Observable
class ProblemCreatingViewModel {
    var problems: [ProblemData] = []
    
    func addProblem(problem: ProblemData) {
        problems.append(problem)
    }
    
    func addProblemSet() {
        
    }
}

struct ProblemCreatingView: View {
    @State private var problem = ""
    @State private var answer = ""
    @State private var keyword: [String] = []
    @FocusState private var focus: Field?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Binding var problemCreatingViewModel: ProblemCreatingViewModel
    
    enum Field: Hashable {
        case problem
        case answer
        case keyword
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("問題の作成をしてください。")
                    .fontWeight(.thin)
                VStack {
                    HStack {
                        Text("問題")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                        Spacer()
                    }
                    HStack {
                        TextField("問題の内容を入力してください。", text: $problem, axis: .vertical)
                            .textFieldStyle(.plain)
                            .focused($focus, equals: .problem)
                        Spacer()
                    }
                }
                .padding()
                VStack {
                    HStack {
                        Text("解答")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                        Spacer()
                    }
                    HStack {
                        TextField("解答例を入力してください。", text: $answer, axis: .vertical)
                            .textFieldStyle(.plain)
                            .focused($focus, equals: .answer)
                        Spacer()
                    }
                }
                .padding()
                VStack {
                    HStack {
                        Text("キーワード")
                            .font(.largeTitle)
                            .fontWeight(.thin)
                        Spacer()
                    }
                        ForEach(keyword.indices, id: \.self) { idx in
                            HStack {
                                TextField("キーワード\(idx+1)", text: $keyword[idx], axis: .vertical)
                                    .textFieldStyle(.plain)
                                    .focused($focus, equals: .keyword)
                                Spacer()
                            }
                        }
                        .onDelete { indexSet in
                            keyword.remove(atOffsets: indexSet)
                        }
                    Button (action: {
                        keyword.append("")
                    }, label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 60, height: 60)
                            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 0)
                            .overlay() {
                                Text("+")
                                    .font(.largeTitle)
                                    .fontWeight(.thin)
                            }
                    })
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture{
                focus = nil
            }

                Button(action: {
                    if !(problem.isEmpty || answer.isEmpty) && focus == nil {
                        let problem = ProblemData(
                            problem: problem,
                            answer: answer,
                            keyword: keyword
                        )
                        problemCreatingViewModel.addProblem(problem: problem)
                        dismiss()
                    } else {
                        focus = nil
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(!(problem.isEmpty || answer.isEmpty) && focus == nil ? .blue : .white)
                        .shadow(color: .black.opacity(0.25), radius: 5)
                        .frame(maxWidth: 350,  maxHeight: 50)
                        .padding()
                        .overlay() {
                            Text(!(problem.isEmpty || answer.isEmpty) && focus == nil ? "追加" : "決定")
                                .fontWeight(.thin)
                                .foregroundStyle(!(problem.isEmpty || answer.isEmpty) && focus == nil ? .white : .black)
                        }
                })
            
        }
    }
}
