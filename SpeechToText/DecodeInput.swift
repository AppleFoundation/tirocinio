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
    public static var valigieUsate : [String] = []
    
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
            var rep : Int
                
                // verifico se l'oggetto da inserire è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    
                    if(text.lowercased().contains(item.name.lowercased())){
                        
                        rep = getOccurrences(input: text, name: item.name.lowercased())
                        
                        for i in 1...rep{
                            let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                            PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                        }
                        
                    }
                    
                    done = true
                    
                }
            
                // se non sono stati trovati oggetti verifico se si tratta di una valigia da inserire
                for c in DecodeInput.valigie {
                    if(text.lowercased().contains(c.name.lowercased())){
                        
                        rep = contaOccorrenze(input: text.lowercased(), name: c.name.lowercased())
                        
                        for i in 1...rep{
                            let valigia = PersistenceManager.shared.loadValigieFromNomeCategoria(nome: c.name, categoria: c.category)[0]

                            DecodeInput.valigieUsate.append(valigia.nome!)
                            let pesoMassimo = getPesoMassimo(input: text.lowercased(), name: c.name, category: c.category)
                            
                            PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio, pesoMassimo: pesoMassimo)
    
                        }
                        
                        done = true
                    }
                }
                
            PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
            DecodeInput.valigieUsate.removeAll()
                
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
            
            PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
            
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
        
        var peso = 0
        var countOcc = 0
        
        for conta in DecodeInput.valigieUsate{
            if(conta == name){
                countOcc += 1
            }
        }
        
        print(countOcc)
        
        // cerco il peso della valigia all'interno della stringa inserita
        // countOcc, se diverso da 0, contiene il numero di occorrenze del nome della valigia da skippare prima di prendere il peso
        let inputArray = input.components(separatedBy: " ")
        
        var i = 0, c = 0
        for item in inputArray {
            
            if (item.lowercased() == name.lowercased()){
                c += 1
            }
            
            if (item.lowercased() == name.lowercased() && c == countOcc){
                // valigia di cui prendere il peso
                
                for k in i...inputArray.count-1 {
                    if inputArray[k].lowercased() == "kg" {
                        
                        if(inputArray[k-1] ~= "[0-9]{2}"){
                            // il peso è scritto a numero
                            return Int(inputArray[k-1])!

                        }
                    }
                }
                
            }

            i = i + 1
            
        }
        
        if peso == 0{
            // se non è presente alcun numero restituisco un valore di default
            peso = Int(Int32.max)
        }
        
        return peso
    }
    
    public func getOccurrences(input: String, name: String) -> Int {
        
        var i = 0
        
        let inputArray = input.components(separatedBy: " ")
        
        for item in inputArray {
            
            print(item)
            
            if (item.lowercased() == name.lowercased() && i != 0){
                
                if(inputArray[i-1].lowercased() ~= "[a-z]*"){
                    
                    for (key, value) in numbers {
                        if (value == inputArray[i-1].lowercased()){
                            return key
                        }
                    }
                    
                }
                
            }
            
            i += 1
            
        }
        
        return 1
        
    }
    
    func contaOccorrenze (input: String, name: String) -> Int {
        
        let inputArray = input.components(separatedBy: " ")
        var conta = 0
        for i in inputArray{
            if i.lowercased() == name.lowercased() {
                conta += 1
            }
        }
        return conta
        
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

extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
