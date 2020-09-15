import Foundation
import Keys

enum TMDBApi: RestApi {
    case createGuestSession
    case createRequestToken
    case createSession(token: String)
    case trending(mediaType: MediaType, timeWindow: TimeWindow)
    case configuration
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .createGuestSession:
            return "/authentication/guest_session/new"
        case .createRequestToken:
            return "/authentication/token/new"
        case .createSession:
            return "/authentication/session/new"
        case .trending(let m, let t):
            return "/trending/\(m)/\(t)"
        case .configuration:
            return "/configuration"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createGuestSession:
            return .get
        case .createRequestToken:
            return .get
        case .createSession:
            return .post
        case .trending:
            return .get
        case .configuration:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .createGuestSession:
            return .requestParameter([
                "api_key": AppKeys.shared.tMDBApiKey
            ])
        case .createRequestToken:
            return .requestParameter([
                "api_key": AppKeys.shared.tMDBApiKey
            ])
        case .createSession(let token):
            return .requestJSONDictAndParam(dict:
                [
                    "request_token": token,
                ], param: [
                    "api_key": AppKeys.shared.tMDBApiKey
            ])
        case .trending:
            return .requestParameter([
                "api_key": AppKeys.shared.tMDBApiKey
            ])
        case .configuration:
            return .requestParameter([
                "api_key": AppKeys.shared.tMDBApiKey
            ])
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
