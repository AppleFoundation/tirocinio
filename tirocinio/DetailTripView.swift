//
//  DetailTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

struct DetailTripView: View {
    
    var viaggio: Viaggio
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack{
            Text("Per essere pronto al viaggio non dimenticare di aggiungere tutti gli oggetti necessari e le valigie che hai a disposizione per questo viaggio!")
                .font(.headline)
                .multilineTextAlignment(.center)
                
            HStack{
                
                Spacer()
                NavigationLink(destination: AddTripView()){
                    VStack{
                        Text("Aggiungi Oggetti")
                        Image(systemName: "archivebox.fill")
                            .padding(.top, 1.0)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                    
                }
            
                Spacer()
            
                NavigationLink(destination: AddBagView()){
                    VStack{
                        Text("Aggiungi Valigie")
                        Image(systemName: "suitcase.fill")
                            .padding(.top, 1.0)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
                }
                
                Spacer()
               
                
            }
            Spacer()
        }
        .padding()
        
        
        
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viaggio.nome ?? "Nome viaggio")
        
    }
}

struct DetailTripView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTripView(viaggio: PersistenceManager.shared.loadAllViaggi()[0])
            .previewDevice("iPhone 11")
    }
}
