import Foundation

struct LanguageModel: Identifiable { /*, Codable*/
    var id : String = UUID().uuidString
    var title: String
    var locale_id: String
    var emoji: String
}

let languageModelData: [LanguageModel] = [
    LanguageModel(title: "Dansk", locale_id: "da-DE", emoji: "🇩🇰"),
    LanguageModel(title: "Engelsk", locale_id: "en-US", emoji: "🇺🇸"),
    LanguageModel(title: "Arabisk", locale_id: "ar-LB", emoji: "🇱🇧"),
    LanguageModel(title: "Spansk", locale_id: "es-ES", emoji: "🇪🇸"),
    LanguageModel(title: "Fransk", locale_id: "fr-FR", emoji: "🇫🇷"),
    LanguageModel(title: "Tysk", locale_id: "de-DE", emoji: "🇩🇪"),
    LanguageModel(title: "Urdu", locale_id: "ur_IN", emoji: "🇮🇳🇵🇰"),
    LanguageModel(title: "Japansk", locale_id: "ja_JP", emoji: "🇯🇵"),
    LanguageModel(title: "Kinesisk HK. SAR China", locale_id: "zh_Hant_HK", emoji: "🇨🇳"),
    LanguageModel(title: "Koreansk", locale_id: "ko_KR", emoji: "🇰🇷"),
    LanguageModel(title: "Russisk", locale_id: "ru_RU", emoji: "🇷🇺")
]
