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
    
//    @Binding var allViaggi: [Viaggio]
//    
//    init(allViaggi: Binding<[Viaggio]>){
//        self._allViaggi = allViaggi
//    }
    var body: some View {

            Form{
                //nome, data
                Section(header: Text("Vecchio nome: \(viaggio.nome ?? "Vecchio nome")")){
                    
                    TextField("Nuovo nome viaggio", text: $nomeViaggio)
                    
                    //Inserire un limite di caratteri massimo 30
                        
        
                }
                Section(header: Text("Vecchia data: \(viaggio.data?.formatted() ?? Date.init().formatted())")){
                    DatePicker("Data Partenza", selection: $dataViaggio, displayedComponents: .date)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Modifica viaggio")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        //⚠️ DA IMPLEMENTARE UN MECCANISMO PER CAMBIARE IL NOME DEL VIAGGIO SE SI PUÒ
                        PersistenceManager.shared.deleteViaggio(nome: viaggio.nome!)
                        PersistenceManager.shared.addViaggio(data: dataViaggio, nome: nomeViaggio)
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {Text("Save")})
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
//                        allViaggi = PersistenceManager.shared.loadAllViaggi()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {Text("Cancel")})
                }
            }
            
        
        
    }
}

//struct AddViaggioView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditViaggioView()
//    }
//}
