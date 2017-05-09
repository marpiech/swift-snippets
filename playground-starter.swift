import UIKit
import PlaygroundSupport

class MyView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let controllerFrame = CGRect(
            x: 0, y: 0, width: 380, height: 620)
        let myView = MyView(frame: controllerFrame)
        myView.backgroundColor = .white
        view.addSubview(myView)
    }
}

let controller = ViewController()
controller.view.backgroundColor = .black
PlaygroundPage.current.liveView = controller
