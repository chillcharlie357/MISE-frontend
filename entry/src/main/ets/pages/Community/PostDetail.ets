import router from '@ohos.router';
import { Comments } from './components/Comments';

@Entry
@Component
struct PostDetail {
  @State title: string = router.getParams()['title']
  @State content: string = router.getParams()['content']
  @State postId: number = router.getParams()['id']
  @State images: string[] = router.getParams()['images']

  aboutToAppear() {
    console.info("PostDetail: ", JSON.stringify(this.images))
  }

  build() {
    Scroll() {
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
    }
    .scrollable(ScrollDirection.Vertical)
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

