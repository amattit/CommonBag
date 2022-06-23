//
//  UserProfileView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import SwiftUI
import Foundation
import Stinsen
import Combine

struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    var body: some View {
        ScrollView {
            Button("setUsername", action: viewModel.setUsername)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                TextField("set username here", text: $viewModel.username, onEditingChanged: { active in
                    if !active {
                        viewModel.setUsername()
                    }
                })
                    .font(.largeTitle)
            }
        }
    }
}

final class UserProfileViewModel: ObservableObject {
    @Published var username = ""
    let networking: NetworkClientProtocol
    var disposables = Set<AnyCancellable>()
    init(networking: NetworkClientProtocol) {
        self.networking = networking
        load()
    }
    
    func load() {
        networking
            .execute(api: API.User.me, type: DTO.Profile.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.username = response.username ?? ""
            }
            .store(in: &disposables)
    }
    
    func setUsername() {
        networking
            .execute(api: API.User.setUsername(username), type: DTO.Profile.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.username = response.username ?? ""
            }
            .store(in: &disposables)
    }
}

final class UserProfileCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \UserProfileCoordinator.start)
    
    @Root var start = makeStart
    
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    @ViewBuilder
    func makeStart() -> some View {
        UserProfileView(viewModel: .init(networking: networkClient))
    }
}
