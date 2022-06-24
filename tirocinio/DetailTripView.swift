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
    @EnvironmentObject var speech : SpeechToText
    
    var body: some View {
        
        let numValigieDiSistema: Int = PersistenceManager.shared.loadValigieFromCategoria(categoria: "0SYSTEM").count
        VStack{
            if(((valigieDB.count - numValigieDiSistema) != 0) && (calculateNumberOggetti(oggettiviaggianti: oggettiDB) != 0)){
                VStack{
                    ScrollView(.vertical, showsIndicators: false){
                        
                        VStack{
                            
                            tastiDiAggiunta(valigieDB: $valigieDB, oggettiDB: $oggettiDB, viaggio: viaggio)
                            
                            ForEach(valigieDB){
                                singolaIstanza in
                                
                                
                                singolaValigiaView(singolaIstanza: singolaIstanza, viaggio: viaggio)
                                
                            }
                        }
                        Spacer()
                        
                        
                    }
                    VStack{
                        Text("\(speech.text)")
                            .font(.title)
                            .bold()
                        speech.getButton(viaggioNome: self.viaggio.nome!)
                    }
                    
                    Spacer(minLength: 30)
                }
            }else{
                tastiSenzaValigie(valigieDB: $valigieDB, oggettiDB: $oggettiDB, viaggio: viaggio)
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
            speech.text = ""
        
            valigieDB = PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio).sorted(by: { lhs, rhs in
                return lhs.valigiaRef!.categoria! < rhs.valigiaRef!.categoria!
            })
            oggettiDB = PersistenceManager.shared.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio)
            
            PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)//ANDRA NEL PULSANTE SALVA
        }
        
        .navigationTitle(viaggio.nome ?? "Nome viaggio")
        
        
    }
    
    func calculateNumberOggetti(oggettiviaggianti: [OggettoViaggiante]) -> Int{
        var sum: Int = 0
        for i in oggettiviaggianti.map({$0.quantitaInViaggio}){
            sum += Int(i)
        }
        
        return sum
    }
}


struct tastiSenzaValigie: View{
    
    @Binding var valigieDB: [ValigiaViaggiante]
    @Binding var oggettiDB: [OggettoViaggiante]
    
    var viaggio: Viaggio
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var volumePeso: Bool = false
    @EnvironmentObject var speech : SpeechToText
    
    init(valigieDB: Binding<[ValigiaViaggiante]>, oggettiDB: Binding<[OggettoViaggiante]>, viaggio: Viaggio){
        self._valigieDB = valigieDB
        self._oggettiDB = oggettiDB
        self.viaggio = viaggio
    }
    
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
            }
            
            NavigationLink(destination:  AddTripView(viaggio: viaggio)){
                VStack{
                    if(calculateNumberOggetti(oggettiviaggianti: oggettiDB) <= 0){
                        Text("Per iniziare aggiungi almeno un oggetto")
                        //                        .foregroundColor(.blue)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                    }else{
                        Text("Aggiungi Oggetti")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                    }
                    
                    //                    Text("Oggetti presenti: \(oggettiDB.count)")
                    Text("Oggetti presenti: \(calculateNumberOggetti(oggettiviaggianti: oggettiDB))")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Image(systemName: "archivebox.fill")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                        .padding(.top, 1.0)
                }
               
            }
            .padding()
            .frame(width: 300, height: 200, alignment: .center)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.4), radius: 10, y: 5)
            
            
            Spacer()
            
            
            NavigationLink(destination:  AddBagView(viaggio: viaggio)){
                VStack{
                    let numValigieDiSistema: Int = PersistenceManager.shared.loadValigieFromCategoria(categoria: "0SYSTEM").count
                    if(valigieDB.count - numValigieDiSistema <= 0){
                        Text("Per iniziare aggiungi almeno una valigia")
                        //                        .foregroundColor(.blue)
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                    }else{
                        Text("Aggiungi Valigie")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                    }
                    
                    Text("Valigie presenti: \(valigieDB.count - numValigieDiSistema)")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Image(systemName: "suitcase.fill")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                        .padding(.top, 1.0)
                    
                    
                }
                
            }
            .padding()
            .frame(width: 300, height: 200, alignment: .center)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.4), radius: 10, y: 5)
            
            Spacer()
            VStack{
                Text("\(speech.text)")
                    .font(.title)
                    .bold()
                speech.getButton(viaggioNome: self.viaggio.nome!)
            }
            Spacer()
        }
    }
    
    func calculateNumberOggetti(oggettiviaggianti: [OggettoViaggiante]) -> Int{
        var sum: Int = 0
        for i in oggettiviaggianti.map({$0.quantitaInViaggio}){
            sum += Int(i)
        }
        
        return sum
    }
}

