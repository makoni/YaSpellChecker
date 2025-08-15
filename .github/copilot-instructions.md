## YaSpellChecker — Agent instructions

Purpose: give an AI coding agent the minimal, actionable knowledge to make safe, correct changes in this Swift package.

Quick facts
- Language: Swift (Package manifest: `swift-tools-version: 6.1` in `Package.swift`).
- Targets: `YaSpellChecker` (library), `ExampleApp` (executable), `YaSpellCheckerTests` (test target).
- Key files: `Sources/YaSpellChecker/YaSpellChecker.swift`, `Sources/ExampleApp/ExampleApp.swift`, `Tests/YaSpellCheckerTests/YaSpellCheckerTests.swift`, `Package.swift`, `Sources/YaSpellChecker/Localizable.xcstrings`.

Big picture (architecture & data flow)
- The package exposes a single public actor `YaSpellChecker` that wraps the Yandex.Speller HTTP API.
- Flow: caller -> `YaSpellChecker.checkAndCorrect(text:lang:options:format:)` -> HTTP POST (form-encoded) to Yandex Speller -> JSON array of `YandexSpellerError` -> `applyCorrections` builds corrected string and returns it.
- Example usage is in `ExampleApp` which prints and ANSI-highlights changed words.

Project-specific patterns & gotchas
- Actor + async/await: The API is an actor with a single async throwing method. Preserve the signature when changing behavior.
- Error handling: `YaSpellCheckerError` carries network/response/decoding cases and uses localized messages from `Localizable.xcstrings` (keys like `YaSpellCheckerError.networkError`). Update that file when adding new error cases.
- Corrections merging: `applyCorrections` sorts the returned errors by `pos` descending before replacing substrings. Any refactor must keep that descending-order strategy to avoid index shifting bugs.
- Encoding & request form: `checkAndCorrect` builds an `application/x-www-form-urlencoded` body and uses `urlEncode(_:)` (which removes `+` from allowed characters and percent-encodes). There is also an unused helper `makeURL(text:lang:options:format:)` if you need query-based requests.
- String indexing: replacements use Swift `String` index offsets computed from `pos` and `len`. Be careful with multi-byte unicode—if you change the replacement logic, add tests for cyrillic/multibyte characters.
- Tests hit the real Yandex network API (no mock). CI or local runs require outbound network access. Tests use the `Testing` import and `#expect` macros; keep tests' exact-string expectations in mind.

Developer workflows (quick commands)
```
swift build         # build the package and resolve dependencies
swift test          # run unit tests (network required)
swift run ExampleApp # run the demo executable
```
If you add a new dependency, update `Package.swift` and run `swift build` to fetch and verify.

When changing public API
- Update `README.md` usage examples and `ExampleApp` if the method signature changes.
- Add or update tests in `Tests/YaSpellCheckerTests` and keep the `#expect` pattern.

Files to inspect when touching behavior
- `Sources/YaSpellChecker/YaSpellChecker.swift` — core logic (network, decoding, applyCorrections).
- `Sources/YaSpellChecker/Localizable.xcstrings` — localized error messages used by `YaSpellCheckerError`.
- `Tests/YaSpellCheckerTests/YaSpellCheckerTests.swift` — real-world expectations/examples used by CI.
- `Package.swift` — swift-tools-version, platforms, and target layout.

Edge cases to be explicit about in PRs
- Unicode/multibyte replacements and how `pos`/`len` map to Swift String indices.
- Network-dependent tests: if adding flaky or long-running network calls, document and consider providing a mocked variant.

If something is unclear here or you need deeper examples (mock tests, index handling for multibyte text, or CI guidance), ask and I will expand this file with focused examples.
