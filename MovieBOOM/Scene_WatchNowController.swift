import UIKit
import SwiftyJSON
import ReactiveSwift

final class WatchNowController: UICollectionViewController {
    
    private var dataSource: JSON = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        SignalProducer(value: ())
            .flatMap(.latest, {
                SignalProducer<JSON, Error> { (sink, disposable) in
                    let task = RestManager2.shared.request(
                        endpoint: TMDBApi.trending(mediaType: .all, timeWindow: .day))
                    { (res) in
                        switch res {
                        case .success(let json):
                            sink.send(value: json)
                        case .failure(let err):
                            sink.send(error: err)
                        }
                    }
                    disposable.observeEnded {
                        task.cancel()
                    }
                }
            })
            .startWithResult({ [unowned self] res in
                switch res {
                case .success(let json):
                    self.dataSource = [
                        "page": json["page"],
                        "results": self.dataSource["results"].arrayValue
                            + json["results"].arrayValue,
                        "total_pages": json["total_pages"],
                        "total_results": json["total_results"]
                    ]
                    self.collectionView.reloadData()
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
