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
                NavigationLink(destination: AddTripView(viaggio: viaggio)){
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
                
                NavigationLink(destination: AddBagView(viaggio: viaggio)){
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
            
            
            //            ForEach(PersistenceManager.shared.loadAllOggettiViaggianti()){
            //                oggettino in
            //                Text((oggettino.oggettoRef?.nome)!)
            //            }
            //            ForEach(PersistenceManager.shared.loadAllValigieViaggianti()){
            //                valigetta in
            //                Text((valigetta.valigiaRef?.nome)!)
            //            }
            
            
            ScrollView(.vertical){
                let valigieDB = PersistenceManager.shared.loadAllValigieViaggianti()
                let oggettiDB = PersistenceManager.shared.loadAllOggettiViaggianti()
                let insiemeDiValigie = leMieValigie.init(valigieViaggianti: valigieDB, oggettiViaggianti: oggettiDB)
                
                ForEach(insiemeDiValigie.tutteLeValigie){
                    singolaIstanza in
                    
                    
                    
//                    if(singolaIstanza.pesoAttuale > singolaIstanza.pesoMassimo){
//                        coloreScehda = Color.red.opacity(0.6)
//                    }
                    
                    VStack{
                        HStack{
                            Text(singolaIstanza.nomeValigia)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.blue)
                                
                            Spacer()
                            VStack(alignment: .trailing){
                                Text("Ingombro Occupato: \(singolaIstanza.volumeAttuale) di \(singolaIstanza.volumeMassimo)")
                                    .font(.caption)
                                Text("Peso Occupato: \(singolaIstanza.pesoAttuale) di \(singolaIstanza.pesoMassimo)")
                                    .font(.caption)
                            }
                        }
                        ForEach(singolaIstanza.oggettiInseriti){
                            singoloOggetto in
                            Text("\((singoloOggetto.oggettoRef?.nome)!): \((singoloOggetto.oggettoRef?.peso)!)")
                                .font(.body)
                            
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.6))
                    .cornerRadius(15)
                    
                    
                    
                }
                
            }
            Spacer()
        }
        .padding()
        
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viaggio.nome ?? "Nome viaggio")
        
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
                    if((valigiaAttuale.pesoAttuale + Int(temp.0!.oggettoRef!.peso)) < valigiaAttuale.pesoMassimo){
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
