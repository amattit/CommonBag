//
//  AddedProductRow.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI

struct AddedProductRow: View {
    let model: ProductModel
    
    var body: some View {
        HStack {
            Text(model.title)
            Spacer()
            Text(model.count)
        }
        .foregroundColor(.secondary)
    }
}
