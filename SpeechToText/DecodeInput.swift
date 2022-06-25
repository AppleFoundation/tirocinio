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
    
    public struct DecodedValues{
        var valigieAggiunte: [(_:String, _:Int)]
        var valigieEliminate: [(_:String, _:Int)]
        var oggettiAggiunti: [(_:String, _:Int)]
        var oggettiEliminati: [(_:String, _:Int)]
    }
    
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
    
    public func decode(text: String, viaggioNome: String) -> DecodedValues {
        
        // metto tutti gli oggetti disponibili all'interno dell'array oggetti
        searchIntoCollection()
        searchIntoCloset()
        
        // permette di splittare una stringa ed inserire le parole di cui è composta
        // all'interno di un array
        var azione : String = text.components(separatedBy: " ")[0].lowercased()
        var rep : Int
        let viaggio = PersistenceManager.shared.loadViaggiFromNome(nome: viaggioNome)[0]
        var decodedValues = DecodedValues(valigieAggiunte: [], valigieEliminate: [], oggettiAggiunti: [], oggettiEliminati: [])
        
        // interpretazione dell'azione
        azione = checkAction(action: azione)
        
        print("----\(text)----")
        
        // verifico l'azione da compiere
        switch azione {
            
            case "aggiungi":
                
                // verifico se l'oggetto da inserire è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    
                    if(text.lowercased().contains(item.name.lowercased())){
                        
                        // quante volte devo inserire l'oggetto trovato
                        rep = getOccurrences(input: text, name: item.name.lowercased())
                        
                        // inserisco tutte le occorrenze dell'oggetto
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        
                        for _ in 1...rep{
                            PersistenceManager.shared.addOggettoViaggiante(oggetto: oggetto, viaggio: viaggio)
                        }
                        
                        decodedValues.oggettiAggiunti.append((item.name, rep))
                    }
                    
                }
            
                // se non sono stati trovati oggetti verifico se si tratta di una valigia da inserire
                for c in DecodeInput.valigie {
                    
                    print(c)
                    
                    if(text.lowercased().contains(c.name.lowercased())){
                        
                        // conto il numero di occorrenze di quella valigia all'interno della stringa di input (più
                        // occorrenze della stessa valigia potrebbero avere pesi massimi diversi)
                        rep = contaOccorrenze(input: text.lowercased(), name: c.name.lowercased()) // occorrenze della stessa valigia diverso peso max
                        let rep2 = getOccurrences(input: text, name: c.name.lowercased()) // occorrenze di una valigia da aggiungere (es. 2, 3, 4, ...)
                        
                        for _ in 1...rep{
                            let valigia = PersistenceManager.shared.loadValigieFromNomeCategoria(nome: c.name, categoria: c.category)[0]

                            DecodeInput.valigieUsate.append(valigia.nome!)
                            let pesoMassimo = getPesoMassimo(input: text.lowercased(), name: c.name)
                            
                            // inserisco tutte le occorrenze della valigia
                            for _ in 1...rep2{
                                PersistenceManager.shared.addValigiaViaggiante(valigia: valigia, viaggio: viaggio, pesoMassimo: Int(pesoMassimo))
                            }
                            
                            decodedValues.valigieAggiunte.append((valigia.nome!, rep2))
                            
                        }
                        
                    }
                    
                }
                
            PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
            DecodeInput.valigieUsate.removeAll()
                
            case "rimuovi":
                
                // verifico se l'oggetto da eliminare è effettivamente un oggetto
                for item in DecodeInput.oggetti {
                    if(text.lowercased().contains(item.name.lowercased())){
                        
                        // quante volte devo eliminare l'oggetto trovato
                        rep = getOccurrences(input: text, name: item.name.lowercased())
                        
                        let oggetto = PersistenceManager.shared.loadOggettiFromNomeCategoria(nome: item.name, categoria: item.category)[0]
                        let ov  = PersistenceManager.shared.loadOggettiViaggiantiFromOggettoViaggio(oggettoRef: oggetto, viaggioRef: viaggio)[0]
                        
                        for _ in 1...rep{
                            ov.quantitaInViaggio -= 1
                            ov.quantitaAllocata -= 1
                            if ov.quantitaInViaggio == 0{
                                PersistenceManager.shared.deleteOggettoViaggiante(ogetto: oggetto, viaggio: viaggio)

                            }
                        }
                        
                        decodedValues.oggettiEliminati.append((item.name, rep))

                    }
                }
            
                // se non sono stati trovati oggetti, verifico se si tratta di una valigia da eliminare
                for c in DecodeInput.valigie {
                    if(text.lowercased().contains(c.name.lowercased())){
                        
                        let valigiaViagg = PersistenceManager.shared.loadValigieViaggiantiFromViaggio(viaggio: viaggio)
                        for val in valigiaViagg{
                            if(val.valigiaRef!.nome!.lowercased() == c.name.lowercased()){
                                
                                // quante volte devo eliminare la valigia viaggiante trovata
                                rep = getOccurrences(input: text, name: c.name.lowercased()) // occorrenze della valigia da eliminare
                                
                                let valigiaRef = val.valigiaRef!
                                
                                for _ in 1...rep{
                                    PersistenceManager.shared.deleteValigiaViaggiante(viaggio: viaggio, valigia: valigiaRef)
                                }
                                
                                decodedValues.valigieEliminate.append((valigiaRef.nome!, rep))
                                
                                break
                            }
                        }
                    }
                }
            
            PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
            
            default:
            
                // l'azione da compiere non è aggiunta o rimozione di oggetti / valigie
                return decodedValues
            
        }
        
        PersistenceManager.shared.allocaOggetti(viaggio: viaggio, ordinamento: viaggio.allocaPer)
        
        return decodedValues
        
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
    public func getPesoMassimo(input: String, name: String) -> Int32 {
        
        var countOcc = 0
        
        for conta in DecodeInput.valigieUsate{
            if(conta == name){
                countOcc += 1
            }
        }
        
        // di quante parole si compone il nome della valigia?
        let nomeArray = name.components(separatedBy: " ")
        
        
        // cerco il peso della valigia all'interno della stringa inserita
        // countOcc, se diverso da 0, contiene il numero di occorrenze del nome della valigia da skippare prima di prendere il peso
        let inputArray = input.components(separatedBy: " ")
        
        var i = 0, c = 0
        
        // se il nome della valigia è composto da una parola
        if nomeArray.count == 1 {
            for item in inputArray {
                
                print("--\(item.lowercased())--\(name.lowercased())--")
                
                if (item.lowercased() == name.lowercased()){
                    print(item.lowercased())
                    c += 1
                }
                
                if (item.lowercased() == name.lowercased() && c == countOcc){
                    // valigia di cui prendere il peso
                    
                    for k in i...inputArray.count-1 {
                        if inputArray[k].lowercased() == "kg" {
                            
                            if(inputArray[k-1] ~= "[0-9]*"){
                                // il peso è scritto a numero
                                return Int32(exactly: Int(inputArray[k-1])!*1000)! // res in grammi

                            }
                        }
                    }
                    
                }

                i = i + 1
                
            }
            
        // se il nome della valigia è composto da più parole
        }else{
            
            for item in inputArray{
                
                // ho trovato la prima parola del nome della valigia uguale alla prima parola della stringa di input
                if (item.lowercased() == nomeArray[0].lowercased()){
                    
                    print("--\(item.lowercased())--\(name.lowercased())--")
                    c += 1
                    
                }
                
                // sono sulla valigia giusta in quanto ho contato il numero di occorrenze
                if (item.lowercased() == nomeArray[0].lowercased() && c == countOcc){
                    
                    // ora devo verificare che anche le altre parole che compongono il nome della valigia siano uguali a quelle di input
                    for j in 0...nomeArray.count-1{
                        
                        print("--\(nomeArray[j].lowercased())--\(inputArray[i].lowercased())--")
                        
                        if nomeArray[j].lowercased() != inputArray[i].lowercased() {
                            return Int32.max
                        }
                        
                        i += 1
                        
                    }
                    
                    // se sono tutte uguali allora continuo a scorrere l'array e restituisco il peso
                    for k in i...inputArray.count-1 {
                        if inputArray[k].lowercased() == "kg" {
                            
                            if(inputArray[k-1] ~= "[0-9]*"){
                                // il peso è scritto a numero
                                return Int32(exactly: Int(inputArray[k-1])!*1000)! // res in grammi

                            }
                        }
                    }
                    
                }
                
                i = i + 1
                
            }
        }
        
        return Int32.max
    }
    
    public func getOccurrences(input: String, name: String) -> Int {
        
        var i = 0
        
        let inputArray = input.components(separatedBy: " ")
        
        for item in inputArray {
            
            if i != 0 {
                
                if (item.lowercased() == name.lowercased()){
                    
                    if(inputArray[i-1].lowercased() ~= "^([^0-9]*)$"){
                        
                        for (key, value) in numbers {
                            if (value == inputArray[i-1].lowercased()){
                                return key
                            }
                        }
                        
                    }else if(stringIsNumber(inputArray[i-1].lowercased())){
                        
                        return Int(inputArray[i-1].lowercased())!
                        
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
        
        if conta == 0 {
            conta = 1
        }
        
        return conta
        
    }
    
    let numbers:[Int:String] = [1:"uno", 2:"due", 3:"tre", 4:"quattro", 5:"cinque",
                               6:"sei", 7:"sette", 8:"otto", 9:"nove", 10:"dieci",
                               11:"undici", 12:"dodici", 13:"tredici", 14:"quattordici", 15:"quindici",
                               16:"sedici", 17:"diciassette", 18:"diciotto", 19:"diciannove", 20:"venti",
                               21:"ventuno", 22:"ventidue", 23:"ventitré", 24:"ventiquattro", 25:"venticinque",
                               26:"ventisei", 27:"ventisette", 28:"ventotto", 29:"ventinove", 30:"trenta"]
    
    func stringIsNumber(_ string:String) -> Bool {
        for character in string{
            if !character.isNumber{
                return false
            }
        }
        return true
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

extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}

    

    

