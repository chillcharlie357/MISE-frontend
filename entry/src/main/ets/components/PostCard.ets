import router from '@ohos.router';
import { PostData } from '../data/data';

@Component
struct PostCard {
  content: PostData = null;

  build() {
    Column() {
      Row() {
        Image(this.content.avatar)
          .objectFit(ImageFit.Cover)
          .width(70)
          .height(70)
          .margin({ left: 10 })

        Column() {
          Text(this.content.title)
            .fontSize(30)
            .fontWeight(FontWeight.Medium)
        }
        .padding(20)
        .margin({ left: 10 })

      }
      .padding(2)

      Text(this.content.content)
        .fontSize(16)
        .fontWeight(FontWeight.Regular)
        .margin({ left: 20 })


      Grid() {
        ForEach(this.content.images, (item: Resource, index: number) => {

          GridItem() {

            Image(item)
              .objectFit(ImageFit.Cover)
              .width(60)
              .height(60)
          }
          .margin(5)
          .padding(4)
        })
      }
      .margin(10)
      .maxCount(4)

      Blank()

    }
    .alignItems(HorizontalAlign.Start)
    .width('95%')
    .backgroundColor("#f1f3f5")
    .borderRadius(12)
    .margin(10)
    .shadow({ radius: 10, color: Color.Gray, offsetX: 5, offsetY: 10 })
    .onClick(() => {
      console.log(`click: ${this.content.id}`)
      router.pushUrl({
        url: "pages/Community/PostDetail",
        params: {
          id: this.content.id
        }
      })
    })
  }
}

@Preview
@Component
struct CardPre {
  filledArray: Array<string> = Array(5).fill("https://dummyimage.com/20/09f/fff.png");
  item: PostData = {
    id: 1,
    title: "title",
    content: "content",
    avatar: "https://dummyimage.com/20/09f/fff.png",
    images: this.filledArray
  }

  build() {
    Column() {
      PostCard({ content: this.item })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.snow_grey'))
  }
}

export { PostCard }