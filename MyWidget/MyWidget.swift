//
//  MyWidget.swift
//  MyWidgetExtension
//  
//  Created by keeki-fami on 2026/09/19
//  
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

extension TimeInterval {
    var getStringFormat: String {
        let hour = Int(self)/3600
        let minute = Int(self) % 60
        return "\(hour):\(minute)"
    }
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry
    let date = Date().timeIntervalSince1970
    @Query() private var data: [ProblemSet]
    var todaySet: [ProblemSet] {
        let date = Date()
        return data.filter {
            $0.notifyDate - date.timeIntervalSince1970 > 0 &&
            $0.notifyDate - date.timeIntervalSince1970 < 86400
        }
    }
    
    
    var body: some View {
        if todaySet.isEmpty {
            VStack {
                Spacer()
                Text("🎉")
                    .font(Font.largeTitle)
                    .padding()
                Spacer()
                VStack {
                    Text("復習完了！")
                    Text("良い1日を！")
                }
                .foregroundStyle(Color.white)
                .fontWeight(.medium)
                .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background() {
                Color(red: 119/255, green: 192/255, blue: 255/255)
            }
        } else {
            VStack {
                Text("\(data.first!.setName)")
                    .font(Font.largeTitle.bold())
                    .minimumScaleFactor(0.5)
                Text("\(data.first!.status.rawValue)回目の復習！")
                Text((todaySet.first!.notifyDate - Date().timeIntervalSince1970).getStringFormat)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background() {
                LinearGradient(
                    stops: [
                        .init(color: Color(red: 58/255, green: 118/255, blue: 214/255), location: 0.0),
                        .init(color: Color(red: 38/255, green: 62/255, blue: 112/255), location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .all)
            }
        }
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: [ProblemSet.self])
        }
        .configurationDisplayName("モニター")
        .description("24時間以内に復習すると、効率的な問題集を表示します。")
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    MyWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
