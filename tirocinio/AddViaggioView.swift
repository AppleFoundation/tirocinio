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
    @State var tipoViaggio: String = ""
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    enum TipiViaggio: String, CaseIterable, Identifiable {
        case aereo, nave, sole, natura
        var id: Self { self }
    }
    @State private var selectedTipo: TipiViaggio = .aereo
    
    
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
            
            Section(header: Text("Icona")){
                Picker("Tipo", selection: $selectedTipo) {
                    Image(systemName: "airplane").tag(TipiViaggio.aereo)
                    Image(systemName: "ferry.fill").tag(TipiViaggio.nave)
                    Image(systemName: "sun.max.fill").tag(TipiViaggio.sole)
                    Image(systemName: "leaf.fill").tag(TipiViaggio.natura)
                }
                .pickerStyle(.segmented)
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
                    PersistenceManager.shared.addViaggio(data: dataViaggio, nome: {
                        if(!nomeViaggio.isEmpty){
                            return nomeViaggio
                        }else{
                            var i = 1
                            while (!PersistenceManager.shared.loadViaggiFromNome(nome: "Viaggio" + "\(i)").isEmpty){
                                i += 1
                            }
                            nomeViaggio = "Viaggio" + "\(i)"
                            return "Viaggio" + "\(i)"
                        }
                    }(), tipo: {
                        switch selectedTipo {
                        case .aereo:
                            return "airplane"
                        case .nave:
                            return "ferry.fill"
                        case .sole:
                            return "sun.max.fill"
                        case .natura:
                            return "leaf.fill"
                        }
                    }())
                    
                    //non allocati è una valigia di sistema creata per ogni viaggio in grado di contenere gli oggetti non ancora allocati
                    PersistenceManager.shared.addValigia(categoria: "0SYSTEM", lunghezza: 0, larghezza: 0, profondita: 0, nome: "Non Allocati", tara: 0, utilizzato: false)
                    let nonallocati: Valigia = PersistenceManager.shared.loadValigieFromCategoria(categoria: "0SYSTEM")[0]
                    PersistenceManager.shared.addValigiaViaggiante(valigia: nonallocati, viaggio: PersistenceManager.shared.loadViaggiFromNome(nome: nomeViaggio)[0], pesoMassimo: 0)
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
