//
//  Name.swift
//  NamesOfAllah
//
//  Data model for Allah's beautiful names
//

import Foundation

struct Name: Identifiable, Codable, Hashable {
    let id: Int
    let nameArabic: String
    let nameEnglish: String
    let translation: String
    let meaning: String
    let evidence: String
    let liveIt: [String]
    let story: String

    // Computed property for display
    var dayNumber: String {
        return "\(id.arabicDigits) من ٩٩"
    }
}

// Extension for sample data (useful for previews)
extension Name {
    static let sample = Name(
        id: 1,
        nameArabic: "الرحمن",
        nameEnglish: "Ar-Rahman",
        translation: "The Most Merciful",
        meaning: "هو الذي وسعت رحمته كل شيء، رحمة عامة تشمل جميع الخلائق في الدنيا، فهو الذي خلق الخلق ورزقهم وأنعم عليهم بنعم لا تحصى.",
        evidence: "قال تعالى: ﴿الرَّحْمَـٰنُ عَلَى الْعَرْشِ اسْتَوَىٰ﴾ [طه: ٥]",
        liveIt: [
            "ابدأ يومك بتذكر رحمة الله الواسعة، فكل نعمة لديك من رحمته",
            "عامل الناس برحمة ولين، فالراحمون يرحمهم الرحمن",
            "عند الشدائد، تذكر أن رحمة الله قريب من المحسنين",
            "اطلب من الله برحمته، فهو أرحم بك من نفسك",
            "ارحم الضعفاء والمساكين، تنال رحمة الرحمن"
        ],
        story: "روي عن عمر بن الخطاب رضي الله عنه أنه قَدِمَ على رسول الله ﷺ سَبْيٌ، فإذا امرأة من السبي تبحث عن شيء، فإذا وجدت صبياً في السبي أخذته فألصقته ببطنها وأرضعته، فقال لنا رسول الله ﷺ: \"أترون هذه المرأة طارحة ولدها في النار؟\" قلنا: لا والله. فقال: \"لَلَّهُ أرحم بعباده من هذه بولدها\". (رواه البخاري ومسلم)"
    )
}
