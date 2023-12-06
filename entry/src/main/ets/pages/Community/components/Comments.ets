import { CommentBlock } from './CommentBlock'

@Component
struct Comments {
  private avatar: string = "https://dummyimage.com/300/09f.png/fff"
  private commentsList: number[] = Array.from({ length: 10 }, (v, k) => k + 1)

  build() {
    Column() {
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

      List({ space: 8 }) {
        ForEach(this.commentsList, (item) => {
          ListItem() {
            CommentBlock({content: item.toString()})
          }
        }, (item) => item.toString())
      }
      .scrollBar(BarState.Auto)
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