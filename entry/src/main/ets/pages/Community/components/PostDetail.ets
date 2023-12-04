import router from '@ohos.router';
import { Comments } from './Comments';

@Entry
@Component
struct PostDetail {
  private title: string = "Hello World"
  private content: string = "Hello World"
  private postId: number = 0
  private images: string[] = [
    "https://dummyimage.com/20/09f/fff.png",
    "https://dummyimage.com/20/ff0/fff.png",
    "https://dummyimage.com/200x300&text=dummyimage.com+rocks!",
    "https://dummyimage.com/640x4:3/",
    "https://dummyimage.com/300/09f.png/fff"
  ]

  onPageShow() {
    const params = router.getParams();
    this.postId = params['id'];
  }

  build() {
    Column() {

      Swiper() {

        ForEach(this.images, (item: string) => {
          Image(item)
            .width("90%")
            .height(400)
        })
      }


      Column({space: 10}) {
        Text(this.title)
          .fontSize(18)
        Text(this.content)
          .fontSize(14)
        Divider()

      }
      .alignItems(HorizontalAlign.Start)
      .width('95%')
      .borderRadius(12)
      .margin(10)
      .padding({top: 10})

      Comments()
        .padding({top:10})
    }

  }
}


@Component
struct pre {
  private name: string = "Hello World"
  private content: string = "Hello World"

  build() {
    Column() {
      PostDetail()
    }
    .width('100%')
    .height('100%')
  }
}

export { PostDetail }

