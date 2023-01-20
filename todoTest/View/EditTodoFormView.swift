//
//  EditTodoForm.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 20/01/2023.
//
/*
import SwiftUI

struct EditTodoFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var item: Item
    @State var title: String = ""
    @State var plot: String = ""
    @State var expire: Date?
    @State var editMode: Bool = false
    @State var showingAlertContent = false
    @State var showingAlertTitle = false
    
    var body: some View {
        Form {
            Section {
                TextField(item.title ?? "No title", text: $title)
                TextField(item.plot ?? "No Description", text: $plot, axis: .vertical)
            } header: {
                Text("Informations")
            }
            Section {
                if item.dateToggleSwitch {
                    DatePicker(selection: $expire, in: Date.now..., displayedComponents: .date) {
                        Text("Date")
                    }
                    DatePicker(selection: $expire, displayedComponents: .hourAndMinute) {
                        Text("heure")
                    }
                }
            } header: {
                HStack {
                    Text("Dates")
                    Toggle(isOn: $item.dateToggleSwitch) {
                        EmptyView()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        // MARK: - Elements Toolbar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if title != "" {
                        if plot != "" {
                            saveItem()
                            editMode.toggle()
                        }
                    }
                } label: {
                    Text(editMode ? "Done" : "Edit")
                }
                .alert("Oups ! Tu as oublié d'ajouter une description", isPresented: $showingAlertContent) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Oups ! Tu as oublié d'ajouter un titre", isPresented: $showingAlertTitle) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
    }
    
    // MARK: - Fonction SaveItem
    func saveItem() {
        do {
            item.title = title
            item.plot = plot
            item.dateToggleSwitch = item.dateToggleSwitch
            if item.dateToggleSwitch {
                item.expire = expire
            } else {
                item.expire = nil
            }
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}

struct EditTodoFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditTodoFormView(title: "Title", plot: "Description", expire: Date.now)
    }
}
*/
