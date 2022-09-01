//
//  CalendarHeaderView.swift
//  SwiftCal
//
//  Created by Kim Insub on 2022/08/31.
//

import SwiftUI

struct CalendarHeaderView: View {
    let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    var font: Font = .body

    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { dayOfWeek in
                Text(dayOfWeek)
                    .font(font  )
                    .fontWeight(.black)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct CalendarHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHeaderView()
    }
}
