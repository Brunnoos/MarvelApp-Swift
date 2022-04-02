// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct EventsResponse: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: EventsDataClass?
}

// MARK: - DataClass
struct EventsDataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Event]?
}

// MARK: - Result
struct Event: Codable {
    let id: Int?
    let title, resultDescription: String?
    let resourceURI: String?
    let urls: [URLElement]?
    let modified: String?
    let start, end: String?
    let thumbnail: Thumbnail?
    let creators: Creators?
    let characters: Characters?
    let stories: Stories?
    let comics: Comics?
    let series: Comics?
    let next, previous: Next?

    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
        case resourceURI, urls, modified, start, end, thumbnail, creators, characters, stories, comics, series, next, previous
    }
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [Next]?
    let returned: Int?
}

// MARK: - Next
struct Next: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [CreatorsItem]?
    let returned: Int?
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String?
    let name, role: String?
}
