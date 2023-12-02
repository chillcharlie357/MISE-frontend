import image from '@ohos.multimedia.image';
import { PostCard } from '../../components/PostCard';
import { CustomDialogUser } from '../../components/CustomDialogExample';
import { PostList } from '../../components/PostList';
import { Content } from '../../data/PostContent';
import { fakePostContentData } from '../../utils/fakePostContent';

@Entry
@Component
@Preview
struct CommunityScreen {
  @State message: string = 'Drawing Panel'
  @State contents: Array<Content> = fakePostContentData();
  private swiperController: SwiperController = new SwiperController();

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

      PostList({ contents: this.contents })

    }
    .width('100%')
    .backgroundColor("#afddf2")
  }
}


export { CommunityScreen }