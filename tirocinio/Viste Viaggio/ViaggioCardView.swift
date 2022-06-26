//
//  ViaggioCardView.swift
//  tirocinio
//
//  Created by Salvatore Apicella on 26/06/22.
//

import SwiftUI

struct ViaggioCardView: View{
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viaggio: Viaggio
    
    @State private var editEnable = false
    @State private var showingAlertViaggio = false
    
    var body: some View{
        
        
        
        VStack{
            
            
            VStack{
                Image(systemName: viaggio.tipo ?? "questionmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor([.blue, .mint, .orange, .green, .red, .pink, .purple, .yellow].randomElement())
                    .frame(width: 50)
                
                Text(viaggio.nome ?? "NoWhere")
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                
                Text(viaggio.data ?? Date(), style: .date)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                
                
            }
            .padding()
            .frame(minWidth: 175, minHeight: 150)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .overlay(){
                NavigationLink(destination: DettagliViaggioView(viaggio: viaggio)){
                    Rectangle()
                        .background(Color.white)
                        .opacity(0.1)
                    
                        .cornerRadius(10)
                }
            }
            
            
            
            
            .contextMenu(.init(menuItems: {
                Button(action: {
                    showingAlertViaggio = true
                }, label:
                        {
                    HStack{
                        Text("Elimina")
                        Image(systemName: "trash.fill")
                        
                    }
                })
                Button(action: {
                    editEnable = true
                }, label: {
                    HStack {
                        Text("Modifica")
                        Image(systemName: "pencil")
                    }
                })
            }))
            .confirmationDialog("Vuoi davvero eliminare questo viaggio?", isPresented: $showingAlertViaggio, titleVisibility: .visible){
                Button("Elimina", role: .destructive){
                    PersistenceManager.shared.deleteViaggio(nome: viaggio.nome ?? "NoWhere")
                }
            }
        }
        .background(NavigationLink("", destination: ModificaViaggioView(nomeViaggio: viaggio.nome ?? "OldName", dataViaggio: viaggio.data ?? Date.now, oldIcon: viaggio.tipo ?? "questionmark", viaggio: viaggio), isActive: $editEnable))
        
        
        
    }
}
