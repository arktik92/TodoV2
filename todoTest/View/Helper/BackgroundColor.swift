//
//  BackgroundColor.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 19/01/2023.
//

import SwiftUI

struct BackgroundColor: View {
    var body: some View {
        LinearGradient(colors: [Color("Todo blue"), Color("BgColor")], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

