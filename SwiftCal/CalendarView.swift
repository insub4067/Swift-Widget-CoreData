//
//  ContentView.swift
//  SwiftCal
//
//  Created by Kim Insub on 2022/08/25.
//

import SwiftUI
import CoreData
import WidgetKit

struct CalendarView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", Date().startOfCalendarWithPrefixDays as CVarArg, Date().endOfMonth as CVarArg))
    
    private var days: FetchedResults<Day>

    var body: some View {
        NavigationView {
            VStack {
                CalendarHeaderView()

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days) { day in
                        if day.date!.monthInt != Date().monthInt {
                            Text("")
                        } else {

                            Button {
                                day.didStudy.toggle()
                                do {
                                    try viewContext.save()
                                    WidgetCenter.shared.reloadTimelines(ofKind: "SwiftCalWidget")
                                    print("✅ \(day.date!.dayInt) now studied")
                                } catch {
                                    print("❌ Failed To Save Context")
                                }
                            } label: {
                                Text("\(day.date!.dayInt)")
                                    .fontWeight(.bold)
                                    .foregroundColor(day.didStudy ? .orange : .secondary)
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .background(
                                        Circle()
                                            .foregroundColor(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                                    )
                            }
                        }
                    }
                }
                Spacer()
            }
//            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .navigationTitle("\(Date().monthInt)월")
            .padding()
            .onAppear{
                if days.isEmpty {
                    createMonthDays(for: .now.startOfPreviousMonth)
                    createMonthDays(for: .now)
                } else if days.count < 10 {
                    createMonthDays(for: .now)
                }
            }
            .onChange(of: scenePhase){
                newPhase in
                if newPhase == .background {
                    WidgetCenter.shared.reloadTimelines(ofKind: "SwiftCalWidget")
                }
            }
        }
    }

    func createMonthDays(for date: Date) {
        for dayOffSet in 0..<date.numberOfDaysInMonth {
            let newDay = Day(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dayOffSet, to: date.startOfMonth)
            newDay.didStudy = false
        }
        do {
            try viewContext.save()
            print("✅ \(date.monthFullName) days created")
        } catch {
            print("❌ Failed To Save Context")
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
