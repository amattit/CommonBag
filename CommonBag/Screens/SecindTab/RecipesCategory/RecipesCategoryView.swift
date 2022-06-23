//
//  RecipesCategoryView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import SwiftUI
import Stinsen

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
                        Image(category.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
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
    @Published var categories: [Category] = Category.allCases
    
    func showCategory(_ category: Category) {
        router?.route(to: \.category, category)
    }
}

enum Category: CaseIterable, Hashable, Identifiable {
    case breakfast, dinner, supper, snack
    
    var id: Int {
        self.hashValue
    }
    
    var image: String {
        switch self {
        case .breakfast:
            return "recipe.breakfast"
        case .dinner:
            return "recipe.dinner"
        case .supper:
            return "recipe.supper"
        case .snack:
            return "recipe.snack"
        }
    }
    
    var title: String {
        switch self {
        case .breakfast:
            return "Завтрак"
        case .dinner:
            return "Обед"
        case .supper:
            return "Ужин"
        case .snack:
            return "Перекус"
        }
    }
}

final class RecipesCategoryCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \RecipesCategoryCoordinator.start)
    
    @Root var start = makeStart
    @Route(.push) var category = makeCategory
    
    @ViewBuilder
    func makeStart() -> some View {
        RecipesCategoryView(viewModel: .init())
    }
    
    func makeCategory(category: Category) -> CategoryListCoordinator {
        CategoryListCoordinator(category: category)
    }
}
