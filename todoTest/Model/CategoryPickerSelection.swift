//
//  CategoryPickerSelection.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 20/01/2023.
//

import Foundation


// MARK: - Enum pour le picker "Catégorie"

enum CategoryPickerSelection: String, Equatable, CaseIterable {
    case travail, maison, sport, famille, amis
    
    var categoryPickerSelectionString: String {
        switch self {
        case .travail:
            return "travail"
        case .amis:
            return "amis"
        case .famille:
            return "famille"
        case .maison:
            return "maison"
        case .sport:
            return "sport"
        }
    }
    
}
