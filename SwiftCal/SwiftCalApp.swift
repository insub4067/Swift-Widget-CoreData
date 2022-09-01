//
//  SwiftCalApp.swift
//  SwiftCal
//
//  Created by Kim Insub on 2022/08/25.
//

import SwiftUI

@main
struct SwiftCalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabView {
                CalendarView()
                    .tabItem{ Label("Calendar", systemImage: "calendar") }
                StreakView()
                    .tabItem{ Label("Streak", systemImage: "swift") }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
