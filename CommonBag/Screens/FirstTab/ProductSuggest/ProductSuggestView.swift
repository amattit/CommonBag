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
        NavigationView {
            List {
                ForEach(viewModel.selected) { model in
                    SuggestRow(model: model, selected: $viewModel.selected)
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.search, prompt: Text("например, бакалея"), suggestions: {
                if viewModel.visible.isEmpty {
                    VStack {
                        Text("Ничего не нашлось :(")
                        Text("Чтобы добавить нажмите \"Найти\" на клавиатуре")
                    }
                } else {
                    ForEach(viewModel.visible) { model in
                        SearchProductSuggestRow(model: model, selected: $viewModel.selected)
                    }
                }
            })
            .onSubmit(of: .search) {
//                print("****************")
                self.viewModel.selected.append(DTO.SuggestRs(id: .init(), title: viewModel.search, category: "secondary", color: "white", count: 1))
            }
            .navigationTitle(Text("Список"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово", action: viewModel.save)
                }
            }
        }
    }
}

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
        selected.removeAll { $0.id == model.id }
        selected.append(model)
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

struct SuggestRow: View {
    @State var model: DTO.SuggestRs
    @Binding var selected: [DTO.SuggestRs]
    
    init(model: DTO.SuggestRs, selected: Binding<[DTO.SuggestRs]>) {
        if let model = selected.first(where: {
            $0.wrappedValue.id == model.id
        }) {
            self._model = State(initialValue: model.wrappedValue)
        } else {
            self._model = State(initialValue: model)
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
                    countView
                    
                }
                if isSelected {
                    HStack {
                        ForEach(DTO.SuggestRs.MesureUnit.allCases) { mu in
                            Button(action: {
                                if model.mesureUnit != mu {
                                    model.mesureUnit = mu
                                } else {
                                    model.mesureUnit = nil
                                }
                                addToSelected()
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
    }
    
    var isSelected: Bool {
        selected.contains {
            $0.id == model.id
        }
    }
    
    @ViewBuilder
    var countView: some View {
        if isSelected == false {
            Button(action: {
                increment()
            }) {
                Text("Добавить")
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.primary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .accentColor(.primary)
            .buttonStyle(.borderless)
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
                removeFromSelected()
            } else {
                addToSelected()
            }
        } else {
            model.count = nil
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
