import Foundation

public struct KeyValue<K,V> {
    let key: K
    let value: V
}

extension Dictionary: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: KeyValue<Key, Value>...) {
        self = Dictionary.init(uniqueKeysWithValues: elements.map {
            ($0.key, $0.value)
        })
    }
    
    public typealias ArrayLiteralElement = KeyValue<Key, Value>
}

extension KeyValue where K == String {
    static func context(_ value: V) -> Self {
        Self(key: "context", value: value)
    }
    static func key(_ value: V) -> Self {
        Self(key: "key", value: value)
    }
    static func id(_ value: V) -> Self {
        Self(key: "id", value: value)
    }
    static func urlres(_ value: V) -> Self {
        Self(key: "urlres", value: value)
    }
    static func url(_ value: V) -> Self {
        Self(key: "url", value: value)
    }
    static func path(_ value: V) -> Self {
        Self(key: "path", value: value)
    }
    static func data(_ value: V) -> Self {
        Self(key: "data", value: value)
    }
    static func code(_ value: V) -> Self {
        Self(key: "code", value: value)
    }
    static func error(_ value: V) -> Self {
        Self(key: "error", value: value)
    }
    static func type(_ value: V) -> Self {
        Self(key: "type", value: value)
    }
    static func custom(_ key: String, _ value: V)-> Self {
        Self(key: key, value: value)
    }
}

extension Dictionary {
    struct TypedValue<K,V> {
        let key: K
    }
    
    subscript<T>(_ key: TypedValue<Key,T>) -> T? {
        get {
            return self[key.key] as? T
        }
        set(newValue) {
            self[key.key] = (newValue as! Value)
        }
    }
}

extension Dictionary.TypedValue {
    typealias `Self` = Dictionary.TypedValue
    
    /// Return as Custom
    static func c<T>(_ key: String, _ type: T.Type) -> Self<String, T> {
        .init(key: key)
    }
    /// Return as Object (Dictionary)
    static func o(_ key: String) -> Self<String, [String:Any]> {
        .init(key: key)
    }
    /// Return as Int
    static func i(_ key: String) -> Self<String, Int> {
        .init(key: key)
    }
    /// Return as String
    static func s(_ key: String) -> Self<String, String> {
        .init(key: key)
    }
    /// Return as Array
    static func a(_ key: String) -> Self<String, [Any]> {
        .init(key: key)
    }
    /// Return as Double
    static func d(_ key: String) -> Self<String, Double> {
        .init(key: key)
    }
    /// Return as Float
    static func f(_ key: String) -> Self<String, Float> {
        .init(key: key)
    }
    
    /// Return as Bool
    static func b(_ key: String) -> Self<String, Bool> {
        .init(key: key)
    }
}

extension Dictionary.TypedValue {
    static var target: Dictionary.TypedValue<String, String> {
        .init(key: "target")
    }
    static var message: Dictionary.TypedValue<String, String> {
        .init(key: "message")
    }
    static var url: Dictionary.TypedValue<String, String> {
        .init(key: "url")
    }
    static var id: Dictionary.TypedValue<String, String> {
        .init(key: "id")
    }
}
