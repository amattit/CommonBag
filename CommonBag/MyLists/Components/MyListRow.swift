//
//  MyListRow.swift
//  CommonBag
//
//  Created by MikhailSeregin on 17.06.2022.
//

import SwiftUI

struct MyListRow: View {
    let item: ListModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.body)
                .bold()
            Text(item.description)
                .font(.footnote)
                .lineLimit(2)
        }
    }
}
