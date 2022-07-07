//
//  CategoryListView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import SwiftUI
import Stinsen
import Combine

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryListViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                .init(.adaptive(minimum: 200, maximum: 600), spacing: 3, alignment: .top),
                .init(.adaptive(minimum: 200, maximum: 600), spacing: 3, alignment: .top),
            ]) {
                ForEach(viewModel.recipes, id: \.self) { recipe in
                    ZStack(alignment: .topLeading) {
                        AsyncImage(url: URL(string: recipe.imagePath ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .redacted(reason: .placeholder)
                        }
                        Text(recipe.title)
                            .bold()
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary.opacity(0.7))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .addAction {
                        viewModel.showRecipe(recipe: recipe)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(viewModel.category.title)
    }
}

final class CategoryListViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<CategoryListCoordinator>?
    @Published var recipes: [DTO.RecipeRs] = []
    let category: DTO.CategoryRs
    
    let networking: NetworkClientProtocol?
    
    private var disposables = Set<AnyCancellable>()
    
    init(category: DTO.CategoryRs, networking: NetworkClientProtocol?) {
        self.networking = networking
        self.category = category
        load()
    }

    private func load() {
        networking?
            .execute(
                api: API.Recipes.getRecipeInCategory(category.id),
                type: [DTO.RecipeRs].self
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.recipes = response
            }
            .store(in: &disposables)

    }
    
    func showRecipe(recipe: DTO.RecipeRs) {
        router?.route(to: \.recipe, recipe)
    }
}

final class CategoryListCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \CategoryListCoordinator.start)
    
    @Root var start = makeStart
    @Route(.modal) var recipe = makeRecipe
    
    let category: DTO.CategoryRs
    
    let serviceLocator: ServiceLocatorProtocol
    
    init(category: DTO.CategoryRs, serviceLocator: ServiceLocatorProtocol) {
        self.serviceLocator = serviceLocator
        self.category = category
    }
    
    @ViewBuilder func makeStart() -> some View {
        CategoryListView(viewModel: .init(category: category, networking: serviceLocator.getService()))
    }
    
    func makeRecipe(recipe: DTO.RecipeRs) -> NavigationViewCoordinator<RecipeCoordinator> {
        NavigationViewCoordinator(RecipeCoordinator(category: category, recipe:  recipe, serviceLocator: serviceLocator))
    }
}
