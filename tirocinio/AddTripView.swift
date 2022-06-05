//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

extension String: Identifiable {
    public var id: String {
        self
    }
}

struct AddTripView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest<Oggetto>(entity: Oggetto.entity(), sortDescriptors: []) var allOggetti: FetchedResults<Oggetto>
    let categories = PersistenceManager.shared.loadAllCategorieOggetti().sorted()
    var viaggio: Viaggio
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                
                
                HStack{
                    Spacer()
                    //                        Button(action: {
                    //                            PersistenceManager.shared.deleteAllOggettoViaggiante(viaggio: viaggio)
                    //                            self.presentationMode.wrappedValue.dismiss()
                    //                        }, label: {
                    //                            Text("Togli oggetti")
                    //                                .font(.headline.bold())
                    //                            Image(systemName: "trash")
                    //                        })
                    //                        .frame(width: 130)
                    //                        .padding()
                    //                        .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                    //                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    //                        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                    //                        Spacer()
                    NavigationLink(destination: AddNuovoOggetto()){
                        
                        Text("Crea viaggio")
                            .font(.headline.bold())
                        Image(systemName: "plus")
                    }
                    .frame(width: 130)
                    .padding()
                    .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                    
                    Spacer()
                }
                .padding()
                //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                
                ForEach(categories){ currentCat in
                    let cat = PersistenceManager.shared.loadOggettiFromCategoria(categoria: currentCat)
                    
                    if (!cat.isEmpty){
                        CategoriaScrollView(nome: currentCat, viaggio: viaggio, oggettiCategia: cat)
                    }
                }
                
                
                Spacer(minLength: 50)
            }
        }
        .navigationTitle("Aggiungi Oggetti")
        .background{
            if(String("\(colorScheme)") == "light"){
                Image("Sfondo App 4Light")
                    .resizable()
                //                        .scaledToFill()
                    .ignoresSafeArea()
            }else{
                Image("Sfondo App 4Dark")
//                    .resizable()
                //                        .scaledToFill()
                    .ignoresSafeArea()
            }
            
        }
       
        
    }
}




