
import Foundation

struct PagedPostResponse {
  let moderators: [Post]
  let total: Int
  let hasMore: Bool
  let page: Int    
}
