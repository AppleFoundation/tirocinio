//
//  SpeechToTextButton.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 12/06/22.
//

import SwiftUI

struct SpeechToTextButton: View {
    
    @EnvironmentObject var speech: SpeechToText
    @EnvironmentObject var vStore: ValigieStore
    @EnvironmentObject var oStore: OggettiStore
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var message = ""
    @State private var showingAlert = false
    
    var input = DecodeInput()
    
    var body: some View {
        Button(action: {
            if(self.speech.getSpeechStatus() == "Denied - Close the App"){
                
                // show popup error
                
            }else{
                withAnimation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3)){
                    self.speech.isRecording.toggle()
                }
                
                if(self.speech.isRecording){
                    self.speech.startRecording()
                }else{
                    self.speech.stopRecording()
                    
                    // return decoded results
                    let dec = input.decode(text: speech.text, viaggioNome: speech.viaggioNome)
                    
                    // print results into box
                    if(dec.oggettiAggiunti.count>0){
                        message += "Ho aggiunto i seguenti oggetti: "
                        for item in dec.oggettiAggiunti{
                            message += "\(item.1) \(item.0)\n"
                        }
                    }
                    
                    if(dec.oggettiEliminati.count>0){
                        message += "Ho eliminato i seguenti oggetti: "
                        for item in dec.oggettiEliminati{
                            message += "\(item.1) \(item.0)\n"
                        }
                    }
                    
                    if(dec.valigieAggiunte.count>0){
                        message += "Ho aggiunto le seguenti valigie: "
                        for item in dec.valigieAggiunte{
                            message += "\(item.1) \(item.0)\n"
                        }
                    }
                    
                    if(dec.valigieEliminate.count>0){
                        message += "Ho eliminato le seguenti valigie: "
                        for item in dec.valigieEliminate{
                            message += "\(item.1) \(item.0)\n"
                        }
                    }
                    
                    if (dec.oggettiAggiunti.isEmpty && dec.oggettiEliminati.isEmpty && dec.valigieAggiunte.isEmpty && dec.valigieEliminate.isEmpty) {
                        message = "Non ho capito, riprova!"
                    }
                    
                    showingAlert = true
                    
                }
            }
        }, label: {
            Image(systemName: "mic.fill")
                .resizable()
                .frame(width: 30, height: 40)
                .foregroundColor(speech.isRecording ? .white : .blue)
                .background(speech.isRecording ?
                            Circle()
                    .foregroundColor(.red)
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, y: 5)
                            : Circle()
                    .foregroundColor(colorScheme == .dark ? Color.init(white: 0.1764705882) : Color.white)
                    .frame(width: 80, height: 80)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, y: 5)
                )
                
        })
        .alert(message, isPresented: $showingAlert) {
                    Button("OK", role: .cancel) {
                        message = ""

                        let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: speech.viaggioNome)[0]
                        vStore.valigieDB = PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio)
                        oStore.oggettiDB = PersistenceManager.shared.loadOggettiViaggiantiFromViaggio(viaggioRef: viaggio)
                        PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
                    }
                }
    }
    
}

struct SpeechToTextButton_Previews: PreviewProvider {

    static var previews: some View {
        SpeechToTextButton()
    }
}
