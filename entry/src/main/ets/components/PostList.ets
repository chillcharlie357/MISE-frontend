import { PostDataGetter, PostData } from '../data/data';
import { PostCard } from './PostCard';
import promptAction from '@ohos.promptAction';

@Component
struct PostList {
  @State contents: Array<PostData> = [];
  @State isRefreshing: boolean = false
  private getPostData: PostDataGetter;

  aboutToAppear() {
    this.getPostData().then(async (data: Array<PostData>) => {
      this.contents = data;
    })
    console.info('PostList aboutToAppear: ', JSON.stringify(this.contents))
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 100 }) {
      List() {
        ForEach(this.contents, (item: PostData) => {
          ListItem() {
            PostCard({ content: item })
          }
        }, item => item.id)
      }
      .width('100%')
      .height('100%')
    }.onStateChange((refreshStatus: RefreshStatus) => {
      console.info('Refresh onStatueChange state is ' + refreshStatus)
    })
    .onRefreshing(async () => {
      setTimeout(() => {
        this.isRefreshing = false
      }, 1000)
      await this.getPostData().then((data: Array<PostData>) => {
        this.contents = data;
        console.info('onRefreshing: ', JSON.stringify(data))
        console.info('onRefreshing: ', JSON.stringify(this.contents))
      })
    })


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