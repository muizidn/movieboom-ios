import UIKit
import SwiftyJSON
import ReactiveSwift

final class HomeController: UICollectionViewController {
    private var dataSource: [JSON] = []
    
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
                    let i = self.dataSource.mustGetIndex("type", "hero")
                    do {
                        var ds = self.dataSource[i]
                        ds += [
                            "page": json["page"],
                            "total_pages": json["total_pages"],
                            "total_results": json["total_results"],
                            "dataSource": createF {
                                ds["dataSource"].arrayValue
                                    + json["results"].arrayValue
                            }
                        ]
                        self.dataSource[i] = ds
                    }
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = dataSource[indexPath.row]
        switch data["type"].stringValue {
        case "hero":
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: data["type"].stringValue,
                for: indexPath) as! HomeHeroCell
            cell.dataSource = data["dataSource"].arrayValue
            return cell
        default:
            fatalError()
        }
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = dataSource[indexPath.row]
        switch data["type"].stringValue {
        case "hero":
            return CGSize(
                width: collectionView.frame.width,
                height: 254
            )
        default:
            fatalError()
        }
    }
}
