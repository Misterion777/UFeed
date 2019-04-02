
import Foundation

struct PagedPostResponse {
    let posts: [Post]
    let total: Int
    let nextFrom : String    
}
