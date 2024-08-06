import Foundation

struct FeaturesConfig: Codable {
    var aiCaptions: AiCaptions?
    var aiClipping: AiClipping?
    var audioBrowser: AudioBrowser?
}

struct AiClipping: Codable {
    var audioDataUrl: String?
    var audioTracksUrl: String?
}

struct AiCaptions: Codable {
    var uploadUrl: String?
    var transcribeUrl: String?
    var apiKey: String?
}

struct AudioBrowser: Codable {
    var source: String
    var params: Params?
}

struct Params : Codable {
    var mubertLicence: String?
    var mubertToken: String?
}


