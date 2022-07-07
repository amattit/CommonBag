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
            HStack {
                Text(item.title)
                    .font(.body)
                    .bold()
                Spacer()
                if !isOwn {
                    Text(profile)
                        .font(.footnote)
                        .padding(3)
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                }
                if isShared {
                    Image(systemName: "person.2")
                        .frame(width: 14, height: 14)
                }
            }
            Text(item.description)
                .font(.footnote)
                .lineLimit(2)
        }
    }
    
    private var isShared: Bool {
        item.isShared ?? false
    }
    
    private var profile: String {
        if let profile = item.profile,
            let username = profile.username,
            let acronym = username.first?.description {
            if acronym.isEmpty {
                return "N/A"
            } else {
                return acronym
            }
        } else {
            return "N/A"
        }
    }
    
    private var isOwn: Bool {
        item.isOwn ?? false
    }
}
