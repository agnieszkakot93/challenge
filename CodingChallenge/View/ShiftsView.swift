//
//  ShiftsView.swift
//  CodingChallenge
//
//  Created by Brady Miller on 4/7/21.
//

import SwiftUI

struct ShiftsView: View {
    @State private var isExpanded: Bool = false
    @State var isPresented: Bool = false // Creating a state

    var body: some View {
        VStack {
            Text("Avaliable shift for current week")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.dates, id: \.self) { date in
                        DayView(date: date)
                            .onAppear {
                                print("scroll \(date)")
                            }
                            .onTapGesture { viewModel.dateSelectedSubject.send(date) }
                    }
                }
            }
            shiftRowView
            Spacer()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    @ViewBuilder private var shiftRowView: some View {
        if let selectedDateShifts = viewModel.selectedDateShifts?.shiftList {
            List {
                ForEach(selectedDateShifts) { rowData in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rowData.title)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .center)
                        HStack {
                            VStack {
                                Button(action: { self.isPresented.toggle() }) {
                                           Text("Show Details")
                                       }.sheet(isPresented: $isPresented) {
                                           Text("Close X")
                                               .onTapGesture { self.isPresented.toggle() }
                                       }
                            }
                            .padding(.trailing, 8)
                            .overlay(
                                Rectangle().fill(.blue).frame(width: 1),
                                alignment: .trailing
                            )
                            timeRow(time: rowData.startTime, title: "Shift starts at: ")
                            timeRow(time: rowData.endTime, title: "Shift ends at: ")
                        }
                    }
                }
            }
        } else {
            Text("No shifts for \(viewModel.dateSelectedSubject.value)")
        }
    }

    private func timeRow(time: String, title: String) -> some View {
        VStack {
            Text(title)
            Text(time)
        }
        .font(.caption)
    }

    @ObservedObject var viewModel: CodingChallengeViewModel
}

struct ShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftsView(viewModel: CodingChallengeViewModel())
    }
}
