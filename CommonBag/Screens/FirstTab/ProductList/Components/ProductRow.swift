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
            Text(model.title)
            Spacer()
            Text(model.count)
                .foregroundColor(.secondary)
        }
        .foregroundColor(.primary)
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
