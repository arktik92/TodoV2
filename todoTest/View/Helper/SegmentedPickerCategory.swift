//
//  SegmentedPickerTodoOrDone.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 19/01/2023.
//

import SwiftUI
import Introspect

struct SegmentedPickerCategory: View {
    @Binding var CategorypickerSelection: CategoryPickerSelection
    
    var body: some View {
        Picker("", selection: $CategorypickerSelection) {
            ForEach(CategoryPickerSelection.allCases, id: \.self) { value in
                Text(value.rawValue.capitalized)
            }
        }
        .introspectSegmentedControl { segmentedControl in
            segmentedControl.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0, alpha: 0.5)
            segmentedControl.selectedSegmentTintColor = UIColor(red: 1, green: 0.992, blue: 0.082, alpha: 1)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(.black)], for: .selected)
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor(red: 1, green: 0.749, blue: 0, alpha: 1)], for: .normal)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

struct SegmentedPickerCategory_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedPickerCategory(CategorypickerSelection: .constant(.travail))
    }
}

