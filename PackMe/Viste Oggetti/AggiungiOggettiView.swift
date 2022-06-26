//
//  AddTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

struct AggiungiOggettiView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest<Oggetto>(entity: Oggetto.entity(), sortDescriptors: []) var allOggetti: FetchedResults<Oggetto>
    
    var viaggio: Viaggio
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                
                HStack{ //Questo HStack serve solo per far adattare bene lo sfondo ai bordi laterali grazie agli spacer
                    Spacer()
                    NavigationLink(destination: CreaOggettoView()){
                        
                        Text("Crea oggetto")
                            .font(.headline.bold())
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                    Spacer()
                }
                
                //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                
                ForEach({ () -> Array<String> in
                    var categorieLista = Set<String>.init()
                    
                    for oggetto in allOggetti {
                        categorieLista.insert(oggetto.categoria!)
                    }
                    
                    var categorieArray = Array<String>.init()
                    
                    for singolaCat in categorieLista{
                        categorieArray.append(singolaCat)
                    }
                    
                    return categorieArray.sorted()
                    
                }()){ currentCat in
                    let cat = PersistenceManager.shared.loadOggettiFromCategoria(categoria: currentCat)
                    
                    if (!cat.isEmpty){
                        OggettiCategoriaView(nome: currentCat, viaggio: viaggio, oggettiCategoria: cat)
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
                    .ignoresSafeArea()
            }else{
                Image("Sfondo App 4Dark")
                    .resizable()
                    .ignoresSafeArea()
            }
            
        }
        
        
    }
}
