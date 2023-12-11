import { PostDataGetter, PostData } from '../data/data';
import { PostCard } from './PostCard';

@Component
struct PostList {
  @State contents: Array<PostData> = [];
  private getPostData: PostDataGetter;

  aboutToAppear() {
    this.getPostData().then((data: Array<PostData>) => {
      this.contents = data;
    })
    console.info('PostList aboutToAppear: ', JSON.stringify(this.contents))
  }

  build() {
    List() {
      ForEach(this.contents, (item: PostData) => {
        ListItem() {
          PostCard({ content: item })
        }
      }, item => item.id)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.On)
    .zIndex(50)
  }
}

export { PostList }