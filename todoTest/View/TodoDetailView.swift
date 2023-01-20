//
//  TodoDetailView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI
import CoreData

#warning("Regler problème categorypickerSelection")
#warning("Ajouter switch couleurs en fonction du categoryPickerSelection")

struct TodoDetailView: View {
    // MARK: - Variables CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item
    
    // MARK: - Variables d'état
    @State var title: String
    @State var plot: String
    @State var expire: Date
    @State var editMode: Bool = false
    @State var showingAlertTitleAndContent: Bool = false
    @State var showingAlertContent: Bool = false
    @State var showingAlertTitle: Bool = false
    @State var categogyPickerSelection: CategoryPickerSelection = .travail
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // MARK: - Background Color

            BackgroundColor()
            
            // MARK: - editMode qui permet de modifier la Todo si il est = true
            if editMode {
                Form {
                    Section {
                        TextField(item.title ?? "No title", text: $title)
                        TextField(item.plot ?? "No Description", text: $plot, axis: .vertical)
                    } header: {
                        Text("Informations")
                    }
                    Section {
                        SegmentedPickerCategory(CategorypickerSelection: $categogyPickerSelection)
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
                            if title != "" && plot != "" {
                                if title != "" {
                                    if plot != "" {
                                        saveItem()
                                        editMode.toggle()
                                    } else {
                                        saveItemDate()
                                        editMode.toggle()
                                    }
                                } else {
                                    saveItemDate()
                                    editMode.toggle()
                                }
                            } else {
                                saveItemDate()
                                editMode.toggle()
                            }
                        } label: {
                            Text(editMode ? "Done" : "Edit")
                        }
                    }
                }
            }
                // MARK: - si editMode = false affichage de la View non-modifiable
            else {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        if item.category != nil {
                            Text(item.category!)
                                .foregroundColor(.black)
                                .bold()
                                .padding(25)
                                .background(
                                    Color.accentColor
                                        .clipShape(Circle())
                                )
                        }
                    }.padding(.vertical)
                    Text("Date d'écheance de la Todo:")
                        .font(.title3)
                        .fontWeight(.heavy)
                    if item.expire != nil {
                        Text("Le \(item.expire ?? Date().advanced(by: 576), formatter: dateFormatter)")
                            .padding(.bottom)
                            .fontWeight(.bold)
                    } else {
                        Text("Indéterminé")
                            .padding(.bottom)
                            .fontWeight(.bold)
                    }
                        
                    Text("Description :")
                        .font(.title3)
                        .fontWeight(.heavy)
                    Text(item.plot ?? "No description")
                        .fontWeight(.bold)
                    Spacer()
                    HStack {
                        Spacer()
                        // MARK: - Bouton qui passe la Todo à done
                        Button {
                            Task {
                                item.isDone = true
                                saveItem()
                                try? await Task.sleep(nanoseconds: 1_500_000_000)
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        } label: {
                            Text("Terminer la Todo")
                                .foregroundColor(.black)
                                .padding(15)
                                .background(
                                    Color.accentColor
                                        .cornerRadius(25)
                                )
                        }
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .navigationBarBackButtonHidden()
                
                // MARK: - Elements Toolbar
                .toolbar {
                    // Bouton Edit
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            if editMode {
                                saveItem()
                            }
                            editMode.toggle()
                        } label: {
                            Text(editMode ? "Done" : "Edit")
                        }
                    }
                    // Title
                    ToolbarItem(placement: .principal) {
                        Text(item.title ?? "No title")
                            .foregroundColor(.accentColor)
                    }
                    // Bouton Share
                    ToolbarItem {
                        ShareLink(item: "Je te partage ma nouvelle Todo: \n\(item.title ?? "No title")\n\(item.plot ?? "No description")")
                    }
                    
                    // Bouton Back
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            print(item.isDone)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
                }.navigationBarTitle(item.title ?? "No title")
            }
        }
    }

    // MARK: - Fonction SaveItem
    func saveItem() {
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
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    func saveItemDate() {
        do {
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

// MARK: - DateFormatter
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
/*
 #if DEBUG
 struct TodoDetailView_Previews: PreviewProvider {
 static var previews: some View {
 TodoDetailView()
 }
 }
 #endif
 */
