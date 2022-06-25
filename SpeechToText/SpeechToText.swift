//
//  SpeechToText.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 01/06/22.
//

import Foundation
import SwiftUI
import Foundation
import Speech

public class SpeechToText: ObservableObject{
    
    // ATTRIBUTI
    lazy var viaggioNome : String = ""
    
    private var task: SFSpeechRecognitionTask?
    // task che determina lo stato del task di riconoscimento della voce, cancella un task in corso, o segnala la fine di un task
    
    public var text: String = ""
    // Stringa che corrisponde al testo riconosciuto
    
    private let audioEngine = AVAudioEngine()
    // un audio engine contiene un gruppo di nodi che si occupano di generare e processare segnali audio
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    // richiesta di riconoscere il testo da un contenuto audio, come nel caso dell'audio proveniente dal microfono del dispositivo
    
    private let speechRecognizerIT = SFSpeechRecognizer(locale: Locale(identifier: "it-IT"))
//    private let speechRecognizerEN = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    private let authStat = SFSpeechRecognizer.authorizationStatus()
    
    @Published var isRecording:Bool = false
    @Published var button = SpeechToTextButton()
    
    // INIT
    
    init(){
        // inizializzo la classe richiedendo le autorizzazioni all'utente
        SFSpeechRecognizer.requestAuthorization{ statoAutorizzazione in
            // Lo stato dell'autorizzazione si mostra sulla pagina principale dell'app,
            // quindi il processo viene eseguito nella queue principale dell'app.
            OperationQueue.main.addOperation {
                switch statoAutorizzazione {
                    case .notDetermined:
                        break
                    case .denied:
                        break
                    case .restricted:
                        break
                    case .authorized:
                        break
                    default:
                        break
                }
            }
        }
        
        // inizializzo il recognition task
        task?.cancel()
        self.task = nil
        
    }
    
    func getButton(viaggioNome: String) -> SpeechToTextButton{
        self.viaggioNome = viaggioNome
        return button
    }
    
    
    // INIZIA LA SEQUENZA DI REGISTRAZIONE
    func startRecording(){
        
        // reinizializza il testo
        text=""
        
        // istanzio un oggetto della classe AVAudioSession per comunicare al sistema operativo la modalità di utilizzo dell'audio nell'app
        let sessioneAudio = AVAudioSession.sharedInstance() // restituisce il singleton
        // creazione di un nodo di input
        let inputNode = audioEngine.inputNode // capire cosa è e cosa fa
        
        do{
            try sessioneAudio.setCategory(.record, mode: .measurement, options: .duckOthers)
            // • .record -> setta la categoria della sessione audio in modalità registrazione
            // • .measurement -> indica che l'applicazione sta registrando l'audio di input o di output
            // • .duckOthers -> riduce il volume di altre sessioni audio mentre questa è in esecuzione
            
            try sessioneAudio.setActive(true, options: .notifyOthersOnDeactivation)
            // avvia la sessione audio e notifica alle app interrortte, che l'interruzione è conclusa
            
        }catch{
            print("Errore - Non è stato possibile configurare e avviare la sessione audio!")
        }
        
        // Configurazione del microfono come input e richiede l'autorizzazione
        
        // prendo il formato di output del nodo di input sul bus 0
        let format = inputNode.outputFormat(forBus: 0)
        
        // creo un tap per registrare/monitorare/osservare l'output di un nodo <- capire cos'è un tap
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { (buffer:
            AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do{
            try audioEngine.start()
        }catch{
            print("Errore - Non è stato possibile avviare l'Audio Engine!")
        }
        
        // Creo e configuro la richiesta di riconoscimento della voce
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Impossibile creare un oggetto di tipo SFSpeechAudioBufferRecognitionRequest!") }
        recognitionRequest.shouldReportPartialResults = true
        
        // creo un task per la sessione di riconoscimento della voce
        task = speechRecognizerIT?.recognitionTask(with: recognitionRequest){ result, error in
            if (result != nil){
                self.text = (result?.transcriptions[0].formattedString)!
            }
            if let result = result{
                // aggiorno la stringa con i risultati ottenuti
                self.text = result.transcriptions[0].formattedString
            }
            if error != nil {
                // stoppo il riconoscimento dell'audio se sorge un problema
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.task = nil
                
            }
        }
        
//        task = speechRecognizerEN?.recognitionTask(with: recognitionRequest){ result, error in
//            if (result != nil){
//                self.text = (result?.transcriptions[0].formattedString)!
//            }
//            if let result = result{
//                // aggiorno la stringa con i risultati ottenuti
//                self.text = result.transcriptions[0].formattedString
//            }
//            if error != nil {
//                // stoppo il riconoscimento dell'audio se sorge un problema
//                self.audioEngine.stop()
//                inputNode.removeTap(onBus: 0)
//                self.recognitionRequest = nil
//                self.task = nil
//
//            }
//        }
        
        
    }
    
    func stopRecording(){// end recording
        
        audioEngine.stop()
        recognitionRequest?.endAudio()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.task?.cancel()
        self.task = nil
        
    }// restarts the variables
    
    func getSpeechStatus()->String{// gets the status of authorization
        
        switch authStat{
            
            case .authorized:
                return "Authorized"
            
            case .notDetermined:
                return "Not yet Determined"
            
            case .denied:
                return "Denied - Close the App"
            
            case .restricted:
                return "Restricted - Close the App"
            
            default:
                return "ERROR: No Status Defined"
    
        }// end of switch
        
    }
    
    func setTextIntoBox(text: String){
        self.text = text
    }
    
}
