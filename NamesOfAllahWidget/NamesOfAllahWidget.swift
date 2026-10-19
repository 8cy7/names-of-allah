//
//  NamesOfAllahWidget.swift
//  NamesOfAllahWidget
//
//  Created by Abdulaziz Alfahad on 23/05/1447 AH.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> NameEntry {
        NameEntry(date: Date(), name: Name.sample, dayNumber: 1)
    }

    func getSnapshot(in context: Context, completion: @escaping (NameEntry) -> ()) {
        let entry = loadCurrentEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [NameEntry] = []
        let calendar = Calendar.current
        
        // Generate entries for next 7 days so widget updates even without app open
        for dayOffset in 0..<7 {
            guard let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: calendar.startOfDay(for: Date())) else { continue }
            let entry = loadEntryForDate(entryDate)
            entries.append(entry)
        }
        
        // Refresh after 7 days
        let refreshDate = calendar.date(byAdding: .day, value: 7, to: Date()) ?? Date()
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }

    private func loadEntryForDate(_ date: Date) -> NameEntry {
        guard let url = Bundle.main.url(forResource: "NamesData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let names = try? JSONDecoder().decode([Name].self, from: data) else {
            return NameEntry(date: date, name: Name.sample, dayNumber: 1)
        }

        let appGroupID = "group.com.alfahad.namesofallah"
        let calendar = Calendar.current
        let targetDay = calendar.startOfDay(for: date)

        // Method 1: Read nameIndex directly from App Group file (most reliable)
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
            let indexFileURL = containerURL.appendingPathComponent("currentNameIndex.txt")
            let dayFileURL = containerURL.appendingPathComponent("currentDayNumber.txt")
            let startDateFileURL = containerURL.appendingPathComponent("appStartDate.txt")

            if let indexStr = try? String(contentsOf: indexFileURL, encoding: .utf8),
               let savedIndex = Int(indexStr.trimmingCharacters(in: .whitespacesAndNewlines)),
               let dayStr = try? String(contentsOf: dayFileURL, encoding: .utf8),
               let savedDay = Int(dayStr.trimmingCharacters(in: .whitespacesAndNewlines)) {

                // For future dates, offset from saved index
                let today = calendar.startOfDay(for: Date())
                let daysOffset = calendar.dateComponents([.day], from: today, to: targetDay).day ?? 0
                let nameIndex = ((savedIndex + daysOffset) % 99 + 99) % 99
                let dayNumber = nameIndex + 1

                let name = names.indices.contains(nameIndex) ? names[nameIndex] : Name.sample
                return NameEntry(date: date, name: name, dayNumber: dayNumber)
            }

            // Method 2: Read start date from file
            if let dateString = try? String(contentsOf: startDateFileURL, encoding: .utf8),
               let timeInterval = Double(dateString.trimmingCharacters(in: .whitespacesAndNewlines)) {
                let startDate = calendar.startOfDay(for: Date(timeIntervalSince1970: timeInterval))
                let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: targetDay).day ?? 0
                let nameIndex = ((daysSinceStart % 99) + 99) % 99
                let dayNumber = nameIndex + 1
                let name = names.indices.contains(nameIndex) ? names[nameIndex] : Name.sample
                return NameEntry(date: date, name: name, dayNumber: dayNumber)
            }
        }

        // Method 3: App Group UserDefaults
        if let groupDefaults = UserDefaults(suiteName: appGroupID),
           let savedDate = groupDefaults.object(forKey: "appStartDate") as? Date {
            let startDate = calendar.startOfDay(for: savedDate)
            let daysSinceStart = calendar.dateComponents([.day], from: startDate, to: targetDay).day ?? 0
            let nameIndex = ((daysSinceStart % 99) + 99) % 99
            let dayNumber = nameIndex + 1
            let name = names.indices.contains(nameIndex) ? names[nameIndex] : Name.sample
            return NameEntry(date: date, name: name, dayNumber: dayNumber)
        }

        // Fallback: day 1
        return NameEntry(date: date, name: names.first ?? Name.sample, dayNumber: 1)
    }

    private func loadCurrentEntry() -> NameEntry {
        return loadEntryForDate(Date())
    }
}

// MARK: - Entry

struct NameEntry: TimelineEntry {
    let date: Date
    let name: Name
    let dayNumber: Int
}

// MARK: - Arabic Number Formatter

private let arabicDigitMap: [Character: Character] = [
    "0": "٠", "1": "١", "2": "٢", "3": "٣", "4": "٤",
    "5": "٥", "6": "٦", "7": "٧", "8": "٨", "9": "٩"
]

extension Int {
    var arabicDigits: String {
        let str = String(self)
        return String(str.map { arabicDigitMap[$0] ?? $0 })
    }
}

// MARK: - Rendering Mode Helper

/// On tinted or clear Home Screens (accented mode) the system tints content white
/// and keeps its opacity, so faint text needs a higher floor to stay readable.
private func readableOpacity(_ opacity: Double, in mode: WidgetRenderingMode) -> Double {
    mode == .fullColor ? opacity : max(opacity, 0.75)
}

// MARK: - Small Widget View

struct SmallWidgetView: View {
    let entry: NameEntry
    @Environment(\.widgetRenderingMode) private var renderingMode

