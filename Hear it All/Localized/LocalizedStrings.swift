import Foundation


/// A class containing localized strings for all strings in the application.
/// This way we can `translate` the strings, and use them whenever we want since they're static
///  We can use them without instantiating any class, and they're classifed to see their distribution of course😃
/// - Author: Hussein El-Zein
class Localized {
    class DateLocalized{
        static let years_ago = String(localized: "år siden")
        static let ago = String(localized: "siden")
        static let months_plural = String(localized: "er")
        static let month = String(localized: "måned")
        static let d_ago = String(localized: "d siden")
        static let t_ago = String(localized: "t siden")
        static let m_ago = String(localized: "m siden")
        static let just_now = String(localized: "Lige nu")
    }
    
    class ProfileLocalized{
        static let choose_how_use_profile = String(localized: "Vælg hvordan du vil bruge en profil")
        static let sign_in = String(localized: "Log ind")
        static let sign_up = String(localized: "Opret profil")
        static let password = String(localized: "Adgangskode")
        static let forgot_password = String(localized: "Glemt adgangskode?")
        static let display_name = String(localized: "Visningsnavn")
        static let can_happen = String(localized: "Det kan jo ske! Men bliv ikke bekymret, vi sender dig et link til din email")
        static let logged_in_message = String(localized: "Du er nu logget ind!")
        static let mail_wrong_message = String(localized: "Mail el. adgangskode er forkert")
        static let created_profile_message = String(localized: "Oprettet ny profil!")
        static let mail_sent_message = String(localized: "Mail sendt, tjek venligst din mail")
        
        static let profile_picture = String(localized: "Profilbillede")
        static let delete_picture = String(localized: "Slet billede")
        static let you_sure = String(localized: "Er du sikker på, at du vil slette billedet?")
        static let yes = String(localized: "Ja")
        static let cancel = String(localized: "Annullér")
        static let sign_out = String(localized: "Log ud")
        static let delete_profile = String(localized: "Slet profil")
        
        static let profile = String(localized: "Profil")
        
        static let change_display_name = String(localized: "Skift visningsnavn")
        static let change = String(localized: "Skift")
        
        static let change_password = String(localized: "Skift adgangskode")
        
        //Settings
        static let try_again = String(localized: "Prøv igen, eller log ud og ind igen")
        static let password_changed = String(localized: "Koden er nu ændret!")
        static let name_changed = String(localized: "Navn er nu ændret!")
        static let picture_uploaded = String(localized: "Profilbillede er nu uploadet!")
        static let picture_deleted = String(localized: "Billede er nu slettet")
        static let profile_deleted = String(localized: "Profil nu slettet")
        
        
    }
    
    class LanguageLocalized{
        static let danish = String(localized: "Dansk")
        static let english = String(localized: "Engelsk")
        static let arabic = String(localized: "Arabisk")
        static let spanish = String(localized: "Spansk")
        static let french = String(localized: "Fransk")
        static let german = String(localized: "Tysk")
        static let japanese = String(localized: "Japansk")
        static let chinese = String(localized: "Kinesisk HK. SAR China")
        static let korean = String(localized: "Koreansk")
        static let russian = String(localized: "Russisk")
        static let choose_language = String(localized: "Vælg sprog")
    }
    
    class SoundsLocalized{
        static let speech = String(localized: "Tale")
        static let sound_recognition = String(localized: "Lydgenkendelse")
        static let speech_recognition = String(localized: "Talegenkendelse")
        static let all_off = String(localized: "Slå alle fra")
        static let all_on = String(localized: "Slå alle til")
        static let choose_sounds = String(localized: "Vælg lyde")
        static let search_sounds = String(localized: "Søg efter lyde")
    }
    
    class SettingsLocalized{
        static let settings = String(localized: "Indstillinger")
        static let info_privacy = String(localized: "Info om privatlivspolitik")
        static let profile_settings = String(localized: "Profilindstillinger")
        static let words_before_update = String(localized: "Antal ord inden sætningen opdateres:")
    }
    
    class PolicyLocalized{
        static let politic_title = String(localized: "Privatlivspolitik for Hear it All")
        static let validity_date = String(localized: "Gyldig fra: 25. marts 2024")
        static let colon_1 = String(localized: "Hos Hear it All, tilgængelig fra WSAudiology, er et af vores primære prioriteter privatlivets fred for vores brugere. Dette dokument med privatlivspolitik indeholder typer af oplysninger, der indsamles og registreres af Hear it All, og hvordan vi anvender dem.")
        static let colon_2 = String(localized: "Hvis du har yderligere spørgsmål eller behøver mere information om vores privatlivspolitik, så tøv ikke med at kontakte os.")
        static let colon_3 = String(localized: "Oplysninger, vi indsamler")
        static let colon_4 = String(localized: "De personoplysninger, som du bliver bedt om at give, og årsagerne til, at du bliver bedt om at give dem, vil blive gjort klart for dig på det tidspunkt, vi beder dig om at give dine personoplysninger.")
        static let colon_5 = String(localized: "Når du registrerer dig for en konto, kan vi bede om dine kontaktoplysninger, herunder ting som visningsnavn, e-mailadresse og evt. posts og profilbillede.")
        static let colon_6 = String(localized: "Hvordan vi bruger dine oplysninger")
        static let colon_7 = String(localized: "Vi bruger de oplysninger, vi indsamler, på forskellige måder, herunder til at:")
        static let colon_8 = String(localized: "- Levere, drive og vedligeholde vores app")
        static let colon_9 = String(localized: "- Forbedre og udvide vores app")
        static let colon_10 = String(localized: "- Forstå og analysere, hvordan du bruger vores app")
        static let colon_11 = String(localized: "Logfiler")
        static let colon_12 = String(localized: "Hear it All følger en standard procedure for brug af logfiler. Disse filer logger besøgende, når de bruger apps. De oplysninger, der indsamles af logfiler, inkluderer enhedstype og hvilken type nedbrud, der fik appen til at gå ned")
    }
    
    class CreatePostLocalized{
        static let insert_title = String(localized: "Indtast titel")
        static let insert_text = String(localized: "Skriv din tekst her")
        static let done = String(localized: "Færdig")
        static let insert_photo = String(localized: "Vælg foto for dit indlæg")
        static let update = String(localized: "Opdatér")
        static let something_wrong = String(localized: "Noget gik galt")
        static let now_posted = String(localized: "Indlæg er nu postet!")
    }
    
    class SeePostsLocalized{
        static let comments = String(localized: "Kommentarer")
        static let delete = String(localized: "Slet")
        static let create_post = String(localized: "Opret post")
        static let posts = String(localized: "Indlæg")
    }
    
    class CommentsLocalized{
        static let be_first = String(localized: "Vær den første til at kommentere!😃")
        static let add_comment = String(localized: "Tilføj en kommentar...")
    }
}
