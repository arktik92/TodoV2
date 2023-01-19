//
//  TodoDetailView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI
import CoreData

struct TodoDetailView: View {
    /* Variables CoreData */
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item
    
    /* Variables d'état */
    @State var title: String
    @State var plot: String
    @State var expire: Date
    @State var editMode: Bool = false
    @State var showingAlertContent = false
    @State var showingAlertTitle = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // MARK: - Background Color
            LinearGradient(colors: [Color(red: Double.random(in: 0.5...1), green: Double.random(in: 0.5...1), blue: Double.random(in: 0.5...1)),Color(red: Double.random(in: 0...0.5), green: Double.random(in: 0...0.5), blue: Double.random(in: 0...0.5))], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            // MARK: - editMode qui permet de modifier la Todo si il est = true
            if editMode {
                Form {
                    Section {
                        TextField(item.title ?? "No title", text: $title)
                        TextField(item.plot ?? "No Description", text: $plot, axis: .horizontal)
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
                        Text("Dates")
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
                // MARK: - si editMode = false affichage de la View non-modifiable
            else {
                VStack(alignment: .leading) {
                    
                    Text("Date d'écheance de la Todo:")
                        .font(.title3)
                        .fontWeight(.heavy)
                        
                        
                    Text("Le \(item.expire ?? Date.now, formatter: dateFormatter)")
                        .padding(.bottom)
                        .fontWeight(.bold)
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
                                .foregroundColor(.white)
                                .padding(15)
                                .background(
                                    Color.accentColor
                                        .cornerRadius(25)
                                )
                        }
                        Spacer()
                    }
                } .padding(.horizontal, 10)
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
                    // Bouton Share
                    ToolbarItem {
                        ShareLink(item: "Je te partage ma nouvelle Todo: \n\(item.title!)\n\(item.plot!)")
                    }
                    
                    // Bouton Back
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        }
                    }
                }.navigationBarTitle(item.title!)
            }
        }
    }
    
    // MARK: - Fonction SaveItem
    func saveItem() {
        do {
            item.title = title
            item.plot = plot
            item.expire = expire
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
 struct TodoDetailView_Previews: PreviewProvider {
 static var previews: some View {
 TodoDetailView()
 }
 }
 */
