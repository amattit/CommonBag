//
//  ProductRow.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI

struct UpcomingProductRowView: View {
    let model: ProductModel
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous).fill(color)
                .frame(width: 4)
            Text(model.title)
            Spacer()
            Text(model.count)
                .foregroundColor(.secondary)
        }
        .foregroundColor(.primary)
        .padding(.trailing)
    }
    
    var color: Color {
        switch model.color {
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "orange":
            return .orange
        default:
            return .secondary
        }
    }
}

struct MadeProductRowView: View {
    let model: ProductModel
    
    var body: some View {
        HStack {
            Text(model.title)
            Spacer()
            Text(model.count)
                .foregroundColor(.secondary)
        }
        .foregroundColor(.secondary)
    }
}
