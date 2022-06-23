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
        
        // metto tutti gli oggetti disponibili all'interno dell'array oggetti
        searchIntoCollection()
        
        // permette di splittare una stringa ed inserire le parole di cui è composta
        // all'interno di un array
        var azione : String = text.components(separatedBy: " ")[0].lowercased()
        var done = false
        
        // interpretazione dell'azione
        azione = checkAction(action: azione)
        print(azione)
        
        // verifico l'azione da compiere
        switch azione {
            
            case "aggiungi":
                
                // verifico se l'oggetto da inserire è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    if(text.lowercased().contains(item.name.lowercased())){
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
                        PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                        done = true
                    }
                }
            
                // se non sono stati trovati oggetti verifico se si tratta di una valigia da inserire
                
            case "rimuovi":
                
                // verifico se l'oggetto da eliminare è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    if(text.lowercased().contains(item.name.lowercased())){
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
                        PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
                        done = true
                    }
                }
            
                // se non sono stati trovati oggetti, verifico se si tratta di una valigia da eliminare
            
                
            default:
            
                // l'azione da compiere non è aggiunta o rimozione di oggetti / valigie
                done = false
            
        }
        
        return done
    }
    
    // funzione che prende l'azione dall'input dell'utente e la decodifica in modo univoco
    public func checkAction(action: String) -> String {
        
        var azione = ""
        
        print("-----------------------------Mi hanno dato \(action)-------------------------------")
        
        if (action ~= "mett[a-z]*" || action ~= "agg[a-z]*" || action ~= "ins[a-z]*"){
            azione = "aggiungi"
            
        }else if (action ~= "rim[a-z]*" || action ~= "togl[a-z]*" || action ~= "elim[a-z]*"){
            azione = "rimuovi"
        }

        print("-----------------------------Restituisco \(azione)---------------------------------")
        return azione
    }
    
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
