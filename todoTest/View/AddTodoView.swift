//
//  AddTodoView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI
import CoreData

struct AddTodoView: View {
    // MARK: -  Variables CoreData
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - Variables d'état
    @State var title: String = ""
    @State var content: String = ""
    @State var expire: Date = Date.now
    @State var showingAlertTitleAndContent = false
    @State var showingAlertContent = false
    @State var showingAlertTitle = false
    @State var dateToggleSwitch: Bool = false
    @State var categogyPickerSelection: CategoryPickerSelection = .travail
    
    // MARK: - Variables Binding
    @Binding var addTodo: Bool
    
    // MARK: - Importation ViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                // MARK: - Bouton Ajout Todo
                Button {
                    if title != "" && content != "" {
                        if title != "" {
                            if content != "" {
                                Task {
                                   let _ = todoVM.addItem(title: title, plot: content, expire: expire, categogyPickerSelection: categogyPickerSelection, dateToggleSwitch: dateToggleSwitch, vc: viewContext)
                                    todoVM.todos = await todoVM.loadData(vc: viewContext)
                                    addTodo = false
                                }
                            } else {
                                showingAlertContent = true
                            }
                        } else {
                            showingAlertTitle = true 
                        }
                    } else {
                        showingAlertTitleAndContent = true
                    }
                } label: {
                    Text("Ajouter")
                        .padding(30)
                }.accessibilityIdentifier("add")
                .alert("Oups ! Tu as oublié d'ajouter un titre et une description", isPresented: $showingAlertTitleAndContent) {
                    Button("OK", role: .cancel) { }
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
                    TextField("Description", text: $content)
                } header: {
                    Text("Informations")
                }   
                Section {
                    SegmentedPickerCategory(CategorypickerSelection: $categogyPickerSelection)
                        .accessibilityIdentifier("categoryPicker")
                }header: {
                    Text("Categorie")
                }
                Section {
                    if dateToggleSwitch {
                        DatePicker(selection: $expire, in: Date.now..., displayedComponents: .date) {
                            Text("Date")
                        }.accessibilityIdentifier("dateField")
                        DatePicker(selection: $expire, displayedComponents: .hourAndMinute) {
                            Text("heure")
                        }.accessibilityIdentifier("hourField")
                    }
                } header: {
                    HStack {
                        Text("Date et heure")
                        Toggle(isOn: $dateToggleSwitch) {
                            EmptyView()
                        }
                        .accessibilityIdentifier("switcher")
                    }
                }
            }
        } .background(Color(red: 0.109, green: 0.109, blue: 0.117))
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(expire: Date.now, addTodo: .constant(false))
            .environmentObject(TodoViewModel())
    }
}

