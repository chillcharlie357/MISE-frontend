import { PostList } from '../../components/PostList'
import { Content } from '../../data/PostContent'
import { fakePostContentData } from '../../utils/fakePostContent'

@Component
@Preview
struct ProfileContent {
  private contents: Content[] = fakePostContentData()

  build() {
    Row() {
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          PostList({ contents: this.contents })
        }
        .tabBar('作品')

        TabContent() {
          PostList({ contents: this.contents })
        }
        .tabBar('收藏')

        TabContent() {
          PostList({ contents: this.contents })
        }
        .tabBar('赞过')
      }
    }
    .backgroundColor("#ffffffff")
    .width('100%')
    .borderWidth(6)
    .borderColor("#ffc3c3c3")
    .borderRadius(10)
    .borderStyle(BorderStyle.Solid)
    .shadow({
      radius: 4,
      color: "#ffd6d4d4",
      offsetX: -10,
      offsetY: 10
    })
    .margin(2)
  }
}

export { ProfileContent }