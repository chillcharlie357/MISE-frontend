import { CardView } from '@isrc/easyui'
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
@Component
struct BeforeLog {
  private quest:string = "点此登录"
  private image_:string = 'app.media.profile_default_user'
  private default_image:Resource = $r('app.media.profile_default_user')
  private url:string = "https://dummyimage.com/120x90"


  build() {
    Row() {
      Column() {
        Row() {
          Row({ space: 10 }) {
            Image(this.default_image)
              .height(50)
              .width(50)
              // .borderWidth(1)
              // .borderStyle(BorderStyle.Solid)
              // .borderColor("#ffc3c3c3")
              // .borderRadius(5)
              .alignSelf(ItemAlign.Center)
              .margin(10)

            Text(this.quest)
              .fontSize(25)
              .padding({left:10})
              .onClick(() =>{
                promptAction.showToast({
                  message:"你正在尝试登陆"

                })

                router.pushUrl
                ({
                  url:"pages/Profile/LoginPage"
                });
              })



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
        .height(100)
        .margin(6)
      }
    }
  }
}


@Component
@Preview
struct BeforeLogPre {
  private avatarUrl: string = "http://dummyimage.com/120x90"
  private userName: string = "Test"
  private description: string = "description"

  build() {
    Row() {
      // CardView()
      BeforeLog()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}

export { BeforeLog }