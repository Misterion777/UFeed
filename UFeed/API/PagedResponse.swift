
import Foundation

struct PagedResponse<T> {
    let social : Social
    let objects: [T]
    let next : String?
    let totalCount : Int?
    
    init(social: Social, objects: [T], next : String? = nil, totalCount : Int? = nil){
        self.social = social
        self.objects = objects
        self.next = next
        self.totalCount = totalCount
    }
}
