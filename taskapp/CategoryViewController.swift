import UIKit
import RealmSwift

class CategoryViewController: UIViewController {

    let realm = try! Realm()
    
    
    
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var categoryRegister: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCategoryButton.isEnabled = false
        
    }
    
    @IBAction func isEnableAddButton(_ sender: Any) {
        if (categoryRegister.text == "") {
            addCategoryButton.isEnabled = false
        } else {
            addCategoryButton.isEnabled = true
        }
    }
    
    @IBAction func categoryToroku(_ sender: Any) {
        
        let category = Category()
        category.name = categoryRegister.text!
        
        let allCategories = realm.objects(Category.self)
        if allCategories.count != 0 {
            category.id = allCategories.max(ofProperty: "id")! + 1
        }
        try! realm.write {
            self.realm.add(category, update: true)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func categoryCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
