//
//  todoViewModel.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 18/01/2023.
//

import Foundation
import SwiftUI
import CoreData

class TodoViewModel: ObservableObject {
    /* Variables CoreData */
    
   
    // MARK: - Tableau D'Item
    @Published var todos: [Item] = []
    
    // MARK: - Fonction loadData qui permet d'implementer le tableau "todos"
    func loadData(vc: NSManagedObjectContext ) async -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            return try vc.fetch(fetchRequest)
        } catch {
            print("Echec de la mise à jour des Todo: \(error)")
            return []
        }
    }
}
