//
//  RenameView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import SwiftUI
import Foundation
import Stinsen
import Combine

struct RenameView: View {
    @ObservedObject var viewModel: RenameViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            viewModel.subTitle.map {
                Text($0)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            TextField("Введите", text: $viewModel.newName)
                .textFieldStyle(.roundedBorder)
                .padding(.top)
            Spacer()
        }
        .modifier(ViewStateModifier(state: $viewModel.viewState))
        .padding(.horizontal)
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Готово") {
                    viewModel.apply()
                }
            }
        }
    }
}

struct RenameView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RenameView(viewModel: .init(uid: nil, currentName: "Жопа бобра", title: "Новое имя", subTitle: "чтобы проще ориентироваться в списках продуктов", renameService: BaseRenameService(networkClient: NetworkClient()), completion: {}))
        }
    }
}


final class RenameViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<RenameCoordinator>?
    @Published var newName = ""
    @Published var viewState: ViewState = .loaded

    let title: String
    let subTitle: String?
    let uid: UUID?
    let renameService: RenameServiceProtocol?
    var disposables = Set<AnyCancellable>()
    let completion: (() -> Void)?
    
    internal init(
        uid: UUID?,
        currentName: String,
        title: String,
        subTitle: String?,
        renameService: RenameServiceProtocol?,
        completion: (() -> Void)?
    ) {
        self.uid = uid
        self.title = title
        self.subTitle = subTitle
        self.renameService = renameService
        self.completion = completion
        self.newName = currentName
    }
    
    func apply() {
        self.viewState = .loading
        renameService?
            .setUid(uid)
            .setTitle(newName)
            .rename()
            .sink { completion in
                if case let .failure(error) = completion {
                    self.viewState = .error(ErrorModel(error: error, action: self.apply))
                }
            } receiveValue: { success in
                if success {
                    NotificationCenter.default.post(name: .reloadLists, object: nil)
                    self.router?.dismissCoordinator(self.completion)
                }
            }
            .store(in: &disposables)

    }
}

final class RenameCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \RenameCoordinator.start)
    @Root var start = makeStart
    let uid: UUID?
    let currentName: String
    let title: String
    let subTitle: String?
    let completion: (() -> Void)?
    let renameService: RenameServiceProtocol?
    
    init(
        currentName: String,
        title: String,
        subTitle: String?,
        uid: UUID?,
        renameService: RenameServiceProtocol?,
        completion: (() -> Void)?
    ) {
        self.uid = uid
        self.title = title
        self.subTitle = subTitle
        self.completion = completion
        self.currentName = currentName
        self.renameService = renameService
    }
    
    @ViewBuilder
    func makeStart() -> some View {
        RenameView(viewModel: .init(uid: uid, currentName: currentName, title: title, subTitle: subTitle, renameService: renameService, completion: completion))
    }
}
