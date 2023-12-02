import promptAction from '@ohos.promptAction'
import hilog from '@ohos.hilog'

import axios from '../../axios'
import { UserProfile } from '../../data/data'
import router from '@ohos.router'
import image from '@ohos.multimedia.image'


let options = {
  alphaType: 0, // 透明度
  editable: false, // 是否可编辑
  pixelFormat: 3, // 像素格式
  scaleMode: 1, // 缩略值
  size: { height: 100, width: 100 }
} // 创建图片大

@Entry
@Component
struct ProfileScreen {
  image_add = 'app.media.profile_default_user'
  private listItem: string[] = ["个人信息", "历史记录", "收藏夹"]
  @State username: string = "USER"
  @State avatar: string = ""
  @State description: string = "介绍一下你自己吧"
  @State gallery: string[] = []
  @State login_state: boolean = true
  @State login_out_show: string = "log out"
  //TODO:无法加载网络图片
  aboutToAppear() {
    console.info("Page Show")
    axios.get<UserProfile>('/users/profile')
      .then((res) => {
        // hilog.info(0x1,"1",res.data)
        console.log("Data: " + JSON.stringify(res.data))
        this.username = res.data.name
        this.description = res.data.description
        this.gallery = res.data.gallery
        this.avatar = res.data.avatar
        this.gallery = res.data.gallery

        // image.createImageSource(res.data.avatar)
        //   .createPixelMap(options)
        //   .then((pixelMap) => {
        //     this.avatar = pixelMap
        //   })
        //
        // res.data.gallery.map(
        //   (item) => image.createImageSource(item)
        //     .createPixelMap(options)
        //     .then(
        //       (pixelMap) => {
        //         this.gallery.push(pixelMap)
        //       }
        //     ))
      })
      .catch((err) => {
        console.error(err);
      })
  }

  build() {
    Column() {
      Row() {
        Row() {

        }
        .width("85%")

        Button() {
          Image($r("app.media.ic_settings"))
            .height(40)
            .width(40)
            .backgroundColor(Color.White)
        }
        .onClick(() => {
          promptAction.showToast({
            message: "你点击了设置按钮",
            duration: 3000
          })
        })
        // .backgroundColor(Color.White)


      }
      .height('10%')
      .width('100%')


      Column() {


        Row({ space: 20 }) {

          if (this.login_state) {
            Image(this.avatar)
              .width(90)
              .height(90)
              .margin({ left: '15%' })
            // .borderStyle(BorderStyle.Dotted)
            // .borderWidth(1)
            // .borderColor(Color.Blue)
            Text(this.username)
              .fontSize(30)
            // .margin({bottom:'10%'})
          }
          else {
            Image(this.avatar)
              .width(90)
              .height(90)
              .margin({ left: '15%' })

            Text(this.login_out_show)
              .fontSize(30)
              .onClick(() => {
                promptAction.showToast({
                  message: "你进行了登录操作",
                  duration: 3000
                })
                router.pushUrl({
                  url: 'pages/Profile/LoginPage'
                })

                // this.login_state = true
              })
            // .margin({bottom:'10%'})

          }
        }
        .backgroundColor(Color.White)
        .width('80%')

        if (this.login_state) {
          Text(this.description)
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

            if (this.login_state) {

              ForEach(this.gallery, (item: string) => {
                Column({ space: 20 }) {
                  Row() {
                    Image(item)
                      .width(90)
                      .height(90)
                    Text("item")
                      .fontSize(20)
                  }
                }
              })

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

export { ProfileScreen }