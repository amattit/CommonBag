//
//  RecipeView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 23.06.2022.
//

import Foundation
import SwiftUI
import Stinsen

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                ZStack(alignment: .topLeading) {
                    Image(viewModel.category.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                ForEach([0,1,2,3], id: \.self) { index in
                    UpcomingProductRowView(model: .init(id: UUID(), title: "Product \(index)", count: "\(index) шт"))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
            
            Button("Додавить в список покупок") {
                print("todo")
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
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
}

final class RecipeCoordinator: NavigationCoordinatable {
    var stack = NavigationStack(initial: \RecipeCoordinator.start)
    
    @Root var start = makeStart
    
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    @ViewBuilder func makeStart() -> some View {
        RecipeView(viewModel: .init(category: category))
    }
}

