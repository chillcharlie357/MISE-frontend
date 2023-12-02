import promptAction from '@ohos.promptAction'
import hilog from '@ohos.hilog'

import axios from '../../axios'
import { UserProfile } from '../../data/data'
import router from '@ohos.router'
import image from '@ohos.multimedia.image'
import { ProfileContent } from './ProfileContent'
import { Avatar } from './Avatar'

@Entry
@Component
struct ProfileScreen {
  image_add = 'app.media.profile_default_user'
  private listItem: string[] = ["个人信息", "历史记录", "收藏夹"]
  @State username: string = "USER"
  @State avatarUrl: string = ""
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
        this.avatarUrl = res.data.avatar
        this.gallery = res.data.gallery

        // image.createImageSource(res.data.avatarUrl)
        //   .createPixelMap(options)
        //   .then((pixelMap) => {
        //     this.avatarUrl = pixelMap
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

      Avatar({
        avatarUrl: this.avatarUrl,
        userName: this.username,
        description: this.description
      })
      ProfileContent()

    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.snow_grey'))

  }
}


@Preview
@Component
struct ProfilePre {
  private avatarUrl: string = "http://dummyimage.com/120x90"
  private userName: string = "Test"
  private description: string = "description"

  build() {
    Row() {
      ProfileScreen({
        username: this.userName,
        avatarUrl: this.avatarUrl,
        description: this.description
      })
    }
    .width('100%')
    .height('100%')
  }
}


export { ProfileScreen }