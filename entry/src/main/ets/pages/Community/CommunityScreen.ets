import image from '@ohos.multimedia.image';
import { PostCard } from '../../components/PostCard';
import { CustomDialogUser } from '../../components/CustomDialogExample';
import { PostList } from '../../components/PostList';
import axios from '../../axios'
import { PostDataGetter, PostData, PostResponse } from '../../data/data';
import { fakePostContentData } from '../../utils/fakePostContent';

@Entry
@Component
@Preview
struct CommunityScreen {
  private swiperController: SwiperController = new SwiperController();
  /**
   * 给PostList组件传递的获取数据的方法, 如果直接传contents会导致PostList组件在无法渲染
   * @returns Promise<PostResponse> | null
   */
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

  aboutToAppear() {
    console.info('CommunityScreen aboutToAppear');
  }

  build() {
    Column() {


      Swiper(this.swiperController) { //此为轮播图组件
        Text("0")
          .width('90%')
          .height(80)
          .backgroundColor(Color.Yellow)
          .textAlign(TextAlign.Center)
          .fontSize(30)

        Text("1")
          .width('90%')
          .height(80)
          .backgroundColor(Color.Green)
          .textAlign(TextAlign.Center)
          .fontSize(30)

        Text("2")
          .width('90%')
          .height(80)
          .backgroundColor(Color.Pink)
          .textAlign(TextAlign.Center)
          .fontSize(30)
      }
      .loop(true)
      .autoPlay(true)
      .interval(3000)
      .borderRadius(12)
      .margin(10)

      CustomDialogUser().zIndex(9999)

      PostList({ getPostData: this.getPostData })

    }
    .width('100%')
    .backgroundColor("#afddf2")
  }
}


export { CommunityScreen }