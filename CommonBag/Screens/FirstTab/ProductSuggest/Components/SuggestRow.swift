//
//  SuggestRow.swift
//  CommonBag
//
//  Created by MikhailSeregin on 05.08.2022.
//

import SwiftUI

struct SuggestRow: View {
    @Binding var model: DTO.SuggestRs
    
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
                
                HStack {
                    ForEach(DTO.SuggestRs.MesureUnit.allCases) { mu in
                        Button(action: {
                            if model.mesureUnit != mu {
                                model.mesureUnit = mu
                            } else {
                                model.mesureUnit = nil
                            }
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
        Text(count)
        Stepper("", onIncrement: increment, onDecrement: decrement)
            .labelsHidden()
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
            return
        }
        model.count? += 0.5
    }
    
    func decrement() {
        if var count = model.count, count.rounded() > 0 {
            count -= 0.5
            model.count = count
            if count.rounded() == 0 {
                model.count = nil
            } else {
            }
        } else {
            model.count = nil
        }
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
