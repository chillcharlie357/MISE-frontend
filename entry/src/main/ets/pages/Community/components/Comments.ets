import { CommentData, CommentDataGetter, CommentResponse } from '../../../data/data'
import { CommentBlock } from './CommentBlock'
import axios from '../../../axios'

@Component
struct Comments {
  @LocalStorageProp('postId') postId: number = 0
  @StorageProp('userAvatar') avatar: string = "https://dummyimage.com/300/09f.png/fff"
  @StorageProp('username') username: string = ''
  @State commentsList: CommentData[] = []
  @State commentValue: string = ''
  private getComments: CommentDataGetter = () => {
    return axios.get<CommentResponse>(`/community/comments/${this.postId}`)
      .then((res) => {
        console.info("Post Detail: ", JSON.stringify(res.data))
        return res.data;
      })
      .catch((err) => {
        console.error(err);
        return null;
      })
  }
  private postComment = (comment: CommentData) => {
    return axios.post<CommentData>(`/community/comment/${this.postId}`, comment)
  }

  aboutToAppear() {
    this.getComments().then((res: CommentResponse) => {
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
        TextInput({ placeholder: 'Write a comment...' })
          .width('80%')
          .height(40)
          .borderRadius(20)
          .padding({ left: 10 })
          .border({ width: 1, color: '#ccc' })
          .enterKeyType(EnterKeyType.Send)
          .onChange((value: string) => {
            this.commentValue = value;
          })
          .onSubmit(() => {

          })

      }

      // 评论区展示
      List({ space: 8 }) {
        ForEach(this.commentsList, (item: CommentData) => {
          ListItem() {
            CommentBlock({
              commentInfo: item,
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