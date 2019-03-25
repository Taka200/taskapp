import RealmSwift

class Category: Object {
    //管理用ID。プライマリーキー
    @objc dynamic var id = 0
    
    @objc dynamic var name = ""
    
    //カテゴリー
    @objc dynamic var category = ""
    
    // IDをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
