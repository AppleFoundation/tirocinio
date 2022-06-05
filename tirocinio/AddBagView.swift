//
//  AddBagView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//


import SwiftUI
struct AddBagView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FetchRequest<Valigia>(entity: Valigia.entity(), sortDescriptors: []) var allValigie: FetchedResults<Valigia>
    let categories = PersistenceManager.shared.loadAllCategorieValigie().sorted()
    var viaggio: Viaggio
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    
                    //Qui si devono passare una serie di array alle varie categorie in modo che possano prelevare e visualizzare gli elementi
                   
                    HStack{
                        Spacer()
//                        Button(action: {
//                            print("Ciao")
//                            //Creare la funzione per togliere le valigie viaggianti
//                        }, label: {
//                            Text("Togli valigie")
//                                .font(.headline.bold())
//                            Image(systemName: "trash")
//                        })
//                        .frame(width: 130)
//                        .padding()
//                        .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
//                        Spacer()
                        NavigationLink(destination: AddNuovaValigia()){
                            
                            Text("Crea valigia")
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
                    
                    ForEach(categories){ currentCat in
                        let cat = PersistenceManager.shared.loadValigieFromCategoria(categoria: currentCat)
                        
                        if (!cat.isEmpty){
                            BagCategoriaScrollView(nome: currentCat, viaggio: viaggio, valigiaCategoria: cat)
                        }
                    }
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background{
                if(String("\(colorScheme)") == "light"){
                    Image("Sfondo App 3Light")
                        .resizable()
//                        .scaledToFill()
                        .ignoresSafeArea()
                }else{
                    Image("Sfondo App 3Dark")
                        .resizable()
//                        .scaledToFill()
                        .ignoresSafeArea()
                }
                
            }
        .navigationTitle("Aggiungi Valigie")
    }
}