    var body: some View {
        VStack(spacing: 6) {
            // Day counter
            Text("اليوم \(entry.dayNumber.arabicDigits) من ٩٩")
                .font(.custom("IBMPlexSansArabic-Medium", size: 10))
                .foregroundColor(Color(hex: "#ffd89b").opacity(readableOpacity(0.6, in: renderingMode)))

            // Arabic name
            Text(entry.name.nameArabic)
                .font(.custom("DiwanMishafi", size: 38))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(hex: "#ffd89b"), .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .shadow(color: Color(hex: "#ffd89b").opacity(renderingMode == .fullColor ? 0.2 : 0), radius: 8)
                .widgetAccentable()

            // English name
            Text(entry.name.nameEnglish)
                .font(.custom("IBMPlexSansArabic-Medium", size: 11))
                .foregroundColor(Color(hex: "#ffd89b").opacity(readableOpacity(0.5, in: renderingMode)))

            // Translation
            Text(entry.name.translation)
                .font(.custom("IBMPlexSansArabic-Regular", size: 9))
                .foregroundColor(.white.opacity(readableOpacity(0.4, in: renderingMode)))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    let entry: NameEntry
    @Environment(\.widgetRenderingMode) private var renderingMode

    var body: some View {
        HStack(spacing: 0) {
            // Name section (appears on RIGHT in RTL)
            VStack(spacing: 4) {
                Text("اليوم \(entry.dayNumber.arabicDigits) من ٩٩")
                    .font(.custom("IBMPlexSansArabic-Medium", size: 11))
                    .foregroundColor(Color(hex: "#ffd89b").opacity(readableOpacity(0.6, in: renderingMode)))

                Text(entry.name.nameArabic)
                    .font(.custom("DiwanMishafi", size: 44))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(hex: "#ffd89b"), .white],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .shadow(color: Color(hex: "#ffd89b").opacity(renderingMode == .fullColor ? 0.2 : 0), radius: 8)
                    .widgetAccentable()

                Text(entry.name.nameEnglish)
                    .font(.custom("IBMPlexSansArabic-Medium", size: 12))
                    .foregroundColor(Color(hex: "#ffd89b").opacity(readableOpacity(0.5, in: renderingMode)))
            }
            .frame(maxWidth: .infinity)

            // Divider
            Rectangle()
                .fill(Color(hex: "#ffd89b").opacity(renderingMode == .fullColor ? 0.1 : 0.3))
                .frame(width: 1)
                .padding(.vertical, 16)

            // Meaning section (appears on LEFT in RTL)
            VStack(alignment: .leading, spacing: 6) {
                Text("المعنى")
                    .font(.custom("IBMPlexSansArabic-SemiBold", size: 10))
                    .foregroundColor(Color(hex: "#ffd89b").opacity(readableOpacity(0.7, in: renderingMode)))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(entry.name.meaning)
                    .font(.custom("IBMPlexSansArabic-Regular", size: 11))
                    .foregroundColor(.white.opacity(readableOpacity(0.55, in: renderingMode)))
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.trailing, 12)
            .padding(.leading, 4)
        }
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Lock Screen Widget Views

/// Lock Screen, below the clock. The system renders it monochrome (vibrant),
/// so it uses semantic styles instead of the gold palette.
struct RectangularLockScreenView: View {
    let entry: NameEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Solid white everywhere: the Lock Screen already dims content,
            // so any extra transparency makes the text hard to read
            Text("اسم اليوم")
                .font(.custom("IBMPlexSansArabic-Bold", size: 13))
                .foregroundStyle(.white)
                .lineLimit(1)

            // DiwanMishafi ships in a single weight, so size carries the emphasis
            Text(entry.name.nameArabic)
                .font(.custom("DiwanMishafi", size: 36))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .widgetAccentable()

            Text(entry.name.translation)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

/// Lock Screen, single line above the clock. The system draws inline widgets
/// with its own font, so only plain text is used here.
struct InlineLockScreenView: View {
    let entry: NameEntry

    var body: some View {
        Text("اسم اليوم: \(entry.name.nameArabic)")
    }
}

// MARK: - Widget Entry View

struct NamesOfAllahWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .accessoryRectangular:
            RectangularLockScreenView(entry: entry)
        case .accessoryInline:
            InlineLockScreenView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Widget Configuration

struct NamesOfAllahWidget: Widget {
    let kind: String = "NamesOfAllahWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                NamesOfAllahWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        ZStack {
                            Color(hex: "#0a0e27")
                            
                            // Subtle golden glow top-right
                            RadialGradient(
                                colors: [
                                    Color(hex: "#ffd700").opacity(0.06),
                                    Color.clear
                                ],
                                center: .topTrailing,
                                startRadius: 0,
                                endRadius: 120
                            )
                        }
                    }
            } else {
                ZStack {
                    Color(hex: "#0a0e27")
                    
                    RadialGradient(
                        colors: [
                            Color(hex: "#ffd700").opacity(0.06),
                            Color.clear
                        ],
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: 120
                    )

                    NamesOfAllahWidgetEntryView(entry: entry)
                        .padding()
                }
            }
        }
        .configurationDisplayName("اسم اليوم")
        .description("اسم من أسماء الله الحسنى لكل يوم")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    NamesOfAllahWidget()
} timeline: {
    NameEntry(date: .now, name: Name.sample, dayNumber: 1)
}

#Preview(as: .systemMedium) {
    NamesOfAllahWidget()
} timeline: {
    NameEntry(date: .now, name: Name.sample, dayNumber: 1)
}

#Preview(as: .accessoryRectangular) {
    NamesOfAllahWidget()
} timeline: {
    NameEntry(date: .now, name: Name.sample, dayNumber: 1)
}

#Preview(as: .accessoryInline) {
    NamesOfAllahWidget()
} timeline: {
    NameEntry(date: .now, name: Name.sample, dayNumber: 1)
}
