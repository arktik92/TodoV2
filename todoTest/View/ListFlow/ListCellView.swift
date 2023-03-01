//
//  ListCellView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 28/02/2023.
//

import SwiftUI

struct ListCellView: View {
    var item: Item
    var dateAndTimeFormatter = DateAndTimeFormater()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    HStack {
                        Text("Echéance : ")
                            .fontWeight(.bold)
                        Text(dateAndTimeFormatter.dateFormatter(item: item))
                    }
                    Text(dateAndTimeFormatter.hourFormatter(item: item))
                }
                .font(.caption)
                .fontWeight(.semibold)
            }
            .padding(.bottom)
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title ?? "No title")
                        .fontWeight(.semibold)
                    Divider()
                    Text(item.plot ?? "No Description")
                        .lineLimit(3)
                }
                Spacer()
            }
            
        }.foregroundColor(.black)
    }   
}