struct tastiDiAggiunta: View{
    
    @Binding var valigieDB: [ValigiaViaggiante]
    @Binding var oggettiDB: [OggettoViaggiante]
    var viaggio: Viaggio
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingAlertOggetti = false
    @State private var showingAlertValigie = false
    @State var volumePeso: Bool = false
    
    init(valigieDB: Binding<[ValigiaViaggiante]>, oggettiDB: Binding<[OggettoViaggiante]>, viaggio: Viaggio){
        self._valigieDB = valigieDB
        self._oggettiDB = oggettiDB
        self.viaggio = viaggio
    }
    
    func calculateNumberOggetti(oggettiviaggianti: [OggettoViaggiante]) -> Int{
        var sum: Int = 0
        for i in oggettiviaggianti.map({$0.quantitaInViaggio}){
            sum += Int(i)
        }
        
        return sum
    }
    
    
    var body: some View{
        
        HStack{
            Spacer()
            
            VStack{
                Text("Aggiungi Oggetti")
                    .multilineTextAlignment(.center)
                
                //                    Text("Oggetti presenti: \(oggettiDB.count)")
                Text("Oggetti presenti: \(calculateNumberOggetti(oggettiviaggianti: oggettiDB))")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Image(systemName: "archivebox.fill")
                    .padding(.top, 1.0)
            }
            .padding()
            .frame(minWidth: 150, maxWidth: 150, minHeight: 80)
            
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .overlay(){
                NavigationLink(destination:  AddTripView(viaggio: viaggio)){
                    Rectangle()
                        .background(Color.white)
                        .opacity(0.1)
                    //                            .frame(width: 150)
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
                    //                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            Spacer()
            
            
            
            VStack{
                let numValigieDiSistema: Int = PersistenceManager.shared.loadValigieFromCategoria(categoria: "0SYSTEM").count
                Text("Aggiungi Valigie")
                    .multilineTextAlignment(.center)
                Text("Valigie presenti: \(valigieDB.count - numValigieDiSistema)")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Image(systemName: "suitcase.fill")
                    .padding(.top, 1.0)
                
            }
            .padding()
            .frame(minWidth: 150, maxWidth: 150, minHeight: 80)
            .background(colorScheme == .dark ? Color.init(white: 0.2) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .overlay(){
                NavigationLink(destination:  AddBagView(viaggio: viaggio)){
                    Rectangle()
                        .background(Color.white)
                        .opacity(0.1)
                    //                            .frame(width: 150)
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
                    //                    presentationMode.wrappedValue.dismiss()
                    valigieDB.removeAll()
                    valigieDB.append(PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio)[0]) //per ipotesi l'unica valigia rimasta è quella dei non
                    PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
                    
                }
            }
            
            
            Spacer()
        }
        
        
        HStack{
            Toggle(isOn: $volumePeso){
                Text("Usa i limiti di peso")
                    .font(.title2.bold())
            }
            .onChange(of: volumePeso){ value in
                viaggio.allocaPer = value
                PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: value)
            }
            
            .toggleStyle(.switch)
            //            .tint(.mint)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(colorScheme == .dark ? Color.init(white: 0.1) : Color.init(white: 1.0))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            //            .cornerRadius(10)
            //            .shadow(color: Color.black.opacity(0.4), radius: 1, x: 1, y: 1)
            .padding(.horizontal, 20)
            .padding(.vertical)
            
            
        }
        .onAppear{
            self.volumePeso = self.viaggio.allocaPer
        }
        
        
        
    }
    
    
    
}


struct singolaValigiaView: View{
    
    @ObservedObject var singolaIstanza: ValigiaViaggiante
    var viaggio: Viaggio
    @Environment(\.colorScheme) var colorScheme
    @State var visualizzaOggetti: Bool = false
    
