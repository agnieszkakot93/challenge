//
//  ShiftsView.swift
//  CodingChallenge
//
//  Created by Brady Miller on 4/7/21.
//

import SwiftUI

struct ShiftsView: View {
    
    var body: some View {
        VStack {
            Text("Avaliable shift for current week")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if !viewModel.dates.isEmpty {
                        ForEach(viewModel.dates, id: \.self) { date in
                            DateViewCell(date: date)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(lineWidth: 2.0)
                                        .shadow(color: .blue, radius: 10.0)
                                        .foregroundColor(.blue)
                                )
                                .onAppear {
                                    print("scroll \(date)")
                                }
                                .onTapGesture { viewModel.dateSelectedSubject.send(date) }
                        }
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
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        HStack(alignment:.lastTextBaseline) {
                            timeRow(time: rowData.startTime, title: "Shift starts at: ")
                            timeRow(time: rowData.endTime, title: "Shift ends at: ")
                            Spacer()
                            VStack {
                                Button(action: {
                                    viewModel.isModalPresenter.toggle()
                                    viewModel.showSelectedShiftDetails.send(rowData)
                                }) {
                                    Text("Details")
                                        .font(.caption2)
                                        .padding(8.0)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10.0)
                                                .stroke(lineWidth: 2.0)
                                                .shadow(color: .blue, radius: 10.0)
                                        )
                                }
                                .sheet(isPresented: $viewModel.isModalPresenter) {
                                    if let data = viewModel.modalViewData {
                                        ModalView(title: data.title,
                                                  distance: data.distance,
                                                  premiumPay: data.payType,
                                                  time: data.time,
                                                  shiftType: data.shiftType,
                                                  careType: data.careType) {
                                            viewModel.isModalPresenter = false
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }
            }
        } else {
            Text("No shifts avaliable")
        }
    }
    
    private func timeRow(time: String, title: String) -> some View {
        VStack {
            Text(title)
            Text(time)
                .foregroundColor(.blue)
                .fontWeight(.bold)
        }
        .font(.caption)
    }
    
    private var modalView: some View {
        VStack {
            Text("Close X")
                .font(.caption2)
                .padding(8.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(lineWidth: 2.0)
                        .shadow(color: .blue, radius: 10.0)
                )
                .onTapGesture { viewModel.isModalPresenter.toggle() }
        }
    }
    
    @ObservedObject var viewModel: CodingChallengeViewModel
}

struct ShiftsView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftsView(viewModel: CodingChallengeViewModel())
    }
}
