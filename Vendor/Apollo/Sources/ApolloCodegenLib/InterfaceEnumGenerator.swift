import Foundation
import Stencil

public class InterfaceEnumGenerator {
  public struct SanitizedInterfaceObject {
    
    // The name of the enum.
    let name: String
    
    // The variable declaration of the enum
    let nameVariableDeclaration: String
  
    // The variable usage of the enum
    let nameVariableUsage: String
    
    let cases: [SanitizedCase]
    public struct SanitizedCase {
      // The name of the case
      let name: String
      
      // The declaration of the case
      let variableDeclaration: String
      
      // The usage of the case
      let variableUsage: String
      
      public init(name: String,
                  variableDeclaration: String,
                  variableUsage: String) {
        self.name = name
        self.variableDeclaration = variableDeclaration
        self.variableUsage = variableUsage
      }
    }
    
    init(from interfaceType: ASTInterfaceType) {
      self.name = "\(interfaceType.name)Type"
      self.nameVariableDeclaration = self.name.apollo.sanitizedVariableDeclaration
      self.nameVariableUsage = self.name.apollo.sanitizedVariableUsage
      self.cases = interfaceType.types.map {
        SanitizedCase(name: $0,
                      variableDeclaration: $0.apollo.sanitizedVariableDeclaration,
                      variableUsage: $0.apollo.sanitizedVariableUsage)
      }
    }
  }
  
  public enum InterfaceEnumContextKey: String {
    case type
    case cases
    case modifier
  }
  
  /// Designated initializer
  public init() { }
  
  func run(interfaceType: ASTInterfaceType, options: ApolloCodegenOptions) throws -> String {
    
    let sanitized = SanitizedInterfaceObject(from: interfaceType)
    
    let context: [InterfaceEnumContextKey: Any] = [
      .type: sanitized,
      .cases: sanitized.cases,
      .modifier: options.modifier.prefixValue
    ]
    
    return try Environment().renderTemplate(string: self.interfaceEnumTemplate,
                                            context: context.apollo.toStringKeyedDict)
  }
  
  /// A stencil template to use to render interface enums.
  ///
  /// Variable to allow custom modifications, but MODIFY AT YOUR OWN RISK.
  open var interfaceEnumTemplate: String {
    """
    {{ modifier }}enum {{ type.name }}: RawRepresentable, Codable, Equatable, Hashable, CaseIterable {
      {{ modifier }}typealias RawValue = String

      {% for case in type.cases %}case {{ case.variableDeclaration }}
      {% endfor %}/// Type conforming to `{{ type.name }}` not defined at the time this enum was generated
      case __unknown(String)

      {{ modifier }}var rawValue: String {
        switch self {
        {% for case in cases %}case .{{ case.variableUsage }}: return "{{ case.name }}"
        {% endfor %}case .__unknown(let value): return value
        }
      }

      {{ modifier }}init(rawValue: String) {
        switch rawValue {
        {% for case in cases %}case "{{ case.name }}": self = .{{ case.variableUsage }}
        {% endfor %}default: self = .__unknown(rawValue)
        }
      }

      {{ modifier }}static var allCases: [{{ type.name }}] {
        [{% for case in cases %}
          .{{ case.variableUsage }},{% endfor %}
        ]
      }
    }
    """
  }
}
