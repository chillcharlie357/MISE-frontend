import { PostDataGetter, PostData } from '../data/data';
import { PostCard } from './PostCard';
import promptAction from '@ohos.promptAction';

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


    // WaterFlow() {
    //   ForEach(this.contents, (item: PostData) => {
    //     FlowItem() {
    //       PostCard({ content: item })
    //     }
    //     .onAppear(() => {
    //       if (this.contents.length <= this.contents.indexOf(item) + 5) {
    //         promptAction.showToast({
    //           message: "快要刷新了" + this.contents.indexOf(item),
    //           duration: this.contents.indexOf(item)
    //         })
    //       }
    //
    //     })
    //     // .height(100 + (item % 5) * 10)
    //     // .backgroundColor(Color.Gray)
    //   }, content => content.id)
    // }


  }
}

export { PostList }