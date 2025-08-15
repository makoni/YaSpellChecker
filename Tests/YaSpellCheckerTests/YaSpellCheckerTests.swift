import Testing
import YaSpellChecker

struct YaSpellCheckerTests {
    @Test("Should correct Russian typos in the input text")
    func correctsRussianTypos() async throws {
        let checker = YaSpellChecker()
        let input = "Это тектс с ашбиками."
        let expected = "Это текст с ошибками."
        let result = try await checker.checkAndCorrect(text: input)
        #expect(result == expected)
    }

    @Test("Should correct English typos in the input text")
    func correctsEnglishTypos() async throws {
        let checker = YaSpellChecker()
        let input = "This is a tset with erors."
        let expected = "This is a test with errors."
        let result = try await checker.checkAndCorrect(text: input, lang: "en")
        #expect(result == expected)
    }

    @Test("Should not change already correct text")
    func noCorrectionNeeded() async throws {
        let checker = YaSpellChecker()
        let input = "Корректный текст."
        let result = try await checker.checkAndCorrect(text: input)
        #expect(result == input)
    }

    @Test("Contains HTML")
    func noCorrectionNeededContainsHTML() async throws {
        let checker = YaSpellChecker()
        let input = """
<ul>
    Корректный текст.
</ul>
"""   
        let result = try await checker.checkAndCorrect(text: input, format: "html")
        #expect(result == input)
    }

    @Test("Error localization uses package strings")
    func errorLocalization() async throws {
        // Expected strings are stored in the package resource bundle (Localizable.xcstrings)
        let bundle = YaSpellChecker.bundle

        let netStr = bundle.localizedString(forKey: "YaSpellCheckerError.networkError", value: "", table: nil)
        let invStr = bundle.localizedString(forKey: "YaSpellCheckerError.invalidResponse", value: "", table: nil)
        let decStr = bundle.localizedString(forKey: "YaSpellCheckerError.decodingError", value: "", table: nil)

        struct TestError: Error {}
        let net = YaSpellCheckerError.networkError(TestError())
        let inv = YaSpellCheckerError.invalidResponse
        let dec = YaSpellCheckerError.decodingError(TestError())

        #expect(net.errorDescription == netStr || net.errorDescription == "Network error while connecting to Yandex Speller.")
        #expect(inv.errorDescription == invStr || inv.errorDescription == "Invalid response from Yandex Speller service.")
        #expect(dec.errorDescription == decStr || dec.errorDescription == "Failed to decode Yandex Speller response.")
    }
}