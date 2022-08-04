//
//  RecipeView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import SwiftUI
import Stinsen
import Combine

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: URL(string: viewModel.recipe.imagePath ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .redacted(reason: .placeholder)
                    }
                }
                Text(viewModel.recipe.steps ?? "")
                    .font(.caption)
                    .padding()
                ForEach(viewModel.recipe.products ?? [], id: \.self) { product in
                    UpcomingProductRowView(model: .init(id: product.id, title: product.title, count: product.count ?? "", color: ""))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .padding(.bottom, product == viewModel.recipe.products?.last ? 100 : 0)
                }
            }
            
            Button("Додавить в список покупок") {
                viewModel.addToList()
            }
            .padding()
            .foregroundColor(.white)
            .background(
                Color.accentColor
            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.bottom)
        }
        .navigationTitle(viewModel.category.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

final class RecipeViewModel: ObservableObject {
    @RouterObject var router: NavigationRouter<RecipeCoordinator>?
    let category: DTO.CategoryRs
    @Published var recipe: DTO.RecipeRs
    let networking: NetworkClientProtocol?
    
    private var disposables = Set<AnyCancellable>()
    
    init(category: DTO.CategoryRs, recipe: DTO.RecipeRs, networking: NetworkClientProtocol?) {
        self.recipe = recipe
        self.networking = networking
        self.category = category
        load()
    }

    private func load() {
        networking?
            .execute(
                api: API.Recipes.getRecipe(recipe.id),
                type: DTO.RecipeRs.self
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                self.recipe = response
            }
            .store(in: &disposables)
    }
    
    func addToList() {
        router?.route(to: \.list, recipe.products ?? [])
    }
}

final class RecipeCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \RecipeCoordinator.start)
    
    @Root var start = makeStart
    @Route(.push) var list = makeSelectList
    
    let category: DTO.CategoryRs
    
    let serviceLocator: ServiceLocatorProtocol
    
    let recipe: DTO.RecipeRs
    
    init(category: DTO.CategoryRs, recipe: DTO.RecipeRs, serviceLocator: ServiceLocatorProtocol) {
        self.recipe = recipe
        self.serviceLocator = serviceLocator
        self.category = category
    }
    
    @ViewBuilder func makeStart() -> some View {
        RecipeView(viewModel: .init(category: category, recipe: recipe, networking: serviceLocator.getService()))
    }
    
    @ViewBuilder func makeSelectList(products: [DTO.RecipeProductRs]) -> some View {
        SelectListView(
            viewModel: .init(products: products, networking: serviceLocator.getService())
        )
    }
}

