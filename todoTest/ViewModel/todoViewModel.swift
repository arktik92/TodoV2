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
    // MARK: - Tableau D'Item
    @Published var todos: [Item] = []
    
    let notificationManager = NotificationManager()
    
    // MARK: - DateFormatter
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - InitVM
    init() {}
    
    // MARK: - Fonction loadData
    // qui permet d'implementer le tableau "todos"
    func loadData(vc: NSManagedObjectContext) async -> [Item] {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            return try vc.fetch(fetchRequest)
        } catch {
            print("Echec de la mise à jour des Todo: \(error)")
            return []
        }
    }
    
    func scheduleNotification(triggerDate: Date?, title: String, plot: String) -> String {
        let notificationId = UUID()
        
        // Création du contenu de la notification
        let content = UNMutableNotificationContent()
        content.title = "\(title)"
        content.subtitle = "\(plot)"
        content.sound = UNNotificationSound.default

        // Envoi de la notification
            var dateComponents = DateComponents()
            dateComponents = Calendar.current.dateComponents([.hour,.day,.minute], from: triggerDate!)
            
        // Création du déclencheur de la notification
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        notificationManager.scheduleNotification(id: "\(notificationId)", content: content, trigger: trigger)
        
        return "\(notificationId)"
    }
  
    // MARK: - Fonction Ajout de todo
    func addItem(title: String, plot: String, expire: Date?, categogyPickerSelection: CategoryPickerSelection, dateToggleSwitch: Bool, vc: NSManagedObjectContext) -> Item {
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
                let notifId = scheduleNotification(triggerDate: newItem.expire, title: newItem.title!, plot: newItem.plot!)
                newItem.notifId = notifId
            }
            do {
                try vc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            return newItem
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
                notificationManager.removePendingNotification(id: item.notifId ?? "")
                let notifId = scheduleNotification(triggerDate: item.expire, title: item.title!, plot: item.plot!)
                item.notifId = notifId
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
                notificationManager.removePendingNotification(id: item.notifId ?? "")
                let notifId = scheduleNotification(triggerDate: item.expire, title: item.title!, plot: item.plot!)
                item.notifId = notifId
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
            let item = offsets.map { items[$0] }
            notificationManager.removePendingNotification(id: item.first!.notifId ?? "")
            offsets.map { items[$0] }.forEach(vc.delete)
            todos.remove(atOffsets: offsets)
            do {
                Task{
                    try vc.save()
                    todos = await loadData(vc: vc)
                }
            } 
        }
    }
    
    // MARK: - Fonction MoveItem
    func moveTodo(fromOffsets source: IndexSet, toOffset destination: Int) {
        todos.move(fromOffsets: source, toOffset: destination)
    }
}
