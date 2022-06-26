//
//  DetailTripView.swift
//  ValigieSmart
//
//  Created by Salvatore Apicella on 25/04/22.
//

import SwiftUI

class ValigieStore: ObservableObject{
    @Published var valigieDB: [ValigiaViaggiante] = []
}

class OggettiStore: ObservableObject{
    @Published var oggettiDB: [OggettoViaggiante] = []
}

struct DettagliViaggioView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var vStore: ValigieStore = ValigieStore()
    @StateObject var oStore: OggettiStore = OggettiStore()
    
    @EnvironmentObject var speech : SpeechToText
    
    var viaggio: Viaggio
    
    var body: some View {
        
        VStack{
            VStack{
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack{
                        BottoneCardView(vStore: vStore, oStore: oStore, viaggio: viaggio)
                        ForEach(vStore.valigieDB){ singolaIstanza in
                            ValigiaRiempitaCardView(singolaIstanza: singolaIstanza, viaggio: viaggio)
                        }
                    }
                    Spacer()
                }
                VStack{
                    Text(speech.text)
                    speech.getButton(viaggioNome: self.viaggio.nome!)
                        .environmentObject(vStore)
                        .environmentObject(oStore)
                }
                Spacer(minLength: 30)
            }
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.large)
        .background{
            if(String("\(colorScheme)") == "light"){
                Image("Sfondo App 2Light")
                    .resizable()
                    .ignoresSafeArea()
            }else{
                Image("Sfondo App 2Dark")
                    .resizable()
                    .ignoresSafeArea()
            }
        }
        .onAppear(){
            speech.text = ""
            vStore.valigieDB = PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio).sorted(by: { lhs, rhs in
                return lhs.valigiaRef!.categoria! < rhs.valigiaRef!.categoria!
            })
            oStore.oggettiDB = PersistenceManager.shared.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio)
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


