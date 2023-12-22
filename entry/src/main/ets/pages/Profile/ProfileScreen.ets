import promptAction from '@ohos.promptAction'
import hilog from '@ohos.hilog'

import axios from '../../axios'
import { UserProfileResponse } from '../../data/data'
import router from '@ohos.router'
import image from '@ohos.multimedia.image'
import { ProfileContent } from './compontents/ProfileContent'
import { Avatar } from './compontents/Avatar'
import { BeforeLog } from './compontents/BeforeLog'
import UnLoginPage from './UnLoginPage'

@Entry
@Component
struct ProfileScreen {
  listItem: string[] = ["个人信息", "历史记录", "收藏夹"]
  @State username: string = ""
  @State avatarUrl: string = ""
  @State description: string = ""
  @State uid: string = ''
  @State followers: number = 0
  @State following: number = 0
  @StorageLink('login_state') login_state: boolean = false

  @State login_out_show: string = "log out"
  @State des:string = ""
  @State usn:string = ""

  aboutToAppear() {
    console.info("ProfileScreen appear")
    const tokenName: string = AppStorage.Get("tokenName")
    const tokenValue: string = AppStorage.Get("tokenValue")
    console.info("Profile tokenName:"+tokenName)
    console.info("Profile tokenValue:"+tokenValue)

    if (this.login_state) {
      axios.get<UserProfileResponse>('/user/info', {
        headers: {
          [tokenName]: tokenValue
        }
      })
        .then((res) => {
          console.log("UserProfileResponse: " + JSON.stringify(res.data))

          this.username = res.data.username
          this.description = res.data.description
          this.avatarUrl = res.data.avatarUrl
          this.followers = res.data.followers
          this.following = res.data.following
          this.uid = '' + res.data.id
          AppStorage.SetOrCreate('username', res.data.username)
          AppStorage.SetOrCreate('description',res.data.description)
          AppStorage.SetOrCreate('userAvatar', res.data.avatarUrl)
          AppStorage.SetOrCreate('userId', '' + res.data.id)

        })
        .catch((err) => {
          console.error(err);
        })
    }
  }

  onPageShow(){
    console.info("ProfileScreen onShow")
  }

  build() {
    Column() {
      Avatar({
        avatarUrl: this.avatarUrl,
        username: this.username,
        description: this.description,
        uid: this.uid
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