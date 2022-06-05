//
//  DetailTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

struct DetailTripView: View {
    
    var viaggio: Viaggio
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showingAlertOggetti = false
    @State private var showingAlertValigie = false

    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    let valigieDB = PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio)
                    let oggettiDB = PersistenceManager.shared.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio)
                    let insiemeDiValigie = leMieValigie.init(valigieViaggianti: valigieDB, oggettiViaggianti: oggettiDB)
                    HStack{
                        Spacer()
                        ZStack{
                            VStack{
                                Text("Aggiungi Oggetti")
                                Text("Oggetti presenti: \(oggettiDB.count)")
                                    .font(.caption)
                                Image(systemName: "archivebox.fill")
                                    .padding(.top, 1.0)
                            }
                            .padding()
                            .frame(width: 150, height: 80)
                            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)

                            NavigationLink(destination:  AddTripView(viaggio: viaggio)){
                                Rectangle()
                                    .background(Color.white)
                                    .opacity(0.1)
                                    .frame(width: 150, height: 80)
                                    .cornerRadius(10)
                            }
                        }
                        .contextMenu(.init(menuItems: {
                            
//                            Button(action: {
//                                PersistenceManager.shared.deleteAllOggettoViaggiante(viaggio: viaggio)
//                            }, label: {
//                                HStack {
//                                    Text("Togli oggetti")
//                                    Image(systemName: "trash")
//                                }
//                            })
                            
                            
                            Button(action: {
                                showingAlertOggetti = true
                            }, label: {
                                HStack {
                                    Text("Togli oggetti")
                                    Image(systemName: "trash")
                                }
                            })
                           
                            
                            
                        }))
                        .confirmationDialog("Vuoi davvero togliere tutti gli oggetti?", isPresented: $showingAlertOggetti, titleVisibility: .visible){
                            Button("Rimuovi", role: .destructive){
                                PersistenceManager.shared.deleteAllOggettoViaggiante(viaggio: viaggio)
                            }
                        }
                        
                        Spacer()
                        
                        
                        ZStack{
                            VStack{
                                Text("Aggiungi Valigie")
                                Text("Valigie presenti: \(valigieDB.count)")
                                    .font(.caption)
                                Image(systemName: "suitcase.fill")
                                    .padding(.top, 1.0)
                                
                            }
                            .padding()
                            .frame(width: 150, height: 80)
                            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
                            
                            NavigationLink(destination:  AddBagView(viaggio: viaggio)){
                                Rectangle()
                                    .background(Color.white)
                                    .opacity(0.1)
                                    .frame(width: 150, height: 80)
                                    .cornerRadius(10)
                            }
                        }
                        .contextMenu(.init(menuItems: {
                            
                            Button(action: {
                                showingAlertValigie = true
                            }, label: {
                                HStack {
                                    Text("Togli valigie")
                                    Image(systemName: "trash")
                                }
                            })
                            
                        }))
                        .confirmationDialog("Vuoi davvero togliere tutte le valigie?", isPresented: $showingAlertValigie, titleVisibility: .visible){
                            Button("Rimuovi", role: .destructive){
                                PersistenceManager.shared.deleteAllValigiaViaggiante(viaggio: viaggio)
                            }
                        }
                        
                       
                        Spacer()
                    }
            
            
                    
                    ForEach(insiemeDiValigie.tutteLeValigie){
                        singolaIstanza in
                        
                        if(singolaIstanza.oggettiInseriti.isEmpty == false){
                            Spacer()
                            VStack{
                                HStack{
                                    Text(singolaIstanza.nomeValigia)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    //                                    .foregroundColor(Color.blue)
                                    
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        Text("Ingombro Occupato: \(singolaIstanza.volumeAttuale/1000)l di \(singolaIstanza.volumeMassimo/1000)l")
                                            .font(.caption)
                                        Text("Peso Occupato: \(singolaIstanza.pesoAttuale)g di \(singolaIstanza.pesoMassimo)g")
                                            .font(.caption)
                                    }
                                }
                                .padding(.bottom)
                                
                                ForEach(singolaIstanza.oggettiInseriti){
                                    singoloOggetto in
                                    
                                    HStack{
                                        Text("\((singoloOggetto.oggettoRef?.nome)!): \((singoloOggetto.oggettoRef?.peso)!)g")
                                            .font(.body)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            .background(coloreScelto(valigia: singolaIstanza))
                            .cornerRadius(10)
                            
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.large)
        .background{
            if(String("\(colorScheme)") == "light"){
                Image("Sfondo App 2Light")
                    .resizable()
//                    .scaledToFill()
                    .ignoresSafeArea()
            }else{
                Image("Sfondo App 2Dark")
                    .resizable()
//                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
        }
        .navigationTitle(viaggio.nome ?? "Nome viaggio")
        
    }

    private func  coloreScelto(valigia: valigiaDaRiempire) -> LinearGradient{

        var gradienteScheda: LinearGradient = LinearGradient(colors: [Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
        
        let inizio = UnitPoint.bottom
        let fine = UnitPoint.top

        if(String("\(colorScheme)") == "light"){
            if(valigia.pesoAttuale > valigia.pesoMassimo){
                //Rossa light
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 208/255, green: 24/255, blue: 24/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 212/255, green: 105/255, blue: 105/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }else if(Double(valigia.pesoAttuale) > Double(valigia.pesoMassimo) * 0.9){
                //Gialla light
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 204/255, blue: 24/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 255/255, green: 229/255, blue: 138/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }else{
                //Verde light
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 67/255, green: 198/255, blue: 33/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 120/255, green: 195/255, blue: 120/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }
        }else{
            if(valigia.pesoAttuale > valigia.pesoMassimo){
                //Rossa dark
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 119/255, green: 17/255, blue: 17/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 161/255, green: 22/255, blue: 22/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }else if(Double(valigia.pesoAttuale) > Double(valigia.pesoMassimo) * 0.9){
                //Gialla dark
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 237/255, green: 185/255, blue: 51/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 207/255, green: 174/255, blue: 105/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }else{
                //Verde dark
                var coloreArray = Array<Color>.init()
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 27/255, green: 91/255, blue: 15/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 93/255, green: 143/255, blue: 77/255, opacity: 1.0))
                gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
            }
        }

        return gradienteScheda

    }
}


class valigiaDaRiempire: Identifiable{
    var id: UUID
    var nomeValigia: String
    var volumeAttuale: Int
    var volumeMassimo: Int
    var pesoAttuale: Int
    var pesoMassimo: Int
    var oggettiInseriti: [OggettoViaggiante]
    
    
    init(valigiaDaAggiungere: ValigiaViaggiante){
        self.id = UUID()
        self.nomeValigia = (valigiaDaAggiungere.valigiaRef?.nome)!
        self.volumeAttuale = 0
        self.volumeMassimo = Int(valigiaDaAggiungere.valigiaRef!.volume)
        self.pesoAttuale = 0
        self.pesoMassimo = Int(valigiaDaAggiungere.valigiaRef!.tara) //qui ci dovrà andare peso
        self.oggettiInseriti = []
    }
    
    init(nomeValigiaExtra: String){
        self.id = UUID()
        self.nomeValigia = nomeValigiaExtra
        self.volumeAttuale = 0
        self.volumeMassimo = 0
        self.pesoAttuale = 0
        self.pesoMassimo = 0
        self.oggettiInseriti = []
    }
    
    func aggiungiOggettoAValigia(oggettoSingolo: OggettoViaggiante){
        self.oggettiInseriti.append(oggettoSingolo)
    }
}



struct leMieValigie{
    
    var oggettiDaAllocare: [OggettoViaggiante]
    
    var tutteLeValigie: [valigiaDaRiempire]
    
    init(valigieViaggianti: [ValigiaViaggiante], oggettiViaggianti: [OggettoViaggiante]){
        self.tutteLeValigie = []
        self.tutteLeValigie.append(valigiaDaRiempire.init(nomeValigiaExtra: "Non allocati"))
        for singolaValigia in valigieViaggianti{
            tutteLeValigie.append(valigiaDaRiempire.init(valigiaDaAggiungere: singolaValigia))
        }
        
        
        
        self.oggettiDaAllocare = oggettiViaggianti
        
        //Qui andrebbe ordinato il vettore oggettiDaAllocare in ordine di peso o di volume
        
        while (oggettiDaAllocare.isEmpty == false){
            
            var temp = (oggettiDaAllocare.popLast(),false)
            
            for valigiaAttuale in tutteLeValigie{
                if(temp.1 == false){
                    //Attualmente l'algoritmo implementato si basa solo ed unicamente sul peso va implementato anche sul volume
                    if((valigiaAttuale.pesoAttuale + Int(temp.0!.oggettoRef!.peso)) <= valigiaAttuale.pesoMassimo){
                        valigiaAttuale.oggettiInseriti.append(temp.0!)
                        valigiaAttuale.pesoAttuale += Int(temp.0!.oggettoRef!.peso)
                        temp.1 = true
                    }
                }
            }
            if(temp.1 == false){
                tutteLeValigie[0].oggettiInseriti.append(temp.0!)
                tutteLeValigie[0].pesoAttuale += Int(temp.0!.oggettoRef!.peso)
                temp.1 = true
            }
            
        }
        
    }
}

struct DetailTripView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTripView(viaggio: PersistenceManager.shared.loadAllViaggi()[0])
            .previewDevice("iPhone 11")
    }
}
