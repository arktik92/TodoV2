//
//  SegmentedPickerTodoOrDone.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 19/01/2023.
//

import SwiftUI

struct SegmentedPickerTodoOrDone: View {
    @Binding var pickerSelection: TypePickerSelection
    var body: some View {
        Picker("", selection: $pickerSelection) {
            ForEach(TypePickerSelection.allCases, id: \.self) { value in
                Text(value.rawValue)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

struct SegmentedPickerTodoOrDone_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerTodoOrDone(pickerSelection: .constant(.todo))
    }
}
