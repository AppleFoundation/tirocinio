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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    @State var valigieDB: [ValigiaViaggiante] = []
    @State var oggettiDB: [OggettoViaggiante] = []
    @State var insiemeDiValigie: [ValigiaViaggiante] = []
    
    var body: some View {
        
        
        
        
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                
                VStack{
                    
                    tastiDiAggiunta(valigieDB: valigieDB, oggettiDB: oggettiDB, viaggio: viaggio)
                    
                    ForEach(insiemeDiValigie){
                        singolaIstanza in
                        
//                        Text(singolaIstanza.valigiaRef?.nome ?? "Marameo")
                        
                        singolaValigiaView(singolaIstanza: singolaIstanza)
                        
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
      
        .onAppear(){
            valigieDB = PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio)
            oggettiDB = PersistenceManager.shared.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio)
            insiemeDiValigie = valigieDB
            
            PersistenceManager.shared.allocaOggetti(viaggio: viaggio)//ANDRA NEL PULSANTE SALVA
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


struct tastiDiAggiunta: View{
    
    var valigieDB: [ValigiaViaggiante]
    var oggettiDB: [OggettoViaggiante]
    var viaggio: Viaggio
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingAlertOggetti = false
    @State private var showingAlertValigie = false
    @EnvironmentObject var speech : SpeechToText
    
    var body: some View{
        
        
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
                    presentationMode.wrappedValue.dismiss()
                    
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
                    presentationMode.wrappedValue.dismiss()
                    
                }
            }
            
            
            Spacer()
        }
        
        Spacer(minLength: 30)

        VStack{
            Text("\(speech.text)")
                .font(.title)
                .bold()
            speech.getButton(viaggioNome: self.viaggio.nome!)
        }
            
        Spacer(minLength: 30)
        
    }
    
    
}


struct singolaValigiaView: View{
    
    var singolaIstanza: ValigiaViaggiante
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View{
        
        if(singolaIstanza.contenuto.array(of: OggettoViaggiante.self).isEmpty == false){
            
            Spacer()
            VStack{
                HStack{
                    Text((singolaIstanza.valigiaRef?.nome)!)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("Ingombro Occupato: \(singolaIstanza.volumeAttuale/1000)l di \(singolaIstanza.volumeMassimo/1000)l")
                            .font(.caption)
                        Text("Peso Occupato: \(singolaIstanza.pesoAttuale)g di \(singolaIstanza.pesoMassimo)g")
                            .font(.caption)
                    }
                }
                .padding(.bottom)
                
                
                ForEach(singolaIstanza.contenuto.array(of: OggettoViaggiante.self)){
                    oggetto in
                    
                    HStack{
                        Text(oggetto.oggettoRef?.nome ?? "Nome non trovato")
                        Spacer()
                        
                    }
                    .padding(8)
                    .background(colorScheme == .dark ? Color.init(white: 0.1,opacity: 0.4) : Color.init(white: 0.9,opacity: 0.4))
                    .cornerRadius(10)

                    
                }
                
                
                
                //                }
                Spacer()
            }
            .padding()
            .background(coloreScelto(valigia: singolaIstanza))
            .cornerRadius(10)
            
        }
        
    }
    
    private func  coloreScelto(valigia: ValigiaViaggiante) -> LinearGradient{
        
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
//                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 237/255, green: 185/255, blue: 51/255, opacity: 1.0))
//                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 207/255, green: 174/255, blue: 105/255, opacity: 1.0))
                
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 154/255, green: 93/255, blue: 0/255, opacity: 1.0))
                coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 245/255, green: 197/255, blue: 0/255, opacity: 1.0))
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
    var oggettiConConto: Dictionary<String,(String, Int)>
    
    
    init(valigiaDaAggiungere: ValigiaViaggiante){
        self.id = UUID()
        self.nomeValigia = (valigiaDaAggiungere.valigiaRef?.nome)!
        self.volumeAttuale = 0
        self.volumeMassimo = Int(valigiaDaAggiungere.valigiaRef!.volume)
        self.pesoAttuale = 0
        self.pesoMassimo = Int(valigiaDaAggiungere.valigiaRef!.tara) //qui ci dovrà andare peso
        self.oggettiInseriti = []
        self.oggettiConConto = [:]
    }
    
    init(nomeValigiaExtra: String){
        self.id = UUID()
        self.nomeValigia = nomeValigiaExtra
        self.volumeAttuale = 0
        self.volumeMassimo = 0
        self.pesoAttuale = 0
        self.pesoMassimo = 0
        self.oggettiInseriti = []
        self.oggettiConConto = [:]
    }
    
    func aggiungiOggettoAValigia(oggettoSingolo: OggettoViaggiante){
        self.oggettiInseriti.append(oggettoSingolo)
        var oldValue = self.oggettiConConto.updateValue((oggettoSingolo.oggettoRef!.nome! ,1), forKey: oggettoSingolo.oggettoRef!.nome!)
        if (oldValue != nil){
            oldValue!.1 += 1
            self.oggettiConConto.updateValue(oldValue!, forKey: oggettoSingolo.oggettoRef!.nome!)
        }else{
            oldValue?.1 = 1
        }
        print("Ci sono \(oldValue ?? ("",-1)) pezzi di \(oggettoSingolo.oggettoRef!.nome ?? "Nome")")
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
                        valigiaAttuale.aggiungiOggettoAValigia(oggettoSingolo: temp.0!)
                        valigiaAttuale.pesoAttuale += Int(temp.0!.oggettoRef!.peso)
                        temp.1 = true
                    }
                }
            }
            if(temp.1 == false){
                tutteLeValigie[0].aggiungiOggettoAValigia(oggettoSingolo: temp.0!)
                tutteLeValigie[0].pesoAttuale += Int(temp.0!.oggettoRef!.peso)
                temp.1 = true
            }
            
        }
        
    }
}

extension Optional where Wrapped == NSSet {
    func array<T: Hashable>(of: T.Type) -> [T] {
        if let set = self as? Set<T> {
            return Array(set)
        }
        return [T]()
    }
}
