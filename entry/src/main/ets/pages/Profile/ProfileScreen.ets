import promptAction from '@ohos.promptAction'
import router from '@ohos.router';
@Entry
@Component
struct ProfileScreen {
  @State message: string = 'Profile'
  image_add = 'app.media.profile_default_user'

  private listItem:string[] = ["个人信息","历史记录","收藏夹"]

  @State Username: string = "USER"
  @State UserPersonalSign: string = "介绍一下你自己吧"
  @State PictureAbstrate: string[] =["作品1:xxxxxxxx","作品2:xxxxxxxx","作品3:xxxxxxxx"]
  @State login_state:boolean = false
  @State login_out_show: string = "点我登录"

  build() {
    Column() {
      Row(){
        Row(){

        }
        .width("85%")

        Button()
        {
          Image($r("app.media.ic_settings"))
            .height(40)
            .width(40)
            .backgroundColor(Color.White)
        }
        .onClick(() =>
        {
          promptAction.showToast({
            message:"你点击了设置按钮",
            duration:3000
          })
        })
        // .backgroundColor(Color.White)


      }
      .height('10%')
      .width('100%')


      Column() {
        // Text("123")
        //   .fontSize(20)
        //   .padding({bottom:300})

        // Row(){
        //   Text('123')
        // }
        // .height('5%')
        //
        // Text(this.message)
        //   .fontSize(50)
        //   .fontWeight(FontWeight.Bold)


        Row({space:20}){

          if(this.login_state)
            {
              Image($r("app.media.profile_default_user"))
                .width(90)
                .height(90)
                .margin({left:'15%'})
              // .borderStyle(BorderStyle.Dotted)
              // .borderWidth(1)
              // .borderColor(Color.Blue)
              Text(this.Username)
                .fontSize(30)
                // .margin({bottom:'10%'})
            }
          else
          {
            Image($r("app.media.profile_default_user"))
              .width(90)
              .height(90)
              .margin({left:'15%'})

            Text(this.login_out_show)
              .fontSize(30)
              .onClick(() =>{
                promptAction.showToast({
                  message: "你进行了登录操作",
                  duration: 3000
                })
                this.login_state = true
              })
              // .margin({bottom:'10%'})

          }
        }
        .backgroundColor(Color.White)
        .width('80%')

        if(this.login_state)
        {
          Text(this.UserPersonalSign)
            .fontSize(20)
            .padding({ top: 20 })
        }

        Scroll() {
          Column() {
            List() {
              ForEach(this.listItem,
                (func: string, index) => {
                  ListItem() {
                    Text(func)
                      .fontSize(20)
                      .margin({ left: 20 })
                      .width("90%")
                      .onClick(() => {
                        promptAction.showToast({
                          message: "你点击了" + func + "按钮",
                          duration: 3000
                        })
                      })

                  }.margin({ top: 20, bottom: 20 })

                }, func => func
              )
            }
            .divider({ strokeWidth: 2, color: Color.Black })
            // .height(100)

            if(this.login_state) {
              Column({ space: 20 }) {
                Row() {
                  Image($r("app.media.profile_default_user"))
                    .width(90)
                    .height(90)
                    // .borderStyle(BorderStyle.Dotted)
                    // .borderWidth(1)
                    // .borderColor(Color.Blue)
                  Text(this.PictureAbstrate[0])
                    .fontSize(20)
                }

                Row() {
                  Image($r("app.media.profile_default_user"))
                    .width(90)
                    .height(90)
                    // .borderStyle(BorderStyle.Dotted)
                    // .borderWidth(1)
                    // .borderColor(Color.Blue)
                  Text(this.PictureAbstrate[1])
                    .fontSize(20)
                }

                Row() {
                  Image($r("app.media.profile_default_user"))
                    .width(90)
                    .height(90)
                    // .borderStyle(BorderStyle.Dotted)
                    // .borderWidth(1)
                    // .borderColor(Color.Blue)
                  Text(this.PictureAbstrate[2])
                    .fontSize(20)
                }

                Row() {
                  Image($r("app.media.profile_default_user"))
                    .width(90)
                    .height(90)
                    // .borderStyle(BorderStyle.Dotted)
                    // .borderWidth(1)
                    // .borderColor(Color.Blue)
                  Text(this.PictureAbstrate[2])
                    .fontSize(20)
                }
              }
            }


          }
        }



      }
      .width('100%')
      .height('60%')


    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.snow_grey'))


  }
}

export {ProfileScreen}