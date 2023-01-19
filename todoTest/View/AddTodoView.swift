//
//  AddTodoView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI
import CoreData

struct AddTodoView: View {
    /* Variable CoreData */
    @Environment(\.managedObjectContext) private var viewContext
    
    /* Variables d'état */
    @Environment(\.presentationMode) var presentationMode
    @State var title: String = ""
    @State var content: String = ""
    @State var expire: Date = Date.now
    @State var showingAlertContent = false
    @State var showingAlertTitle = false
    
    /* Importation ViewModel */
    @EnvironmentObject var todoVM: TodoViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                // MARK: - Bouton Ajout Todo
                Button {
                    if title != "" {
                        if content != "" {
                            Task {
                                addItem(title: title, plot: content, expire: expire)
                                todoVM.todos = await todoVM.loadData(vc: viewContext)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            showingAlertContent = true
                        }
                    } else {
                        showingAlertTitle = true
                        
                    }
                } label: {
                    Text("Ajouter")
                        .padding(30)
                        
                }
                .alert("Oups ! Tu as oublié d'ajouter une description", isPresented: $showingAlertContent) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Oups ! Tu as oublié d'ajouter un titre", isPresented: $showingAlertTitle) {
                    Button("OK", role: .cancel) { }
                }
            }
           
            // MARK: - Formulaire
            Form {
                Section {
                    TextField("Titre", text: $title)
                    TextField("Description", text: $content, axis: .vertical)
                    
                } header: {
                    Text("Informations")
                }
                Section {
                    DatePicker(selection: $expire, in: Date.now..., displayedComponents: .date) {
                        Text("Date")
                    }
                    DatePicker(selection: $expire, displayedComponents: .hourAndMinute) {
                        Text("heure")
                    }
                    
                } header: {
                    Text("Date et heure")
                }
            }
        } .background(Color(red: 0.949, green: 0.949, blue: 0.968))
    }
    
    // MARK: - Fonction Ajout de todo
    func addItem(title: String, plot: String, expire: Date) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.plot = plot
            newItem.title = title
            newItem.isDone = false
            newItem.expire = expire
            newItem.timestamp = Date()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
            .environmentObject(TodoViewModel())
    }
}
