//
//  ErrorModel.swift
//  CommonBag
//
//  Created by MikhailSeregin on 01.07.2022.
//

import Foundation
import SwiftUI

struct ErrorModel {
    let error: Error
    let action: () -> Void
}

enum Loadable {
    case idle
    case loading
    case loaded
    case error(ErrorModel)
}

struct StateModifier: ViewModifier {
    @Binding var state: Loadable
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch state {
        case .idle:
            EmptyView()
        case .loading:
            ProgressView()
        case .loaded:
            content
        case .error(let errorModel):
            VStack {
                Text("Ошибка!")
                    .bold()
                Text(errorModel.error.localizedDescription)
                Button("Повторить") {
                    errorModel.action()
                }
            }
        }
    }
}

struct ErrorModifier: ViewModifier {
    let error: ErrorModel
    
    func body(content: Content) -> some View {
        VStack {
            Text("Ошибка!")
                .bold()
            Text(error.error.localizedDescription)
            Button("Повторить") {
                error.action()
            }
        }
    }
}
