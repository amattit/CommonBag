//
//  SearchProductSuggestRow.swift
//  CommonBag
//
//  Created by MikhailSeregin on 05.08.2022.
//

import SwiftUI

struct SearchProductSuggestRow: View {
    let model: DTO.SuggestRs
    @Binding var selected: [DTO.SuggestRs]
    
    init(model: DTO.SuggestRs, selected: Binding<[DTO.SuggestRs]>) {
        if let model = selected.first(where: {
            $0.wrappedValue.id == model.id
        }) {
            self.model = model.wrappedValue
        } else {
            self.model = model
        }
        self._selected = selected
    }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .frame(width: 3)
                .foregroundColor(color)
            VStack {
                HStack {
                    Text(model.title)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    Spacer()
                    Button(action: {
                        isSelected ? removeFromSelected() : addToSelected()
                    }) {
                        Text(isSelected ? "Удалить" : "Добавить")
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.primary.opacity(isSelected ? 0.3 : 0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .accentColor(.primary)
                    .buttonStyle(.borderless)
                }
            }
        }
    }
    
    var isSelected: Bool {
        selected.contains {
            $0.id == model.id
        }
    }
    
    func addToSelected() {
        var newModel = model
        newModel.count = 1
        selected.append(newModel)
    }
    
    func removeFromSelected() {
        selected.removeAll { $0.id == model.id }
    }
    
    var color: Color {
        switch model.color {
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "orange":
            return .orange
        default:
            return .secondary
        }
    }
}
