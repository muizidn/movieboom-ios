import Foundation
import KeychainAccess

private let keychainStorage = Keychain(
    accessGroup: Bundle.main.object(forInfoDictionaryKey: "KEYCHAIN_GROUP") as! String
)
/// Over Enginnered 🤣
/// This is key which responsible for its own storage implementation (keychain, userdefault)
enum StaticKey: CustomStringConvertible {
    case keychain(String)
    /// Using UserDefaults.standard
    case userDefault(String)
    /// Custom
    case customWithStorage(String, Storage)
    
    var description: String {
        switch self {
        case .userDefault(let value):
            return value
        case .customWithStorage(let value, _):
            return value
        case .keychain(let value):
            return value
        }
    }
    
    var storage: Storage {
        switch self {
        case .userDefault:
            return UserDefaults.standard
        case .customWithStorage(_, let storage):
            return storage
        case .keychain:
            return keychainStorage
        }
    }
}

protocol Storage {
    func set(key: String, value: DataCodable) throws
    func get(key: String) throws -> Data?
    func remove(key: String) throws
}

extension Keychain: Storage {
    func set(key: String, value: DataCodable) throws {
        try set(value.toData(), key: key)
    }
    
    func get(key: String) throws -> Data? {
        return try? getData(key)
    }
    
    func remove(key: String) throws {
        try remove(key)
    }
}

extension UserDefaults: Storage {
    func set(key: String, value: DataCodable) throws {
        set(value.toData(), forKey: key)
    }
    
    func get(key: String) throws -> Data? {
        return value(forKey: key) as? Data
    }
    
    func remove(key: String) throws {
        removeObject(forKey: key)
    }
}

protocol DataCodable: Codable {
    func toData() -> Data
    init(data: Data)
}

extension Data: DataCodable {
    func toData() -> Data {
        return self
    }
    init(data: Data) {
        self = data
    }
}

extension String: DataCodable {
    func toData() -> Data {
        guard let data = self.data(using: .utf8) else {
            fatalError("Cannot encode using UTF8: \(self)")
        }
        return data
    }
    
    init(data: Data) {
        self = String.init(data: data, encoding: .utf8)!
    }
}

protocol _NumericPrimitiveDataCodable: DataCodable {
    associatedtype Primitive
}

extension _NumericPrimitiveDataCodable where Self.Primitive == Self {
    func toData() -> Data {
        var value = self
        return Data.init(bytes: &value, count: MemoryLayout<Primitive>.size)
    }
    
    init(data: Data) {
        self = data.withUnsafeBytes { (bfr) -> Primitive in
            return bfr.bindMemory(to: Primitive.self).first!
        }
    }
}

extension Int: _NumericPrimitiveDataCodable {
    typealias Primitive = Int
}

extension Double: _NumericPrimitiveDataCodable {
    typealias Primitive = Double
}

extension Bool: _NumericPrimitiveDataCodable {
    typealias Primitive = Bool
}

