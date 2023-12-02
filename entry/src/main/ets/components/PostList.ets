import { Content } from '../data/PostContent';
import { PostCard } from './PostCard';

@Component
struct PostList {
  contents: Content[];

  build() {
    List() {
      ForEach(this.contents, (item: Content) => {
        ListItem() {
          PostCard({ content: item })
        }
      }, content => content.id)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
    .zIndex(50)
  }
}

export { PostList }