//
//  AddViaggioView.swift
//  tirocinio
//
//  Created by Cristian Cerasuolo on 22/05/22.
//

import SwiftUI

struct AddViaggioView: View {
    @State var nomeViaggio: String = ""
    @State var dataViaggio: Date = Date.now
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
//    @Binding var allViaggi: [Viaggio]
//    
//    init(allViaggi: Binding<[Viaggio]>){
//        self._allViaggi = allViaggi
//    }
    var body: some View {
            Form{
                //nome, data
                Section(header: Text("Nome")){
                    
                    TextField("Nome Viaggio", text: $nomeViaggio)
                    
                    //Inserire un limite di caratteri massimo 30
                        
        
                }
                Section(header: Text("Data")){
                    DatePicker("Data Partenza", selection: $dataViaggio, displayedComponents: .date)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Nuovo viaggio")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        PersistenceManager.shared.addViaggio(data: dataViaggio, nome: nomeViaggio)
                        
                        //non allocati è una valigia di sistema creata per ogni viaggio in grado di contenere gli oggetti non ancora allocati
                        let nonallocati: Valigia = PersistenceManager.shared.loadValigieFromCategoria(categoria: "SYSTEM")[0]
                        PersistenceManager.shared.addValigiaViaggiante(valigia: nonallocati, viaggio: PersistenceManager.shared.loadViaggiFromNome(nome: nomeViaggio)[0])
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
//        AddViaggioView()
//    }
//}
