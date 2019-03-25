import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!
    
    let categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "name", ascending: true)
    let categoryPicker = UIPickerView()
    
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //背景をタップしたらdismissKeyboardメソッドを呼ぶ様に設定
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        selectedCategory = task.category
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 画面戻る時でかつタイトルが入力されているときのみ登録
        if isMovingFromParent && self.titleTextField.text != "" {
       
        // 画面から離れる時に保存
            try! realm.write {
                self.task.category = selectedCategory
                self.task.title = self.titleTextField.text!
                self.task.contents = self.contentsTextView.text
                self.task.date = self.datePicker.date
                self.realm.add(self.task, update: true)
            }
        
            setNotification(task: task)
        }
        super.viewWillDisappear(animated)
    }
    
    //タスクのローカル通知を登録
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        //ローカル通知が発動するtriggerを作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        //ローカル通知を作成
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) {
            (error) in
            print(error ?? "ローカル通知登録　OK")
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/-------------")
                print(request)
                print("/-------------")
            }
        }
        
    }
    

}
