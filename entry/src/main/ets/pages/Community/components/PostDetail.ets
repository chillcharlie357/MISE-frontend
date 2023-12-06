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
    Flex({ direction: FlexDirection.Column }) {

      Swiper() {
        ForEach(this.images, (item: string) => {
          Image(item)
            .width("90%")
            .width(400)
            .objectFit(ImageFit.Cover)
        })
      }

      PostContent({
        title: this.title,
        content: this.content
      })
        .width('95%')
        .margin(10)
        .padding({ top: 10 })

      Comments()
        .padding({ top: 10 })
        .flexShrink(3)

    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct PostContent {
  private title: string = "Hello World"
  private content: string = "Hello World"

  build() {
    Column({ space: 10 }) {
      Text(this.title)
        .fontSize(18)
      Text(this.content)
        .fontSize(14)
      Divider()
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius(12)

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

