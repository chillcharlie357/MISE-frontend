
import { Content } from '../data/PostContent';

@Component
struct PostCard {
  content: Content;

  build() {
    Column() {
      Row() {
        Image(this.content.avatar)
          .objectFit(ImageFit.Cover)
          .width(70)
          .height(70)
          .margin({left:10})

        Column() {
          Text(this.content.title)
            .fontSize(30)
            .fontWeight(FontWeight.Medium)
          Text(this.content.description)
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
        }
        .padding(20)
        .margin({left:10})

      }
      .padding(2)

      Text(this.content.context)
        .fontSize(16)
        .fontWeight(FontWeight.Regular)
        .margin({left:20})


      Grid() {
        ForEach(this.content.images, (item: Resource) => {
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
  }
}

@Preview
@Component
struct CardPre {
  filledArray: Array<Resource> = Array(4).fill($r('app.media.icon'));
  item: Content = new Content(
    1,
    $r('app.media.icon'),
    `title`,
    `content`,
    `description`,
    this.filledArray
  );

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