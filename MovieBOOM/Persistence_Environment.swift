import Foundation

enum Environment {
    static var isFirstTime: State<Bool> {
        .init(staticKey: .userDefault("isFirstTime"), default: true)
    }
    static var session: State<String> {
        .init(staticKey: .keychain("token"), default: "")
    }
}
