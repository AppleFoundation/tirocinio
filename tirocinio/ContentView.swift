//
//  ContentView.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 24/04/22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var showingWelcomeView: Bool
    
    //    @State var allViaggi: [Viaggio] = PersistenceManager.shared.loadAllViaggi()
    @FetchRequest<Viaggio>(entity: Viaggio.entity(), sortDescriptors: []) var allViaggi: FetchedResults<Viaggio>
    let columns = Array(repeating: GridItem.init(.fixed(175), spacing: 20, alignment: .center), count: 2)
    
    var body: some View{
        NavigationView{
            
            ScrollView{
                VStack{
                    
                    HStack{
                        
                        NavigationLink(destination: AddViaggioView()){
                            
                            Text("Crea viaggio")
                                .font(.headline.bold())
                            Image(systemName: "plus")
                        }
                        .frame(width: 130)
                        .padding()
                        .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                        
                        
                    }
                    .padding()
                    
//                    Button(action: {
//                        inizializzaOggetti()
//                        inizializzaValigie()
//
//                    }, label: {Text("Inizializza")})
                    
                    VStack{
                        LazyVGrid(columns: columns, alignment: .center) {
                            
                            ForEach(allViaggi){
                                viaggio in
                                
                                ActionButtonView(viaggio: viaggio)
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
            }
            .sheet(isPresented: $showingWelcomeView, onDismiss: {
                UserDefaults.standard.set(true, forKey: "firstAccess")
            }){
                IntroductionView(showingWelcomeView: $showingWelcomeView)
            }
            .background{
                if(String("\(colorScheme)") == "light"){
                    Image("Sfondo App 1Light")
                        .resizable()
                    //                        .scaledToFill()
                        .ignoresSafeArea()
                }else{
                    Image("Sfondo App 1Dark")
                        .resizable()
                    //                        .scaledToFill()
                        .ignoresSafeArea()
                }
                
            }
            .navigationViewStyle(.stack)
            
            .navigationTitle("SmartSuitCase")
            
            //            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        }
    }
    
    
    

}


struct ActionButtonView: View{
    
    @Environment(\.colorScheme) var colorScheme
    
    var viaggio: Viaggio
    
    @State private var editEnable = false
    @State private var showingAlertViaggio = false
    
    var body: some View{
        
        if(editEnable == false){
            
            
            ZStack{
                
                VStack{
                    Image(systemName: viaggio.tipo ?? "questionmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.blue)
                        .frame(width: 50)
                    
                    Text(viaggio.nome ?? "NoWhere")
                        .font(.title.bold())
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    Text(viaggio.data ?? Date(), style: .date)
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                }
                .padding()
                .frame(minWidth: 175, minHeight: 150, maxHeight: 300)
                .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                
                
                NavigationLink(destination: DetailTripView(viaggio: viaggio)){
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
                        Text("Edit")
                        Image(systemName: "pencil")
                    }
                })
            }))
            .confirmationDialog("Vuoi davvero eliminare questo viaggio?", isPresented: $showingAlertViaggio, titleVisibility: .visible){
                Button("Elimina", role: .destructive){
                    PersistenceManager.shared.deleteViaggio(nome: viaggio.nome ?? "NoWhere")
                }
            }
        }else{
            
            VStack{
                Image(systemName: "clock.arrow.circlepath")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .frame(width: 50)
                
                Text("Loading...")
                    .font(.title.bold())
                    .foregroundColor(Color.red)
                
            }
            .padding()
            .frame(minWidth: 175, minHeight: 150, maxHeight: 300)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .foregroundColor(Color.red)
            .background(NavigationLink("", destination: EditViaggioView(nomeViaggio: viaggio.nome ?? "OldName", dataViaggio: viaggio.data ?? Date.now, oldIcon: viaggio.tipo ?? "questionmark", viaggio: viaggio), isActive: $editEnable))
            
            
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showingWelcomeView: true)
            .previewDevice("iPhone 11")
    }
}

