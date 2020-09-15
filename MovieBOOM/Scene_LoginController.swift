import UIKit
import ReactiveSwift
import SwiftyJSON
import SafariServices

final class LoginController: UITableViewController {
    @IBOutlet weak var _tfemail: UITextField!
    @IBOutlet weak var _tfpassword: UITextField!
    @IBOutlet weak var _btnlogin: UIButton!
    
    @IBAction func _doAuthenticate() {
        SignalProducer(value: ())
            .flatMap(FlattenStrategy.latest, {
                SignalProducer<String, Error> { (sink, disposable) in
                    let task = RestManager2.shared.request(
                        endpoint: TMDBApi.createRequestToken)
                    { (res) in
                        switch res {
                        case .success(let json):
                            sink.send(value: json["request_token"].stringValue)
                        case .failure(let err):
                            sink.send(error: err)
                        }
                    }
                    disposable.observeEnded {
                        task.cancel()
                    }
                }
            })
            .flatMap(.latest, { (token) -> SignalProducer<String, Error> in
                SignalProducer<String,Error> { [unowned self] (sink, disposable) in
                    guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(token)") else { fatalError() }
                    let vc = LoginAuthenticationController(url: url)
                    vc.onDissapear = {
                        sink.send(value: token)
                        sink.sendCompleted()
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            })
            .flatMap(.latest, { (token) in
                SignalProducer<String, Error> { (sink, disposable) in
                    let task = RestManager2.shared.request(
                        endpoint: TMDBApi.createSession(token: token))
                    { (res) in
                        switch res {
                        case .success(let json):
                            sink.send(value: json["session_id"].stringValue)
                            sink.sendCompleted()
                        case .failure(let err):
                            sink.send(error: err)
                        }
                    }
                    disposable.observeEnded {
                        task.cancel()
                    }
                }
            })
            .startWithResult({ [unowned self] (res) in
                switch res {
                case .success(let value):
                    AppState.set(Environment.session, value: value)
                case .failure(let err):
                    self.showAlertOK(
                        title: R.string.localization.error(),
                        message: err.localizedDescription)
                }
            })
    }
    
    @IBAction func _doAsGuest() {
        SignalProducer(value: ())
            .flatMap(FlattenStrategy.latest, {
                SignalProducer<String, Error> { (sink, disposable) in
                    let task = RestManager2.shared.request(
                        endpoint: TMDBApi.createGuestSession)
                    { (res) in
                        switch res {
                        case .success(let json):
                            sink.send(value: json["guest_session_id"].stringValue)
                            sink.sendCompleted()
                        case .failure(let err):
                            sink.send(error: err)
                        }
                    }
                    disposable.observeEnded {
                        task.cancel()
                    }
                }
            })
            .startWithResult({ [unowned self] (res) in
                switch res {
                case .success(let value):
                    AppState.set(Environment.session, value: value)
                case .failure(let err):
                    self.showAlertOK(
                        title: R.string.localization.error(),
                        message: err.localizedDescription)
                }
            })
    }
    
    private func showAlertOK(title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: title, style: .default, handler: handler))
        self.present(vc, animated: true, completion: nil)
    }
}


final class LoginAuthenticationController: SFSafariViewController {
    var onDissapear: () -> Void = {}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDissapear()
    }
}