    var body: some View{
        
        if(singolaIstanza.contenuto.array(of: OggettoInValigia.self).isEmpty == false){
            
            Spacer()
            VStack{
                HStack{
                    Button(action: {
                        visualizzaOggetti.toggle()
                    }){
                        HStack{
                            if (visualizzaOggetti){
                                Image(systemName: "arrowtriangle.down.fill")
                            }else{
                                Image(systemName: "arrowtriangle.forward.fill")
                            }
                            Text("\((singolaIstanza.valigiaRef?.nome)!)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        //la card ha una visualizzazione distinta nel caso di valigia di sistema. non mostra i valori massimo poiché è solo una valigia logica
                        if singolaIstanza.valigiaRef?.categoria == "0SYSTEM"{
                            Text("Ingombro Occupato: \(singolaIstanza.volumeAttuale/1000)l")
                                .font(.caption)
                            Text("Peso Occupato: \(singolaIstanza.pesoAttuale)g")
                                .font(.caption)
                        }else{
                            Text("Ingombro Occupato: \(singolaIstanza.volumeAttuale/1000)l di \(singolaIstanza.volumeMassimo/1000)l")
                                .font(.caption)
                            if(singolaIstanza.pesoMassimo < Int32.max){
                                Text("Peso Occupato: \(singolaIstanza.pesoAttuale)g di \(singolaIstanza.pesoMassimo)g")
                                    .font(.caption)
                            }else{
                                Text("Peso Occupato: \(singolaIstanza.pesoAttuale)g di ∞")
                                    .font(.caption)
                            }
                            
                        }
                        
                        
                    }
                }
                .padding(.bottom)
                
                
                if (visualizzaOggetti){
                    ForEach(singolaIstanza.contenuto.array(of: OggettoInValigia.self).sorted(by: { rhs, lhs in
                        return rhs.oggettoViaggianteRef!.oggettoRef!.nome! < lhs.oggettoViaggianteRef!.oggettoRef!.nome!
                    })){
                        oggetto in
                        
                        HStack{
                            
                            Text("\(oggetto.quantitaInValigia)")
                            Text(oggetto.oggettoViaggianteRef?.oggettoRef?.nome ?? "Nome non trovato")
                            Spacer()
                            
                        }
                        .padding(8)
                        .background(colorScheme == .dark ? Color.init(white: 0.1,opacity: 0.4) : Color.init(white: 0.9,opacity: 0.4))
                        .cornerRadius(10)
                        
                        
                    }
                }
                
                
                
                
                //                }
                Spacer()
            }
            .padding()
            .background(coloreScelto(valigia: singolaIstanza, volumeOPeso: viaggio.allocaPer))
            .cornerRadius(10)
            
        }
        
    }
    
    private func  coloreScelto(valigia: ValigiaViaggiante, volumeOPeso: Bool) -> LinearGradient{
        
        var gradienteScheda: LinearGradient = LinearGradient(colors: [Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
        
        let inizio = UnitPoint.bottom
        let fine = UnitPoint.top
        
        if (volumeOPeso == false){ //Caso di ordinare per volume
            if(String("\(colorScheme)") == "light"){
                if(valigia.volumeAttuale > valigia.volumeMassimo){
                    //Rossa light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 208/255, green: 24/255, blue: 24/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 212/255, green: 105/255, blue: 105/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.volumeAttuale) > Double(valigia.volumeMassimo) * 0.9){
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
                if(valigia.volumeAttuale > valigia.volumeMassimo){
                    //Rossa dark
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 119/255, green: 17/255, blue: 17/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 161/255, green: 22/255, blue: 22/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.volumeAttuale) > Double(valigia.volumeMassimo) * 0.9){
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
        }else{ //Caso di ordinare per peso
            if(String("\(colorScheme)") == "light"){
                if(valigia.pesoAttuale > valigia.pesoMassimo || valigia.volumeAttuale > valigia.volumeMassimo){
                    //Rossa light
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 208/255, green: 24/255, blue: 24/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 212/255, green: 105/255, blue: 105/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.pesoAttuale) > Double(valigia.pesoMassimo) * 0.9 || Double(valigia.volumeAttuale) > Double(valigia.volumeMassimo) * 0.9){
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
                if(valigia.pesoAttuale > valigia.pesoMassimo || valigia.volumeAttuale > valigia.volumeMassimo){
                    //Rossa dark
                    var coloreArray = Array<Color>.init()
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 119/255, green: 17/255, blue: 17/255, opacity: 1.0))
                    coloreArray.append(Color.init(Color.RGBColorSpace.sRGB, red: 161/255, green: 22/255, blue: 22/255, opacity: 1.0))
                    gradienteScheda = LinearGradient(colors: coloreArray, startPoint: inizio, endPoint: fine)
                }else if(Double(valigia.pesoAttuale) > Double(valigia.pesoMassimo) * 0.9 || Double(valigia.volumeAttuale) > Double(valigia.volumeMassimo) * 0.9){
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
        }
        
        
        
        
        return gradienteScheda
        
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
