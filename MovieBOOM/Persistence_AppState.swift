import Foundation

// UserDefault is threadsafe
// https://developer.apple.com/documentation/foundation/userdefaults

struct State<T> {
    let staticKey: StaticKey
    let `default`: T
}

extension State: Equatable {
    var key: String { staticKey.description }
    static func == (lhs: State<T>, rhs: State<T>) -> Bool { lhs.key == rhs.key }
}



/// App State will responsible for underliying state storage
enum AppState {
    
    static func get<T>(_ state: State<T>) -> T where T: DataCodable {
        do {
            let data = try state.staticKey.storage.get(key: state.key)
            return data.map { T.init(data: $0) } ?? state.default
        } catch {
            fatalError("Error \(error)")
        }
    }
    
    /// If default then nil
    /// - Parameter state: State
    static func getOrNil<T>(_ state: State<T>) -> T? where T: DataCodable & Equatable {
        do {
            let data = try state.staticKey.storage.get(key: state.key)
            let res = data.map { T.init(data: $0) } ?? state.default
            return res == state.default ? nil : res
        } catch {
            fatalError("Error \(error)")
        }
    }
    
    static func set<T>(_ state: State<T>, value: T) where T: DataCodable {
        do {
            try state.staticKey.storage.set(key: state.key, value: value)
        } catch {
            print("Error", error)
        }
    }
    
    static func remove<T>(_ state: State<T>) {
        do {
            try state.staticKey.storage.remove(key: state.key)
        } catch {
            print("Error", error)
        }
    }
}

extension AppState {
    static func reset() {
        
    }
    
    static func logout() throws {
        
    }
}

