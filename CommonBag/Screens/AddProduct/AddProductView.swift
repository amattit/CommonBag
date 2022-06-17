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
        ZStack(alignment: .bottom) {
            List {
                Section(header: header) {
                    ForEach(viewModel.upcomingProducts) { item in
                        AddedProductRow(model: item)
                            .listRowSeparator(.hidden)
                            .padding(.bottom, item == viewModel.upcomingProducts.last ? 50 : nil)
                    }
                }
            }
            .listStyle(.plain)
            HStack {
                Text(" : количество")
                    .addAction(action: viewModel.addCountDivider)
                Spacer()
                Text("Готово")
                    .addAction(action: viewModel.dismiss)
            }
            .font(.headline)
            .padding()
            .background(
                Color.primary.opacity(0.06)
            )
        }
        
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
        AddProductView(viewModel: .init(service: .init(), list: .mock, upcomingProducts: []))
    }
}
