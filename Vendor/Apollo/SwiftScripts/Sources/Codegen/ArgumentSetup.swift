import Foundation
import ApolloCodegenLib
import TSCUtility

enum Target {
    case starWars
    case starWarsSwiftCodegen
    case gitHub
    case upload
    
    init?(name: String) {
        switch name {
        case "StarWars":
            self = .starWars
        case "StarWars-SwiftCodegen":
            self = .starWarsSwiftCodegen
        case "GitHub":
            self = .gitHub
        case "Upload":
            self = .upload
        default:
            return nil
        }
    }
    
    func targetRootURL(fromSourceRoot sourceRootURL: Foundation.URL) -> Foundation.URL {
        switch self {
        case .gitHub:
            return sourceRootURL
                .apollo.childFolderURL(folderName: "Sources")
                .apollo.childFolderURL(folderName: "GitHubAPI")
        case .starWars,
             .starWarsSwiftCodegen:
            return sourceRootURL
                .apollo.childFolderURL(folderName: "Sources")
                .apollo.childFolderURL(folderName: "StarWarsAPI")
        case .upload:
            return sourceRootURL
            .apollo.childFolderURL(folderName: "Sources")
            .apollo.childFolderURL(folderName: "UploadAPI")
        }
    }
    
    func options(fromSourceRoot sourceRootURL: Foundation.URL) -> ApolloCodegenOptions {
        let targetRootURL = self.targetRootURL(fromSourceRoot: sourceRootURL)
        switch self {
        case .upload:
            return ApolloCodegenOptions(targetRootURL: targetRootURL)
        case .starWars:
            return ApolloCodegenOptions(targetRootURL: targetRootURL)
        case .starWarsSwiftCodegen:
            let jsonOutputFileURL = try!  targetRootURL.apollo.childFileURL(fileName: "API.json")
            let operationIDsURL = try! targetRootURL.apollo.childFileURL(fileName: "operationIDs.json")
            let json = try! targetRootURL.apollo.childFileURL(fileName: "schema.json")
            
            return ApolloCodegenOptions(codegenEngine: .swiftExperimental,
                                        operationIDsURL: operationIDsURL,
                                        outputFormat: .singleFile(atFileURL: jsonOutputFileURL),
                                        urlToSchemaFile: json)
        case .gitHub:
            let json = try! targetRootURL.apollo.childFileURL(fileName: "schema.docs.graphql")
            let outputFileURL = try!  targetRootURL.apollo.childFileURL(fileName: "API.swift")
            let operationIDsURL = try! targetRootURL.apollo.childFileURL(fileName: "operationIDs.json")
            return ApolloCodegenOptions(includes: "Queries/**/*.graphql",
                                        mergeInFieldsFromFragmentSpreads: true,
                                        operationIDsURL: operationIDsURL,
                                        outputFormat: .singleFile(atFileURL: outputFileURL),
                                        suppressSwiftMultilineStringLiterals: true,
                                        urlToSchemaFile: json)
        }
    }
}

struct ArgumentSetup {
    
    enum ArgumentError: Error, LocalizedError {
        case targetNotProvided(args: [String])
        
        var errorDescription: String? {
            switch self {
            case .targetNotProvided(let args):
                return "No valid was provided to generate code for. Args were: \(args)"
            }
        }
    }
    
    static func parse(arguments: [String] = Array(ProcessInfo.processInfo.arguments.dropFirst())) throws -> Target {
        
        let parser = ArgumentParser(usage: "Codegen <options>", overview: "This is what this tool is for")
                
        let target: OptionArgument<String> = parser.add(option: "--target",
                                                        shortName: "-t",
                                                        kind: String.self,
                                                        usage: "The target to generate code for")
        let parsedArguments = try parser.parse(arguments)
        
        
        if
            let targetName = parsedArguments.get(target),
            let target = Target(name: targetName) {
                return  target
        } else {
            throw ArgumentError.targetNotProvided(args: arguments)
        }
    }
}
