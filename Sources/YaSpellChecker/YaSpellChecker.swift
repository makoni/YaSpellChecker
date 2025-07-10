// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// Ошибки Яндекс Спеллера
public enum YaSpellCheckerError: Error {
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

/// Структура для ответа Яндекс Спеллера
struct YandexSpellerError: Codable {
    let code: Int
    let pos: Int
    let row: Int
    let col: Int
    let len: Int
    let word: String
    let s: [String]?
}

/// Actor для проверки и исправления орфографии через Яндекс Спеллер API
public actor YaSpellChecker {
    public init() {}
    private let endpoint = "https://speller.yandex.net/services/spellservice.json/checkText"

    /// Проверяет и исправляет орфографию в тексте
    /// - Parameters:
    ///   - text: Текст для проверки
    ///   - lang: Языки проверки (по умолчанию "ru,en")
    ///   - options: Опции проверки (по умолчанию 0)
    ///   - format: Формат текста ("plain" или "html", по умолчанию "plain")
    /// - Returns: Исправленный текст
    public func checkAndCorrect(text: String, lang: String = "ru,en", options: Int = 0, format: String = "plain") async throws -> String {
        let data: Data
        let response: URLResponse
        guard let url = URL(string: endpoint) else {
            throw YaSpellCheckerError.invalidResponse
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let params = [
            "text": text,
            "lang": lang,
            "options": String(options),
            "format": format
        ]
        let bodyString = params.map { "\($0.key)=\(Self.urlEncode($0.value))" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw YaSpellCheckerError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw YaSpellCheckerError.invalidResponse
        }

        let errors: [YandexSpellerError]
        do {
            errors = try JSONDecoder().decode([YandexSpellerError].self, from: data)
        } catch {
            throw YaSpellCheckerError.decodingError(error)
        }

        return applyCorrections(to: text, errors: errors)
    }

    private static func urlEncode(_ string: String) -> String {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove("+")
        return string.addingPercentEncoding(withAllowedCharacters: allowed)?.replacingOccurrences(of: "+", with: "%2B") ?? string
    }

    /// Формирует URL для запроса
    private func makeURL(text: String, lang: String, options: Int, format: String) -> URL? {
        var components = URLComponents(string: endpoint)
        components?.queryItems = [
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "options", value: String(options)),
            URLQueryItem(name: "format", value: format)
        ]
        return components?.url
    }

    /// Применяет исправления к исходному тексту
    private func applyCorrections(to text: String, errors: [YandexSpellerError]) -> String {
        guard !errors.isEmpty else { return text }
        var corrected = text
        // Сортируем ошибки по убыванию позиции, чтобы не сбивать индексы
        let sorted = errors.sorted { $0.pos > $1.pos }
        for error in sorted {
            guard let suggestions = error.s, let first = suggestions.first else { continue }
            let start = corrected.index(corrected.startIndex, offsetBy: error.pos)
            let end = corrected.index(start, offsetBy: error.len)
            corrected.replaceSubrange(start..<end, with: first)
        }
        return corrected
    }
}
