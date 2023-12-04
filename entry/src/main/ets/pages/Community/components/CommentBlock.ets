// 单个评论
import { Icon } from "../../../components/Icon"

@Component
struct CommentBlock {

  @State private avatar: string = "https://dummyimage.com/300/09f.png/fff"
  private username: string = "用户名"
  private content: string = "评论内容"
  @State private likes: number = 0

  build() {
    Row() {
      Row({ space: 10 }) {
        Image(this.avatar)
          .width(40)
          .height(40)
          .borderRadius(20)
          .backgroundColor("#eee")

        Column({ space: 10 }) {
          Text(this.username)
            .fontSize(16)
            .fontWeight("bold")
          Text(this.content)
            .fontSize(14)
        }
      }.layoutWeight(3)

      Row() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Image($r('app.media.ic_public_favor')).width(30).height(30)
        }
        .margin({ left: 20 })
        .backgroundColor(Color.White)
        .onClick(() => {
          console.log("点赞")
          this.likes++
        })

        Text(this.likes.toString())
          .fontSize(14)
          .margin({left: 10})
      }
      .layoutWeight(1)

    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .padding(10)

  }
}


@Component
@Preview
struct pre {
  build() {
    Column() {
      CommentBlock()
    }
    .width("100%")
    .height("100%")
  }
}

export { CommentBlock }