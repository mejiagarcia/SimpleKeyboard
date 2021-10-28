import UIKit

public enum KeyboardAction {
    case keyboardWillShow
    case keyboardWillHide
}

public extension UIViewController {
    func supportFlexibleLayout() {
        addSupportForDismissKeyboard()
        
        _ = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handle(action: .keyboardWillShow, notification: notification)
        }
        
        _ = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handle(action: .keyboardWillHide, notification: notification)
        }
    }
    
    func handle(action: KeyboardAction, notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        switch action {
        case .keyboardWillShow:
            view.frame.origin.y = -(keyboardFrame?.height ?? view.frame.origin.y)
            
        case .keyboardWillHide:
            view.frame.origin.y = .zero
        }
    }
    
    func addSupportForDismissKeyboard() {
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        )
    }
    
    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
