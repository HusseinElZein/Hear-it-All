import Foundation


///Language model to choose different languges
struct LanguageModel: Identifiable, Equatable {
    var id : String = UUID().uuidString
    var title: String
    var locale_id: String
    var emoji: String
}

///Language data list to choose from easily
let languageModelData: [LanguageModel] = [
    LanguageModel(title: Localized.LanguageLocalized.danish, locale_id: "da-DE", emoji: "🇩🇰"),
    LanguageModel(title: Localized.LanguageLocalized.english, locale_id: "en-US", emoji: "🇺🇸"),
    LanguageModel(title: Localized.LanguageLocalized.arabic, locale_id: "ar-LB", emoji: "🇱🇧"),
    LanguageModel(title: Localized.LanguageLocalized.spanish, locale_id: "es-ES", emoji: "🇪🇸"),
    LanguageModel(title: Localized.LanguageLocalized.french, locale_id: "fr-FR", emoji: "🇫🇷"),
    LanguageModel(title: Localized.LanguageLocalized.german, locale_id: "de-DE", emoji: "🇩🇪"),
    LanguageModel(title: Localized.LanguageLocalized.japanese, locale_id: "ja_JP", emoji: "🇯🇵"),
    LanguageModel(title: Localized.LanguageLocalized.chinese, locale_id: "zh_Hant_HK", emoji: "🇨🇳"),
    LanguageModel(title: Localized.LanguageLocalized.korean, locale_id: "ko_KR", emoji: "🇰🇷"),
    LanguageModel(title: Localized.LanguageLocalized.russian, locale_id: "ru_RU", emoji: "🇷🇺")
]
