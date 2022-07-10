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
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово", action: viewModel.remane)
                    .disabled(viewModel.doneButtonDisabled())
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Настройки")
    }
}

// Название списка покупок
extension ProductListSettingsView {
    var titleView: some View {
        TextField("Введите название", text: $viewModel.title)
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
                        if !isMe(user: user) && (viewModel.list.isOwn ?? false) {
                            Button(action: {viewModel.deleteUser(user: user)}) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .modifier(ViewStateModifier(state: $viewModel.viewState))
        } else if !viewModel.shareToken.isEmpty {
            Text("Когда, кто-то подключится к списку здесь будет отображаться все участники, которые могут работать с вашим списком покупок")
                .foregroundColor(.secondary)
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
                Text("Создать общую ссылку на список продуктов")
                    .multilineTextAlignment(.leading)
            }
        } else {
            VStack(alignment: .leading, spacing: 8) {
                Text("Скопируйте ссылку и отправьте ее своей второй половинке или друзьям")
                    .font(.callout)
                ForEach(viewModel.shareToken, id: \.self) { token in
                    VStack {
                        HStack {
                            Text(token)
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Button(action: {
                                viewModel.copy(url: token)
                            }) {
                                Image(systemName: "square.dashed.inset.filled")
                            }
                        }

                        HStack {
                            Button(action: { viewModel.share(token: token) }) {
                                HStack {
                                    Spacer()
                                    Text("Поделиться")
                                    Spacer()
                                }
                            }
                            .padding(8)
                            .background(
                                Color.accentColor//.opacity(0.2)
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                            if viewModel.list.isOwn ?? false {
                                Button(action: viewModel.deleteShareToken) {
                                    Image(systemName: "trash")
                                }
                                .padding(8)
                                .accentColor(.red)
                                .background(
                                    Color.secondary.opacity(0.2)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding()
                    .background(
                        Color.secondary.opacity(0.2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
            .modifier(ViewStateModifier(state: $viewModel.viewState))
        }
    }
}

