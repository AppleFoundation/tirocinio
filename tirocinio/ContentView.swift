//
//  ContentView.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 24/04/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var showingWelcomeView: Bool = !UserDefaults.standard.bool(forKey: "firstAccess")
//    var preferred: ModeEnum = getPreferredColorScheme()
    @Environment(\.colorScheme) var systemColorScheme
    @State var myColorScheme: ColorScheme?
    
    @FetchRequest<Viaggio>(entity: Viaggio.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Viaggio.data, ascending: true)]) var allViaggi: FetchedResults<Viaggio>
    let columns = Array(repeating: GridItem.init(.fixed(175), spacing: 20, alignment: .center), count: 2)
    
    
    func getPreferredColorScheme(system: ColorScheme) -> ColorScheme?{
        let preferred: String = UserDefaults.standard.string(forKey: "PreferredColorScheme") ?? "none"
        print("\(preferred)")
        switch preferred{
        case "none":
            print("NONE")
            return nil;
        case "dark":
            print("DARK")
            return ColorScheme.dark;
        case "light":
            print("LIGHT")
            return ColorScheme.light;
        default:
            print("NONE")
            return system;
        }
    }

    
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
//                        .frame(width: 130)
                        .padding()
                        .background({ () -> Color in
                            if (myColorScheme == .dark){
                                return Color.init(white: 0.2)
                            }else if(myColorScheme == .light){
                                return Color.white
                            }else{
                                if(colorScheme == .dark){
                                    return Color.init(white: 0.2)
                                }else{
                                    return Color.white
                                }
                            }
                        }())
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                        
                        
                    }
                    .padding()
                    
                    
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
                if(myColorScheme == .light){
                    Image("Sfondo App 1Light")
                        .resizable()
                    //                        .scaledToFill()
                        .ignoresSafeArea()
                }else if(myColorScheme == .dark){
                    Image("Sfondo App 1Dark")
                        .resizable()
                    //                        .scaledToFill()
                        .ignoresSafeArea()
                }else{
                    if(colorScheme == .light){
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
                
            }
            .navigationViewStyle(.stack)
            
            .navigationTitle("SmartSuitCase")
            
            //            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(myColorScheme: $myColorScheme)) {
                        Image(systemName: "gearshape.fill")
                  }
                }
            }
        }
        .onAppear{
            self.myColorScheme = getPreferredColorScheme(system: self.systemColorScheme)
        }
        .colorScheme(myColorScheme ?? systemColorScheme)
    }
    
        

}


struct ActionButtonView: View{
    
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
            .background(NavigationLink("", destination: EditViaggioView(nomeViaggio: viaggio.nome ?? "OldName", dataViaggio: viaggio.data ?? Date.now, oldIcon: viaggio.tipo ?? "questionmark", viaggio: viaggio), isActive: $editEnable))
            
       
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}

