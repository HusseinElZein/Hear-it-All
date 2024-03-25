
///No need to instantiate this. It uses the localeId to find and return the LanguageModel from the Data it has
class LanguageHelper {
    static func getLanguageModel(byLocaleId localeId: String) -> LanguageModel? {
        return languageModelData.first { $0.locale_id == localeId }
    }
}
