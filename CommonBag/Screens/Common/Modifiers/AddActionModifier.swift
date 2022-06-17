//
//  AddActionModifier.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI

struct AddActionModifier: ViewModifier {
    let action: () -> Void
    func body(content: Content) -> some View {
        Button(action: action) {
            content
        }
        .buttonStyle(.borderless)
    }
}

extension View {
    func addAction(action: @escaping () -> Void) -> some View {
        modifier(AddActionModifier(action: action))
    }
}
