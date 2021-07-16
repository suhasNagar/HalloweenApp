//
//  Database.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/6/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SQLite
class Database {
    var candies: [String]!
    var dictionary : [String:[String]]!
    var database: Connection!
    let usersTable = Table("users")
    let userId = Expression<Int>("id")
    let name = Expression<String>("name")
    let lat = Expression<Double>("lat")
    let long = Expression<Double>("long")
    let address = Expression<String>("address")
    
    let candyTable = Table("candies")
    let candyId = Expression<Int>("id")
    let candyName = Expression<String>("candy")
    
    let userCandyMap = Table("userToCandy")
    let uid = Expression<Int>("userid")
    let cid = Expression<Int>("candyid")
    
    let candyTrie = Table("candyTrie")
    let candyPrefix = Expression<String>("candyPrefix")
    let fullName = Expression<String>("fullName")
    init(){
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathComponent("sqlite3")
            database = try Connection(fileURL.path)
            try database.run(self.usersTable.create { (table) in
                table.column(self.userId, primaryKey: true)
                table.column(self.name)
                table.column(self.lat)
                table.column(self.long)
                table.column(self.address)
            })
            try database.run(self.candyTable.create { (table) in
                table.column(self.candyId, primaryKey: true)
                table.column(self.candyName)
            })
            try database.run(self.userCandyMap.create { (table) in
                table.column(self.uid)
                table.column(self.cid)
            })
            try database.run(self.candyTrie.create { (table) in
                table.column(self.candyPrefix)
                table.column(self.fullName)
            })
        }catch{
            print(error)
        }
        candies = ["Skittles", "M&Ms", "Twix", "Snickers", "Almond Joy", "Mystery", "Starbursts", "Sour Patch", "Sour Gummies", "Swedish Fish"]
        dictionary = [:]
        for candy in candies {
            addCandy(candy: candy)
        }
    }
    public func addCandy(candy: String){
        var substr = ""
        for char in candy {
            substr.append(char)
            if dictionary[substr] != nil {
                dictionary[substr]?.append(candy)
            } else {
                dictionary[substr] = ["\(candy)"]
            }
        }
        do{
            try database.run(candyTable.insert(name <- candy))
        }catch {
            print(error)
        }
    }
    public func addUser (user: UserProfile){
        do{
            try database.run(candyTable.insert(name <- candy))
        }catch {
            print(error)
        }
    }
    public func top(substr: String, row: Int) -> String{
        if dictionary[substr] == nil{
            return ""
        }
        if row >= dictionary[substr]!.count {
            return ""
        }
        return dictionary[substr]![row]
    }
}