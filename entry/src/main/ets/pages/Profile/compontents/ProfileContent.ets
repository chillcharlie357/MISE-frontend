import { PostList } from '../../../components/PostList'
import { PostDeny } from './PostDeny'
import { fakePostContentData } from '../../../utils/fakePostContent'
import { PostDataGetter, PostData, PostResponse } from '../../../data/data'
import axios from '../../../axios'

@Component
@Preview
struct ProfileContent {
  @StorageLink('login_state') login_state: boolean = false
  private getPostData: PostDataGetter = () => {
    return axios.get<PostResponse>('/community/posts')
      .then((response) => {
        console.info('CommunityScreen response: ', JSON.stringify(response.data));
        return response.data;
      })
      .catch((error) => {
        console.error('CommunityScreen error: ', error);
        return null;
      });
  }

  build() {
    Row() {
      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          if (this.login_state) {
            PostList({ getPostData: this.getPostData })

          } else {
            PostDeny()

          }
        }
        .tabBar('作品')

        TabContent() {
          if (this.login_state) {
            PostList({ getPostData: this.getPostData })

          } else {
            PostDeny()
          }
        }
        .tabBar('收藏')

        TabContent() {
          if (this.login_state) {
            PostList({ getPostData: this.getPostData })
          } else {
            PostDeny()
          }
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