//
//  DecodeInput.swift
//  tirocinio
//
//  Created by Grazia Ferrara on 12/06/22.
//

import Foundation

public class DecodeInput {
    
    public static var oggetti = [(name:String, category:String)]()
    public static var valigie = [(name:String, category:String)]()
    
    public func searchIntoCollection(){
        DecodeInput.oggetti.removeAll()
        let allObjects = PersistenceManager.shared.loadAllOggetti()
        allObjects.forEach{ object in
            DecodeInput.oggetti.append((name: object.nome!, category:object.categoria!))
        }
    }
    
    public func searchIntoCloset(){
        DecodeInput.valigie.removeAll()
        let allCases = PersistenceManager.shared.loadAllValigie()
        allCases.forEach{ c in
            DecodeInput.valigie.append((name: c.nome!, category: c.categoria!))
        }
    }
    
    public func decode(text: String, viaggioNome: String) -> Bool {
        
        // metto tutti gli oggetti disponibili all'interno dell'array oggetti
        searchIntoCollection()
        searchIntoCloset()
        
        // permette di splittare una stringa ed inserire le parole di cui è composta
        // all'interno di un array
        var azione : String = text.components(separatedBy: " ")[0].lowercased()
        var done = false
        let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
        
        // interpretazione dell'azione
        azione = checkAction(action: azione)
        
        // verifico l'azione da compiere
        switch azione {
            
            case "aggiungi":
                
                // verifico se l'oggetto da inserire è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    if(text.lowercased().contains(item.name.lowercased())){
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                        done = true
                    }
                }
            
                // se non sono stati trovati oggetti verifico se si tratta di una valigia da inserire
                for c in DecodeInput.valigie {
                    if(text.lowercased().contains(c.name.lowercased())){
                        let valigia = PersistenceManager.shared.loadValigieFromNomeCategoria(nome: c.name, categoria: c.category)[0]
                        let pesoMassimo = getPesoMassimo(input: text.lowercased(), name: c.name, category: c.category)
                        print(pesoMassimo)
                        PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio, pesoMassimo: pesoMassimo)
                        done = true
                    }
                }
            
                
            case "rimuovi":
                
                // verifico se l'oggetto da eliminare è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    if(text.lowercased().contains(item.name.lowercased())){
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        let ov  = PersistenceManager.shared.loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: oggetto, viaggioRef: viaggio)[0]
                        ov.quantitaInViaggio -= 1
                        ov.quantitaAllocata -= 1
                        if ov.quantitaInViaggio == 0{
                            PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)
                        }
                        done = true
                    }
                }
            
                // se non sono stati trovati oggetti, verifico se si tratta di una valigia da eliminare
                for c in DecodeInput.valigie {
                    if(text.lowercased().contains(c.name.lowercased())){
                        let valigiaViagg = PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio)
                        for val in valigiaViagg{
                            if(val.valigiaRef!.nome!.lowercased() == c.name.lowercased()){
                                PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: val.valigiaRef!)
                                done = true
                                break
                            }
                        }
                    }
                }
            
                
            default:
            
                // l'azione da compiere non è aggiunta o rimozione di oggetti / valigie
                done = false
            
        }
        
        return done
    }
    
    // funzione che prende l'azione dall'input dell'utente e la decodifica in modo univoco
    public func checkAction(action: String) -> String {
        
        var azione = ""
        
        if (action ~= "mett[a-z]*" || action ~= "agg[a-z]*" || action ~= "ins[a-z]*"){
            azione = "aggiungi"
            
        }else if (action ~= "rim[a-z]*" || action ~= "togl[a-z]*" || action ~= "elim[a-z]*"){
            azione = "rimuovi"
        }

        return azione
    }
    
    // funzione che restituisce il peso massimo della valigia viaggiante da inserire
    public func getPesoMassimo(input: String, name: String, category: String) -> Int {
        
        var peso: Int
        
        // cerco il peso della valigia all'interno della stringa inserita
        
        
        // se non è presente alcun numero restituisco un valore di default in base alla categoria della valigia
        switch category {
            case "trolley":
                peso = 10
            case "bagaglio da stiva":
                peso = 23
            case "piccola":
                peso = 10
            case "zaino":
                peso = 6
            default:
                // altro
                peso = 10
        }
        
        return peso
    }
    
    let numbers:[Int:String] = [1:"uno", 2:"due", 3:"tre", 4:"quattro", 5:"cinque",
                               6:"sei", 7:"sette", 8:"otto", 9:"nove", 10:"dieci",
                               11:"undici", 12:"dodici", 13:"tredici", 14:"quattordici", 15:"quindici",
                               16:"sedici", 17:"diciassette", 18:"diciotto", 19:"diciannove", 20:"venti",
                               21:"ventuno", 22:"ventidue", 23:"ventitré", 24:"ventiquattro", 25:"venticinque",
                               26:"ventisei", 27:"ventisette", 28:"ventotto", 29:"ventinove", 30:"trenta"]
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
