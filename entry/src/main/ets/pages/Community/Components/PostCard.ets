import { Content } from '../CommunityScreen'

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

        Column() {
          Text(this.content.title)
            .fontSize(30)
          Text(this.content.description)
        }
        .padding(20)
        .margin(2)

      }
      .padding(2)

      Text(this.content.context)
        .padding(10)

      Grid() {
        ForEach(this.content.images, (item: Resource) => {
          GridItem() {
            Image(item)
              .objectFit(ImageFit.Cover)
              .width(80)
              .height(80)
          }
          .padding(4)
        })
      }
      .maxCount(4)

    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin(12)
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
    .backgroundColor('#F1F3F5')
  }
}

export { PostCard }