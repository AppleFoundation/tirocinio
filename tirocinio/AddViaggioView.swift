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
        NavigationView{
            Form{
                //nome, data
                Section(header: Text("Nome")){
                    
                    TextField("Nome Viaggio", text: $nomeViaggio)
                }
                Section(header: Text("Data")){
                    DatePicker("Data Partenza", selection: $dataViaggio, displayedComponents: .date)
                }
            }
            .navigationTitle("Nuovo viaggio")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
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
        .navigationBarHidden(true)
        
    }
}

//struct AddViaggioView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddViaggioView()
//    }
//}
