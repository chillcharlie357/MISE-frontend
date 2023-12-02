import { CardView } from '@isrc/easyui'

@Component
struct Avatar {
  private avatarUrl: string
  private userName: string
  private description: string
  private uid: string

  build() {
    Row() {
      Column() {
        Row() {
          Row({ space: 10 }) {
            Image(this.avatarUrl)
              .height(50)
              .width(50)
              .borderWidth(1)
              .borderStyle(BorderStyle.Solid)
              .borderColor("#ffc3c3c3")
              .borderRadius(5)
              .alignSelf(ItemAlign.Center)

            Column({ space: 5 }) {
              Text(this.userName)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)

              Row() {
                Text('UID: ')
                  .fontSize(15)
                Text(this.uid)
                  .fontSize(15)
                  .baselineOffset(TextAlign.Start)
              }
            }.width("80%")
            .alignItems(HorizontalAlign.Start)
            .padding({ bottom: 15 })
          }
          .padding({ left: 10, top: 15 })

        }.layoutWeight(1)

        Text(this.description)
          .fontSize(15)
          .layoutWeight(2)
          .alignSelf(ItemAlign.Start)
          .padding({left: 15})
      }
      .backgroundColor("#ffffffff")
      .width('100%')
      .borderWidth(2)
      .borderColor("#ffc3c3c3")
      .borderRadius(10)
      .borderStyle(BorderStyle.Solid)
      .shadow({
        radius: 10,
        color: "#ffd6d4d4",
        offsetX: -10,
        offsetY: 10
      })
    }
    .height(200)
    .margin(6)
  }
}


@Component
@Preview
struct AvatarPre {
  private avatarUrl: string = "http://dummyimage.com/120x90"
  private userName: string = "Test"
  private description: string = "description"

  build() {
    Row() {
      // CardView()
      Avatar({
        avatarUrl: this.avatarUrl,
        userName: this.userName,
        description: this.description
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}

export { Avatar }