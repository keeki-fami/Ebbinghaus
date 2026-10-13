//
//  AddProblemSetView.swift
//  Ebbinghaus
//
//  Created by keeki-fami on 2026/07/20.
//
import SwiftUI
import SwiftData
import ConfettiSwiftUI
import WidgetKit

struct AddProblemSetView: View {
    
    enum Field: Hashable {
        case setName
    }
    
    enum AddMethod {
        case manual
        case capture
    }
    @State private var createdAppear = false
    @State private var setName: String = ""
    @State private var nowPhase = ProblemSetPhase.phase1
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @FocusState private var focus: Field?
    @State var problemCreatingViewModel = ProblemCreatingViewModel()
    @Binding var path: NavigationPath
    @State private var selectedAddMethod: AddMethod = .manual
    @State private var isAlert = false
    let pushedDate: Date
    
    enum Screen: Hashable {
        case complete
    }
    
    private var canContinue: Bool {
        switch nowPhase {
        case .phase1:
            return !problemCreatingViewModel.problems.isEmpty
        case .phase2:
            return !setName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .phase3:
            return true
        }
    }

    var body: some View {
        VStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 50)
                .overlay {
                     switch nowPhase {
                         case .phase1 :
                         Text(String(localized: "addProblem.step1"))
                     case .phase2 :
                         Text(String(localized: "addProblem.step2"))
                     default :
                         Text("")
                     }
                 }
            if nowPhase != .phase2 {
                Spacer()
            }
            Text(nowPhase == .phase2 ? String(localized: "addProblem.step2.description") : nowPhase == .phase1 ? String(localized: "addProblem.step1.creatingProblem.description") : "nil")
                .fontWeight(.medium)
                .padding(.top, nowPhase == .phase2 ? 24 : 0)
            if nowPhase != .phase2 {
                Spacer()
            }
            // 問題セット名
             if nowPhase == .phase2 {
                 TextField(String(localized: "addProblem.step2.textField"), text: $setName)
                    .font(.largeTitle)
                    .textFieldStyle(.plain)
                    .focused($focus, equals: .setName)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 24)
                    .onAppear {
                        focus = .setName
                    }
                
            } else if nowPhase == .phase1 {
                ScrollView {
                    VStack {
                        ForEach(problemCreatingViewModel.problems) { problem in
                            NavigationLink(destination: {
                                ProblemCreatingView(
                                    data: problem,
                                    problemCreatingViewModel: $problemCreatingViewModel
                                )
                            }, label: {
                                ProblemCardView(
                                    problem: problem.problem,
                                    answer: problem.answer
                                )
                                .contextMenu {
                                    Button(String(localized: "button.delete"), role: .destructive) {
                                        if let idx = problemCreatingViewModel.problems.firstIndex(of: problem) {
                                            withAnimation {
                                                problemCreatingViewModel.problems.remove(at: idx)
                                            }
                                        }
                                    }
                                }
                            })
                        }
                        NavigationLink(destination: {
                            ProblemCreatingView(problemCreatingViewModel: $problemCreatingViewModel)
                        }, label: {
                            Circle()
                                .fill(.white)
                                .frame(width: 60, height: 60)
                                .shadow(
                                    color: .black.opacity(0.25),
                                    radius: 10,
                                    x: 0,
                                    y: 0
                                )
                                .overlay {
                                    Text("+")
                                        .font(.system(size: 28, weight: .medium))
                                }
                                .padding()
                        })
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                }
            }
            
            Spacer()
            
            Button(action: {
                if nowPhase == .phase1 {
                    if problemCreatingViewModel.problems.isEmpty {
                        isAlert = true
                    } else {
                        nowPhase = .phase2
                    }
                } else if nowPhase == .phase2 {
                    if focus != nil {
                        withAnimation {
                            focus = nil
                        }
                    } else if canContinue {
                        let problemset = ProblemSet(setName: setName, problem: problemCreatingViewModel.problems, notifyDate: pushedDate.timeIntervalSince1970 + 60*60*24-10, status: .phase1)
                        
                        modelContext.insert(problemset)
                        problemset.problem!.forEach {
                            $0.problemSet = problemset
                        }
                        
                        path.append(Screen.complete)
                    }
                } else {
                    dismiss()
                }
                
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(canContinue && focus == nil  ? .blue : .white)
                    .shadow(color: .black.opacity(0.25), radius: 5)
                    .frame(maxWidth: 350,  maxHeight: 50)
                    .padding()
                    .overlay() {
                         Text(focus == nil ? String(localized: "button.add") : String(localized: "button.determine"))
                             .fontWeight(.medium)
                             .foregroundStyle(canContinue && focus == nil ? .white : .black)
                      }
            })
            .disabled(!canContinue && focus == nil)
            .opacity(!canContinue && focus == nil ? 0.45 : 1)
        }
        .background(
            Color.blue.opacity(0.1)
            .ignoresSafeArea()
        )
         .navigationDestination(for: Screen.self, destination: {_ in
             VStack {
                 Spacer()
                 MiniCardView(
                     setName: setName
                 )
                 .padding(20)
                 Text(String(localized: "addProblem.added.congratulaltion"))
                     .padding(5)
                 Text(String(localized: "addProblem.added.description"))
                     .foregroundStyle(Color(red: 157/255, green: 157/255, blue: 157/255))
                     .padding(5)
                 Spacer()
                 Button(String(localized: "button.toHome")) {
                     let len = path.count
                     path.removeLast(len)
                 }
                .padding(30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.blue.opacity(0.1)
                .ignoresSafeArea()
            )
            .fontWeight(.medium)
            .navigationBarBackButtonHidden(true)
            .confettiCannon(trigger: $createdAppear)
            .onAppear() {
                createdAppear = true
                WidgetCenter.shared.reloadAllTimelines()
                
                // 通知の追加
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "Ebbinghaus"
                print("\(setName) | 1回目の復習をしましょう！")
                notificationContent.body = "\(setName) | 1回目の復習をしましょう！"
                let time = generateTrigger(phase: .phase1)
                print("\(time)秒後")
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
                UNUserNotificationCenter.current().add(request) {error in
                    if let error = error {
                        print("error is occured: \(error.localizedDescription)")
                    }
                }
                
            }
            
        })
        .contentShape(Rectangle())
        .onTapGesture {
            focus = nil
        }
        .alert(String(localized: "addProblem.step1.error.title"), isPresented: $isAlert, actions: {
            Button("OK") {}
        }, message: {
            Text(String(localized: "addProblem.step1.error.descriptionSetEmpty"))
        })
        
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    AddProblemSetView(path: $path, pushedDate: Date())
}
