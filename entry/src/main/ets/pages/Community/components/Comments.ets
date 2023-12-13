import { CommentData, CommentDataGetter, CommentResponse } from '../../../data/data'
import { CommentBlock } from './CommentBlock'
import axios from '../../../axios'
import promptAction from '@ohos.promptAction';

@Component
struct Comments {
  @LocalStorageProp('postId') postId: number = 0
  @StorageProp('userAvatar') avatar: string = "https://dummyimage.com/300/09f.png/fff"
  @StorageProp('username') username: string = ''
  @StorageProp('login_state') login_state: boolean = false
  @State commentsList: Array<CommentData> = []
  @State commentValue: string = ''
  likePosts: Array<number> = []
  private getComments = () => {
    return axios.get<CommentResponse>(`/community/comments/${this.postId}`)
  }
  private postComment = (comment: CommentData) => {
    return axios.post(`/community/comment/${this.postId}`, comment)
  }

  aboutToAppear() {
    this.getComments().then((res) => {
      console.info("Comments: ", JSON.stringify(res.data));
      this.commentsList = res.data;
      console.log("CommentsList: ", this.commentsList)
    }).catch((err) => {
      console.log(err);
    })
    const tokenName: string = AppStorage.Get("tokenName")
    const tokenValue: string = AppStorage.Get("tokenValue")
    axios.get('/user/likeComments', {
      headers: {
        [tokenName]: tokenValue
      }
    }).then((res) => {
      this.likePosts = res.data
      console.log("LikePosts: ", JSON.stringify(this.likePosts))
    }).catch((err) => {
      console.error(JSON.stringify(err))
    })
    console.log(JSON.stringify(this.likePosts));
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
        TextInput({ placeholder: 'Write a comment...', text: this.commentValue })
          .width('80%')
          .height(40)
          .borderRadius(20)
          .padding({ left: 10 })
          .border({ width: 1, color: '#ccc' })
          .enterKeyType(EnterKeyType.Send)
          .onChange((value: string) => {
            this.commentValue = value;
            if (this.login_state == false) {
              promptAction.showToast({
                message: "请先登录"
              })
              return
            }
          })
          .onSubmit(() => {
            if (this.login_state == false) {
              promptAction.showToast({
                message: "请先登录"
              })
              return
            }
            const newComment: CommentData = {
              id: this.postId,
              content: this.commentValue,
              username: this.username,
              avatar: this.avatar,
              likes: 0
            }
            this.commentValue = ''
            this.commentsList.push(newComment)
            this.postComment(newComment)
              .then((res) => {
                console.info(JSON.stringify(res))
              }).catch((err) => {
              console.error(JSON.stringify(err))
            })
          })

      }

      // 评论区展示
      List({ space: 8 }) {
        ForEach(this.commentsList, (item: CommentData) => {
          ListItem() {
            CommentBlock({
              commentInfo: item,
              isLiked: this.likePosts.includes(item.id)
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