//
//  CoreDataHelp.swift
//  Pokemon
//
//  Created by user on 7/17/17.
//  Copyright © 2017 Vazquez. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon () {
   
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Bullbasaur" , imageName: "bullbasaur")
    createPokemon(name: "Jigglypuff", imageName: "jigglypuff")
    createPokemon(name: "Charmader", imageName: "charmander")
    createPokemon(name: "Pikachu", imageName: "pikachu-2")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Dratini", imageName: "dratini")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Valor", imageName: "valor")

    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}
func createPokemon(name: String, imageName: String) {
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
    
}

func getAllPokemon() -> [Pokemon] {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
    let pokemons =  try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0 {
            addAllPokemon()
            return getAllPokemon()
        }
        
        return pokemons
        
        
    } catch {}
    

    return []
}

func getAllCaughtPokemons () -> [Pokemon] {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
    
    
    do {
    let pokemons =  try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {}
    
    return []

}

func getAllUncaughtPokemons () -> [Pokemon] {
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
    
    
    do {
        let pokemons =  try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {}
    
    return []

    
}
