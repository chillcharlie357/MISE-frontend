import promptAction from '@ohos.promptAction'
import hilog from '@ohos.hilog'

import axios from '../../axios'
import { UserProfileResponse } from '../../data/data'
import router from '@ohos.router'
import image from '@ohos.multimedia.image'
import { ProfileContent } from './compontents/ProfileContent'
import { Avatar } from './compontents/Avatar'
import { BeforeLog } from './compontents/BeforeLog'

@Entry
@Component
struct ProfileScreen {
  image_add = 'app.media.profile_default_user'
  private listItem: string[] = ["个人信息", "历史记录", "收藏夹"]
  @State username: string = "USER"
  @State avatarUrl: string = ""
  @State description: string = "介绍一下你自己吧"
  @State gallery: string[] = []
  @StorageLink('login_state') login_state: boolean = false
  @State login_out_show: string = "log out"

  aboutToAppear() {
    console.info("Page Show")
    axios.get<UserProfileResponse>('/users/profile')
      .then((res) => {
        console.log("Data: " + JSON.stringify(res.data))
        this.username = res.data.name
        this.description = res.data.description
        this.gallery = res.data.gallery
        this.avatarUrl = res.data.avatar
        this.gallery = res.data.gallery
      })
      .catch((err) => {
        console.error(err);
      })
  }

  build() {
    Column() {

      if (this.login_state) {
        Avatar({
          avatarUrl: this.avatarUrl,
          userName: this.username,
          description: this.description
        })
      } else {
        BeforeLog()
      }
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
  private avatarUrl: string = "https://dummyimage.com/120x90"
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