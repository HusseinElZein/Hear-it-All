class LanguageHelper {
    static func getLanguageModel(byLocaleId localeId: String) -> LanguageModel? {
        return languageModelData.first { $0.locale_id == localeId }
    }
}
