//
//  ModalView.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 02/05/2022.
//

import Foundation
import SwiftUI

struct ModalView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack {
                Text("Details")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
                Text("Close X")
                    .font(.caption2)
                    .padding(8.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                    )
                    .onTapGesture {
                        if let dismiss = dismissModal {
                            dismiss()
                        }
                    }
            }
            .padding()
            Text(title)
                .fontWeight(.bold)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding()

            List {
                createRow(text: distance, iconName: "triangle.fill")
                createRow(text: time, iconName: "clock.arrow.circlepath")
                createRow(text: premiumPay, iconName: "dollarsign.circle.fill")
                createRow(text: shiftType, iconName: "clock.arrow.circlepath")
                createRow(text: careType, iconName: "cross.circle")
            }
            .listStyle(.grouped)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }

    private func createRow(text: String, iconName: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .padding(.trailing, 24)
            Text(text)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

    let title: String
    let distance: String
    let premiumPay: String
    let time: String
    let shiftType: String
    let careType: String
    let dismissModal: (() -> Void)?

    init(title: String,
         distance: String,
         premiumPay: String,
         time: String,
         shiftType: String,
         careType: String,
    dismissModal: (() -> Void)? = nil) {
        self.title = title
        self.distance = distance
        self.premiumPay = premiumPay
        self.time = time
        self.shiftType = shiftType
        self.careType = careType
        self.dismissModal = dismissModal
        UITableView.appearance().backgroundColor = .clear
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(title: "Nurse",
                  distance: "Distance within 10ml",
                  premiumPay: "premium pay",
                  time: "30 min",
                  shiftType: "24h",
                  careType: "Care Type",
                  dismissModal: nil)
    }
}
