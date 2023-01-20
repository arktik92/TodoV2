//
//  BackgroundColor.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 19/01/2023.
//

import SwiftUI

struct BackgroundColor: View {
    var body: some View {
        //        LinearGradient(colors: [Color(red: Double.random(in: 0...0.5), green: Double.random(in: 0...0.5), blue: Double.random(in: 0...0.5)),Color(red: Double.random(in: 0.5...1), green: Double.random(in: 0.5...1), blue: Double.random(in: 0.5...1))], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
        LinearGradient(colors: [Color("Todo blue"), Color("BgColor")], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
    }
    
}
struct BackgroundColor_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundColor()
    }
}
