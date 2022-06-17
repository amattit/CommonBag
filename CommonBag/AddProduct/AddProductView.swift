//
//  AddProductView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI

struct AddProductView: View {
    @ObservedObject var viewModel: AddProductViewModel
    var body: some View {
        List {
            Section(header: header) {
                ForEach(viewModel.upcomingProducts) { item in
                    AddedProductRow(model: item)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.plain)
        
    }
    
    var header: some View {
        TextField("Продукт : Количество", text: $viewModel.input) {
            viewModel.handleInput()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            Color.primary.opacity(0.07)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct AddProductView_Preview: PreviewProvider {
    static var previews: some View {
        AddProductView(viewModel: .init(upcomingProducts: [
            .init(id: UUID(), title: "Первый", count: "2"),
            .init(id: UUID(), title: "Второй", count: "")
        ]))
    }
}
