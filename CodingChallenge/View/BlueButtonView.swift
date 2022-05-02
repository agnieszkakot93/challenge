//
//  BlueButtonView.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 02/05/2022.
//


import SwiftUI

struct BlueButtonView: View {
    
    var body: some View {
        Button(action: { action }) {
            Text(title)
                .font(.caption2)
                .padding(8.0)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(lineWidth: 2.0)
                    .shadow(color: .blue, radius: 10.0)
            )
        }
    }

    let title: String
    let action: Void
}
