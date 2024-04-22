
import UIKit

func showAlerOnTop(message:String){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
      // completion?(true)
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
}

func showOkAlertAnyWhereWithCallBack(message:String,completion:@escaping () -> Void){
   DispatchQueue.main.async {
   let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
       completion()
   }
   alert.addAction(action)
   UIApplication.topViewController()!.present(alert, animated: true, completion: nil)
   }
  
}



extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}


extension UITableView {
    
    func registerCells(_ cells : [UITableViewCell.Type]) {
        for cell in cells {
            self.register(UINib(nibName: String(describing: cell), bundle: Bundle.main), forCellReuseIdentifier: String(describing: cell))
        }
    }
}
