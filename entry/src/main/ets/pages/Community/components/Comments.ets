import { CommentData, CommentDataGetter, CommentResponse } from '../../../data/data'
import { CommentBlock } from './CommentBlock'

@Component
struct Comments {
  postId: number = 0
  avatar: string = "https://dummyimage.com/300/09f.png/fff"
  @State commentsList: CommentData[] = []
  private getCommentsData: CommentDataGetter

  aboutToAppear() {
    this.getCommentsData().then((res: CommentResponse) => {
      console.info("Comments: ", JSON.stringify(res));
      this.commentsList = res.comments;
    }).catch((err) => {
      console.log(err);
    })
  }

  build() {
    Column() {
      // 评论输入
      Row() {
        Image(this.avatar)
          .width(40)
          .height(40)
          .borderRadius(20)
          .margin({ right: 10 })
        TextArea({ placeholder: 'Write a comment...' })
          .width('80%')
          .height(40)
          .borderRadius(20)
          .padding({ left: 10 })
          .border({ width: 1, color: '#ccc' })
      }

      // 评论区展示
      List({ space: 8 }) {
        ForEach(this.commentsList, (item: CommentData) => {
          ListItem() {
            CommentBlock({
              commentInfo: item,
              postId: this.postId
            })
          }
        }, (item: CommentData) => item.id.toString())
      }
      .scrollBar(BarState.Off)
      .divider({
        strokeWidth: 1,
        startMargin: 60,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
      .width("100%")
      .padding({ top: 10 })

    }
    .width('100%')

  }
}


@Component
@Preview
struct pre {
  build() {
    Column() {
      Comments()
    }
    .width('100%')
    .height('100%')
  }
}


export { Comments }