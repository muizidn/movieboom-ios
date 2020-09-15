import Foundation

final class TMDBConfiguration {
    static let shared = TMDBConfiguration()
    private init() {}
    
    private lazy var plistUrl: URL = {
        do {
            var url = try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
            url = url.appendingPathComponent("App_TMDBConfig.plist")
            return url
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    func updateFromApi(onError: ((Error) -> Void)? = nil) {
        _ = RestManager2.shared.request(
            endpoint: TMDBApi.configuration)
        { [weak self] (res) in
            switch res {
            case .success(let json):
                do {
                    guard let url = self?.plistUrl else { return }
                    let data = try json.rawData()
                    let config = try JSONDecoder()
                        .decode(TMDBConfig.self,
                                from: data)
                    let plistData = try PropertyListEncoder()
                        .encode(config)
                    try plistData.write(to: url, options: .atomicWrite)
                } catch {
                    fatalError(error.localizedDescription)
                }
            case .failure(let error):
                onError?(error)
            }
        }
    }
    
    
    func getConfig() -> TMDBConfig {
        do {
            let data = try Data(contentsOf: plistUrl)
            let config = try PropertyListDecoder()
                .decode(TMDBConfig.self, from: data)
            return config
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - TMDBConfig
struct TMDBConfig: Codable {
    let images: TMDBConfigImages
    let changeKeys: [String]

    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}

// MARK: - Images
struct TMDBConfigImages: Codable {
    let baseURL: String
    let secureBaseURL: String
    let backdropSizes, logoSizes, posterSizes, profileSizes: [String]
    let stillSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}

