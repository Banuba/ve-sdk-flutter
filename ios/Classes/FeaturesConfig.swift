import Foundation

struct FeaturesConfig: Codable, ReflectedStringConvertible {
    let aiCaptions: AiCaptions?
    let aiClipping: AiClipping?
    let audioBrowser: AudioBrowser
    let editorConfig: EditorConfig?
    let draftConfig: DraftConfig
}

struct AiClipping: Codable, ReflectedStringConvertible {
    let audioDataUrl: String
    let audioTracksUrl: String
}

struct AiCaptions: Codable, ReflectedStringConvertible {
    let uploadUrl: String
    let transcribeUrl: String
    let apiKey: String
}

struct AudioBrowser: Codable, ReflectedStringConvertible {
    let source: String
    let params: Params?
}

struct Params: Codable, ReflectedStringConvertible {
    let mubertLicence: String?
    let mubertToken: String?
}

struct EditorConfig: Codable, ReflectedStringConvertible {
    let isVideoAspectFillEnabled: Bool?
}

struct DraftConfig: Codable, ReflectedStringConvertible {
    let option: String
}

