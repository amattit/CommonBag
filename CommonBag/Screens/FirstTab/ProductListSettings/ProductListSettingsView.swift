//
//  ProductListSettingsView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 08.07.2022.
//

import Foundation
import SwiftUI

struct ProductListSettingsView: View {
    @ObservedObject var viewModel: ProductListSettingsViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                titleView
                shareLinkView
                usersView
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Настройки")
    }
}

// Название списка покупок
extension ProductListSettingsView {
    var titleView: some View {
        TextField("Введите название", text: $viewModel.title) {
            viewModel.remane()
        }
        .textFieldStyle(.roundedBorder)
        .font(.title)
    }
}

// Список пользователей
extension ProductListSettingsView {
    @ViewBuilder
    var usersView: some View {
        if viewModel.list.isShared ?? false {
            VStack(alignment: .leading) {
                Text("Пользоватли")
                    .font(.title2)
                ForEach(viewModel.users) { user in
                    HStack {
                        Text(user.username ?? "N/A")
                        Spacer()
                        if !isMe(user: user) {
                            Button(action: {viewModel.deleteUser(user: user)}) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func isMe(user: DTO.Profile) -> Bool {
        viewModel.userService?.user == user
    }
}

// Токен для шаринга
extension ProductListSettingsView {
    @ViewBuilder
    var shareLinkView: some View {
        if viewModel.shareToken.isEmpty {
            Button(action: viewModel.createShareToken) {
                Text("Создать общую ссылку")
            }
        } else {
            HStack {
                Text(viewModel.shareToken)
                Button(action: {
                    // todo copy link
                }) {
                    Image(systemName: "square.dashed")
                }
            }
            .padding(4)
            .background(
                Color.secondary.opacity(0.2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

