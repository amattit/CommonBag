//
//  RecipesCategoryView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import SwiftUI
import Stinsen
import Combine

struct RecipesCategoryView: View {
    @ObservedObject var viewModel: RecipesCategoryViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                .init(.adaptive(minimum: 200, maximum: 600), spacing: 3, alignment: .top),
                .init(.adaptive(minimum: 200, maximum: 600), spacing: 3, alignment: .top),
            ]) {
                ForEach(viewModel.categories) { category in
                    ZStack(alignment: .topLeading) {
//                        AsyncImage(url: URL(string: category.imagePath))
                        AsyncImage(url: URL(string: category.imagePath)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .redacted(reason: .placeholder)
                        }

                        Text(category.title)
                            .bold()
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary.opacity(0.7))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .addAction {
                        viewModel.showCategory(category)
                    }
                }
            }
            .padding(.horizontal)
            Text("Раздел находится в разработке!")
                .font(.title)
                .foregroundColor(.secondary)
        }
        .navigationTitle("Рецепты")
    }
}

final class RecipesCategoryViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<RecipesCategoryCoordinator>?
    @Published var categories: [DTO.CategoryRs] = []
    
    let networking: NetworkClientProtocol?
    
    var disposables = Set<AnyCancellable>()
    
    init(networking: NetworkClientProtocol?) {
        self.networking = networking
        load()
    }
    
    private func load() {
        networking?
            .execute(api: API.Recipes.getCategories, type: [DTO.CategoryRs].self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.categories = response
            }
            .store(in: &disposables)

    }
    
    func showCategory(_ category: DTO.CategoryRs) {
        router?.route(to: \.category, category)
    }
}

final class RecipesCategoryCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \RecipesCategoryCoordinator.start)
    
    @Root var start = makeStart
    @Route(.push) var category = makeCategory
    
    let serviceLocator: ServiceLocatorProtocol
    
    init(serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
    }
    
    @ViewBuilder
    func makeStart() -> some View {
        RecipesCategoryView(viewModel: .init(networking: serviceLocator.getService()))
    }
    
    func makeCategory(category: DTO.CategoryRs) -> CategoryListCoordinator {
        CategoryListCoordinator(category: category, serviceLocator: serviceLocator)
    }
}
