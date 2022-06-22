//
//  AddViaggioView.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 22/05/22.
//

import SwiftUI

struct EditViaggioView: View {
    @State var nomeViaggio: String = ""
    @State var dataViaggio: Date = Date.now
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    var viaggio: Viaggio
    
    var body: some View {
        
        Form{
            //nome, data
            Section(header: Text("Nome")){
                TextField("Nuovo nome viaggio", text: $nomeViaggio)
                //Inserire un limite di caratteri massimo 30 (calcolato altrimenti è brutto da vedere)
            }
            //                Section(header: Text("Vecchia data: \(viaggio.data?.formatted() ?? Date.init().formatted())")){
            Section(header: Text("Data")){
                DatePicker("Data Partenza", selection: $dataViaggio, displayedComponents: .date)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Modifica viaggio")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {
                    viaggio.nome = nomeViaggio
                    viaggio.data = dataViaggio
                    PersistenceManager.shared.saveContext()
                    
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Save")})
            }
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {Text("Cancel")})
            }
        }
        
    }
}
