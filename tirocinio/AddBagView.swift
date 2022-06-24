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
    @FetchRequest<Valigia>(entity: Valigia.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Valigia.nome, ascending: true)]) var allValigie: FetchedResults<Valigia>
    var viaggio: Viaggio
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                HStack{ //Questo HStack serve solo per far adattare bene lo sfondo ai bordi laterali grazie agli spacer
                    Spacer()
                    NavigationLink(destination: AddNuovaValigia()){
                        
                        Text("Crea valigia")
                            .font(.headline.bold())
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                    Spacer()
                }
                
                
                Spacer(minLength: 20)
                
                ForEach(allValigie){
                    valigiaAttuale in
                    if (valigiaAttuale.categoria != nil){
                        if (valigiaAttuale.categoria! != "0SYSTEM"){
                            ValigiaCardView(valigia: valigiaAttuale, viaggio: viaggio)
                        }
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
                    .ignoresSafeArea()
            }else{
                Image("Sfondo App 3Dark")
                    .resizable()
                    .ignoresSafeArea()
            }
        }
        .navigationTitle("Aggiungi Valigie")
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}


