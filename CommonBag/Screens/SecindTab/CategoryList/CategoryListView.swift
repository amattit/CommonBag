//
//  CategoryListView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import SwiftUI
import Stinsen

struct CategoryListView: View {
    @ObservedObject var viewModel: CategoryListViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                .init(.adaptive(minimum: 200, maximum: 600), spacing: 3, alignment: .top),
                .init(.adaptive(minimum: 200, maximum: 600), spacing: 3, alignment: .top),
            ]) {
                ForEach([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17], id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                        Image(viewModel.category.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        Text(viewModel.category.title)
                            .bold()
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary.opacity(0.7))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .addAction {
                        viewModel.showRecipe()
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
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    func showRecipe() {
        router?.route(to: \.recipe)
    }
}

final class CategoryListCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \CategoryListCoordinator.start)
    
    @Root var start = makeStart
    @Route(.modal) var recipe = makeRecipe
    
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    @ViewBuilder func makeStart() -> some View {
        CategoryListView(viewModel: .init(category: category))
    }
    
    func makeRecipe() -> NavigationViewCoordinator<RecipeCoordinator> {
        NavigationViewCoordinator(RecipeCoordinator(category: category))
    }
}
