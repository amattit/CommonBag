//
//  ProductSuggestView.swift
//  CommonBag
//
//  Created by MikhailSeregin on 22.06.2022.
//

// TODO: подумать, как лучше сделать
import SwiftUI

struct ProductSuggestView: View {
    @ObservedObject var viewModel: SuggestViewModel
    
    
    var body: some View {
        List {
            TextField("товар или категория", text: $viewModel.search)
            Button(action: viewModel.check) {
                Text("Проверить")
            }
            ForEach(viewModel.visible) { model in
                SuggestRow(model: model, selected: $viewModel.selected)
            }
        }
        .listStyle(.plain)
    }
}

struct SuggestRow: View {
//    let model: DTO.SuggestRs
    @State var model: DTO.SuggestRs
    @Binding var selected: [DTO.SuggestRs]
    @State var isAdded = false
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .frame(width: 3)
                    .foregroundColor(color)
                Text(model.title)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                Spacer()
                countView
                
            }
            if isAdded {
                HStack {
                    ForEach(DTO.SuggestRs.MesureUnit.allCases) { mu in
                        Button(action: {
                            model.mesureUnit = mu
                        }) {
                            Text(mu.title)
                                .padding(.horizontal)
                        }
                        .accentColor(model.mesureUnit == mu ? .white : .primary)
                        .background(
                            model.mesureUnit == mu ? Color.blue : .clear
                        )
                        .buttonStyle(.borderless)
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var countView: some View {
        if isAdded == false {
            Button(action: {
                increment()
                isAdded = true
            }) {
                Text("Добавить")
            }
        } else {
            Text(count)
            Stepper("", onIncrement: increment, onDecrement: decrement)
                .labelsHidden()
        }
    }
    
    var count: String {
        if let value = model.count?.description {
            if value.contains(".0") {
                return Int(model.count ?? 0).description
            } else {
                return value.description
            }
        }
        return model.count?.description ?? "0"
    }
    
    func increment() {
        guard model.count != nil else {
            model.count = 1
            addToSelected()
            return
        }
        model.count? += 0.5
        addToSelected()
    }
    
    func decrement() {
        if var count = model.count, count.rounded() > 0 {
            count -= 0.5
            model.count = count
            if count.rounded() == 0 {
                model.count = nil
                isAdded = false
                removeFromSelected()
            } else {
                addToSelected()
            }
        } else {
            model.count = nil
            isAdded = false
            removeFromSelected()
        }
    }
    
    func removeFromSelected() {
        self.selected.removeAll { item in
            item.id == model.id
        }
    }
    
    func addToSelected() {
        selected.removeAll { $0.id == model.id }
        selected.append(model)
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
