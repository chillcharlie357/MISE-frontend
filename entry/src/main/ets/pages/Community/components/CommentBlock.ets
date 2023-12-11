// 单个评论
import { Icon } from "../../../components/Icon"
import { CommentData } from '../../../data/data'

@Component
struct CommentBlock {
  @State isLiked: Boolean = false
  @State commentInfo: CommentData = {
    id: 1,
    avatar: "https://dummyimage.com/300/09f.png/fff",
    username: "用户名",
    content: "评论内容",
    likes: 0
  }
  onLikeClick: () => void = () => {
    console.info("like click", this.isLiked)
    if (this.isLiked === true) {
      this.commentInfo.likes--
    } else {
      this.commentInfo.likes++
    }
    this.isLiked = !this.isLiked;
  }

  aboutToAppear() {
  }

  build() {
    Row() {
      Row({ space: 10 }) {
        Image(this.commentInfo.avatar)
          .width(40)
          .height(40)
          .borderRadius(20)
          .backgroundColor("#eee")

        Column({ space: 10 }) {
          Text(this.commentInfo.username)
            .fontSize(16)
            .fontWeight("bold")
          Text(this.commentInfo.content)
            .fontSize(14)
        }
        .alignItems(HorizontalAlign.Start)
        .width("90%")
      }.layoutWeight(3)
      .margin({ left: 10 })

      Row() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          if (this.isLiked === true) {
            Image('pages/Community/icon/ic_public_favor_filled.svg')
              .width(30)
              .height(30)
          } else {
            Image('pages/Community/icon/ic_public_favor.svg')
              .width(30)
              .height(30)
          }
        }
        .margin({ left: 20 })
        .backgroundColor(Color.White)
        .onClick(this.onLikeClick)

        Text(this.commentInfo.likes.toString())
          .fontSize(14)
          .margin({ left: 10 })
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