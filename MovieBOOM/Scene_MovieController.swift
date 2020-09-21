import UIKit
import SwiftyJSON
import Thrift
import ReactiveSwift
import MovieBOOMThrift

final class MovieController: UICollectionViewController {
    var currentId: Int!
    var route: MovieComponentRoute!
    
    private var dataSource: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
    }

    private func getDetails() {
        DispatchQueue.main.async { [weak self] in
            let client = TMDBThrift.shared
                .createClient(MovieServiceClient.self)
            do {
                let detail = try client.getDetails(
                    req: TMDBGetDetailsRequest(
                        id: 10003,
                        apiKey: AppKeys.shared.tMDBApiKey,
                        language: "en"
                    )
                )
                var dataSource = [JSON]()
                dataSource += [
                    "type": "info",
                    "text": detail.originalTitle
                ]
                self?.dataSource = dataSource
                self?.collectionView.reloadData()
            } catch {
                self?.showAlertOK(
                    title: R.string.localization.error(),
                    message: error.localizedDescription,
                    handler: nil)
            }
        }
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
                for: indexPath)
            return cell
        default:
            fatalError()
        }
    }
}

extension MovieController: UICollectionViewDelegateFlowLayout {
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
