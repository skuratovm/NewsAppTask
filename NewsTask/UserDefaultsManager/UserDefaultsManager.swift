//
//  UserDefaultsManager.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 5.02.22.
//

import Foundation

class DataBase{
    static let shared = DataBase()
    let defaults = UserDefaults.standard

    var news:[NewsTableViewCellViewModel]? {
        get {
            if let data = defaults.value(forKey: "data") as? Data{
                return try! PropertyListDecoder().decode([NewsTableViewCellViewModel].self, from: data)
            } else {
                return [NewsTableViewCellViewModel]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue){
                defaults.set(data,forKey: "data")
            }
        }
    }
    func saveSchedule(result: NewsTableViewCellViewModel?,row: Int){

        news?.insert(result!, at: 0)
    }
    func deleteSchedule(result: NewsTableViewCellViewModel?,row: Int){
        news?.remove(at: row)
        
    }
}

