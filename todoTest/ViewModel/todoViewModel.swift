//
//  todoViewModel.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 18/01/2023.
//

import Foundation
import SwiftUI
import CoreData

@MainActor class TodoViewModel: ObservableObject {
    // MARK: - Variable CoreData
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - DateFormatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - Tableau D'Item
    @Published var todos: [Item] = []
    
    // MARK: - InitVM
    init() {}
    
    // MARK: - Fonction loadData qui permet d'implementer le tableau "todos"
    func loadData(vc: NSManagedObjectContext) async -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            return try vc.fetch(fetchRequest)
        } catch {
            print("Echec de la mise à jour des Todo: \(error)")
            return []
        }
    }
    
    // MARK: - Fonction Ajout de todo
    func addItem(title: String, plot: String, expire: Date?, categogyPickerSelection: CategoryPickerSelection, dateToggleSwitch: Bool, vc: NSManagedObjectContext) {
        withAnimation {
            let newItem = Item(context: vc)
            newItem.plot = plot
            newItem.title = title
            newItem.isDone = false
            newItem.timestamp = Date()
            newItem.category = categogyPickerSelection.categoryPickerSelectionString
            newItem.dateToggleSwitch = dateToggleSwitch
            if dateToggleSwitch {
                newItem.expire = expire
                
                // Envoi de la notification
                    var dateComponents = DateComponents()
                    dateComponents = Calendar.current.dateComponents([.hour,.day,.minute], from: expire!)
                    
                    // Création du contenu de la notification
                    let content = UNMutableNotificationContent()
                    content.title = "\(title)"
                    content.subtitle = "\(plot)"
                    content.sound = UNNotificationSound.default
                    
                    // Création du déclencheur de la notification
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    // création du random identifier et de la requete
                    let uuidString = UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                    
                    // Création, envoi de la requete et gestion de l'erreur
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request) { error in
                        if error != nil {
                            print("ERREUR")
                        }
                        print("SUCCESS")
                }
            }
            do {
                try vc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Fonction SaveItem
    func saveItem(item: Item, title: String, plot: String, categogyPickerSelection: CategoryPickerSelection, expire: Date, vc: NSManagedObjectContext ) {
        do {
            item.title = title
            item.plot = plot
            item.dateToggleSwitch = item.dateToggleSwitch
            item.category = categogyPickerSelection.categoryPickerSelectionString
            if item.dateToggleSwitch {
                item.expire = expire
            } else {
                item.expire = nil
            }
            try vc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func saveItemDate(item: Item, vc: NSManagedObjectContext, expire: Date) {
        do {
            item.dateToggleSwitch = item.dateToggleSwitch
            if item.dateToggleSwitch {
                item.expire = expire
            } else {
                item.expire = nil
            }
            try vc.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    // MARK: - Fonction DeleteItem
    func deleteItems(offsets: IndexSet, vc: NSManagedObjectContext, items: FetchedResults<Item>) {
        withAnimation {
            offsets.map { items[$0] }.forEach(vc.delete)
            todos.remove(atOffsets: offsets)
            do {
                Task{
                    try vc.save()
                    todos = await loadData(vc: vc)
                }
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Fonction MoveItem
    func moveTodo(fromOffsets source: IndexSet, toOffset destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
    }
}
