//
//  DecodeInput.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 12/06/22.
//

import Foundation

public class DecodeInput {
    
    public static var oggetti = [(name:String, category:String)]()
    
    public func searchIntoCollection(){
        DecodeInput.oggetti.removeAll()
        let allObjects = PersistenceManager.shared.loadAllOggetti()
        allObjects.forEach{ object in
            DecodeInput.oggetti.append((name: object.nome!, category:object.categoria!))
        }
    }
    
    public func decode(text: String, viaggioNome: String) -> Bool {
        searchIntoCollection()
        // permette di splittare una stringa ed inserire le parole di cui è composta
        // in un array
        let testoInserito : [String] = text.components(separatedBy: " ")
        var done = false
        switch testoInserito[0].lowercased() {
        case "aggiungi":
            for item in DecodeInput.oggetti {
                var i = 0
                for str in testoInserito {
                    if (i != 0){
                        if(str.lowercased() == item.name.lowercased()){
                            let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                            let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
                            PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                            done = true
                        }
                    }
                    i += 1
                }
            }
        case "rimuovi":
            for item in DecodeInput.oggetti {
                var i = 0
                for str in testoInserito {
                    if (i != 0){
                        if(str.lowercased() == item.name.lowercased()){
                            let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                            let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
                            PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
                            done = true
                        }
                    }
                    i += 1
                }
            }
        default:
            print("oggetto non identificato")
            done = false
        }
        
//        // vecchia versione
//        for item in DecodeInput.oggetti {
//            if(text.lowercased() == "aggiungi \(item.name.lowercased())"){
//                let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
//                let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
//                PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
//                return true
//            }
//        }
        return done
    }
    
}
