//
//  CatListClient.swift
//  TCA-Composable-Architecture-Sample-App
//
//  Created by Daniyal Yousuf on 2023-07-08.
//

import ComposableArchitecture
import Foundation

typealias ModelProtocols = Decodable & Equatable & Sendable

struct CatListModel: ModelProtocols, Identifiable {
    var adaptability : Int?
    var affection_level : Int?
    var alt_names : String?
    var cfa_url : String?
    var child_friendly : Int?
    var country_code : String?
    var country_codes : String?
    var description : String?
    var dog_friendly : Int?
    var energy_level : Int?
    var experimental : Int?
    var grooming : Int?
    var hairless : Int?
    var health_issues : Int?
    var hypoallergenic : Int?
    var id : String?
    var image : Image?
    var indoor : Int?
    var intelligence : Int?
    var lap : Int?
    var life_span : String?
    var name : String?
    var natural : Int?
    var origin : String?
    var rare : Int?
    var reference_image_id : String?
    var rex : Int?
    var shedding_level : Int?
    var short_legs : Int?
    var social_needs : Int?
    var stranger_friendly : Int?
    var suppressed_tail : Int?
    var temperament : String?
    var vcahospitals_url : String?
    var vetstreet_url : String?
    var vocalisation : Int?
    var weight : Weight?
    var wikipedia_url : String?
    
    struct Image : ModelProtocols {
        let height : Int?
        let id : String?
        let url : String?
        let width : Int?
    }
    
    struct Weight : ModelProtocols {
        let imperial : String?
        let metric : String?
    }
}


struct CatListClient {
    var fetchCats: @Sendable(String) async throws -> [CatListModel]
}

extension DependencyValues {
    var catListClient: CatListClient {
        get {
            self[CatListClient.self]
        } set {
            self[CatListClient.self] = newValue
        }
    }
}

extension CatListClient: DependencyKey {
    static let liveValue = CatListClient { endPoint in
        var url = URL(string: "https://api.thecatapi.com\(endPoint)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([CatListModel].self, from: data)
    }
}
