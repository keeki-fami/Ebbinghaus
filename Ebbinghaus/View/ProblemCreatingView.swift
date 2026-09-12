//
//  ProblemCreatingView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/20.
//
import SwiftUI
import SwiftData

@Observable
class ProblemCreatingViewModel {
    var problems: [ProblemData] = []
    
    func addProblem(problem: ProblemData) {
        problems.append(problem)
    }
    
    func addProblemSet() {
        
    }
}

struct KeyWordElement: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var text: String = ""
}

struct ProblemCreatingView: View {
    @State private var problem = ""
    @State private var answer = ""
    @State private var keyword: [KeyWordElement] = []
    @FocusState private var focus: Field?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @Binding var problemCreatingViewModel: ProblemCreatingViewModel
    @State private var isKeyword = false
    @State private var isAlert = false
    @State private var afterAdd = false
    @State private var problemData: ProblemData?
    
    init(problemCreatingViewModel: Binding<ProblemCreatingViewModel>) {
        _problemCreatingViewModel = problemCreatingViewModel
    }
    
    init(data: ProblemData, problemCreatingViewModel: Binding<ProblemCreatingViewModel>) {
        self._problemCreatingViewModel = problemCreatingViewModel
        self._afterAdd = State(initialValue: true)
        self._problemData = State(initialValue: data)
        self._problem = State(initialValue: data.problem)
        self._answer = State(initialValue: data.answer)
        self._keyword = State(
            initialValue: data.keyword.map {
                KeyWordElement(text: $0)
            }
        )
        if data.problemType == .wordProblem {
            self._isKeyword = State(initialValue: true)
        } else {
            self._isKeyword = State(initialValue: false)
        }
    }
    
    enum Field: Hashable {
        case problem
        case answer
        case keyword
    }
    
    var body: some View {
//        NavigationStack {
        VStack {
            ScrollView {
                Text("問題の作成をしてください。")
                    .fontWeight(.medium)
                VStack {
                    HStack {
                        Text("問題")
                            .font(.largeTitle)
                            .fontWeight(.medium)
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
                            .fontWeight(.medium)
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
                        Toggle("", isOn: $isKeyword)
                            .labelsHidden()
                        Text("正解判定に、キーワードを使用する")
                        Spacer()
                    }
                    Text("上のボタンがOFFの場合は、答えと同じ回答のみ正解にします。上のボタンがONの場合は、解答に、指定したキーワードがすべて含まれていた場合に正解にします。")
//                        .font(.custom("", size: 20))
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
                .padding()
                if isKeyword {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("キーワード")
                                    .font(.largeTitle)
                                    .fontWeight(.medium)
                                Text("解答に含める単語を入力してください。")
                            }
                            Spacer()
                        }
                        ForEach(keyword.indices, id: \.self) { idx in
                            HStack {
                                Button(action: {
                                    let element = keyword[idx]
                                    keyword = keyword.filter{$0 != element}
                                },label: {
                                    Circle()
                                        .fill(.red)
                                        .frame(width: 25, height: 25)
                                        .overlay() {
                                            Text("-")
                                                .foregroundStyle(.white)
                                        }
                                })
                                TextField("キーワード\(idx+1)", text: $keyword[idx].text, axis: .vertical)
                                    .textFieldStyle(.plain)
                                    .focused($focus, equals: .keyword)
                                Spacer()
                            }
                        }
                        Button (action: {
                            var element = KeyWordElement()
                            keyword.append(element)
                        }, label: {
                            Circle()
                                .fill(.white)
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 0)
                                .overlay() {
                                    Text("+")
                                        .font(.largeTitle)
                                        .fontWeight(.medium)
                                }
                        })
                    }
                    .padding()
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 300)
                    
                }
            }
            .contentShape(Rectangle())
            .onTapGesture{
                focus = nil
            }
            
            Button(action: {
                var flag: Bool = true
                for word in keyword {
                    if word.text.isEmpty {
                        flag = false
                    }
                }
                if keyword.isEmpty {
                    flag = false
                }
                if focus == nil {
                    if !(problem.isEmpty || answer.isEmpty) && (!isKeyword || (isKeyword && flag)) {
                        if !afterAdd {
                            // 空のところがあったらアラートを出す。
                            print(isKeyword)
                            var keyWord: [String] = .init()
                            keyword.forEach {
                                keyWord.append($0.text)
                            }
                            let problem = ProblemData(
                                problem: problem,
                                answer: answer,
                                keyword: keyWord,
                                problemType: isKeyword ? .wordProblem : .oneOnOne
                            )
                            print("problemType; \(problem.problemType)")
                            problemCreatingViewModel.addProblem(problem: problem)
                            dismiss()
                        } else {
                            
                            problemData?.answer = self.answer
                            problemData?.problem = self.problem
                            problemData?.problemType = isKeyword ? .wordProblem : .oneOnOne
                            var keyWord: [String] = .init()
                            keyword.forEach {
                                keyWord.append($0.text)
                            }
                            problemData?.keyword = keyWord
                            dismiss()
                        }
                    } else {
                        // アラート
                        isAlert = true
                    }
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
                            .fontWeight(.medium)
                            .foregroundStyle(!(problem.isEmpty || answer.isEmpty) && focus == nil ? .white : .black)
                    }
            })
        }
        .background(
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
        )
        .alert("エラー", isPresented: $isAlert, actions: {
            Button("OK") {}
        }, message: {
            Text(isKeyword ? "問題, 回答, キーワードを全て埋めてください" : "問題, 解答を全て埋めてください。")
        })
    }
}

#Preview {
    @Previewable @State var problemCreatingViewModel = ProblemCreatingViewModel()
    ProblemCreatingView(problemCreatingViewModel: $problemCreatingViewModel)
}

