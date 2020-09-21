import UIKit
import Kingfisher

func KF_loadImageToButtonBackground(with req: URL, into btn: UIButton, onError: ((Error) -> Void)? = nil) {
    KingfisherManager.shared.retrieveImage(with: req) { (res) in
        switch res {
        case .failure(let err):
            onError?(err)
        case .success(let kfRes):
            btn.setBackgroundImage(kfRes.image, for: .normal)
        }
    }
}
