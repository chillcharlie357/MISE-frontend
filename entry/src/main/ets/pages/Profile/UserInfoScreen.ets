import { EditRequest, UserProfileResponse } from '../../data/data'
import axios from '../../axios'
import { UserInfoText } from './compontents/UserInfoText'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { describe } from '@ohos/hypium'
import App from '@system.app'

@Extend(Line) function lineStyle() {
  .width("93.3%")
  .height($r('app.float.line_height'))
  .backgroundColor($r('app.color.loginPage_line_color'))
}

@Entry
@Component
struct UserInfoScreen {
  @State username:string = "username"
  @State description:string = "description"
  @State avatarUrl: string = "https://dummyimage.com/120x90"
  @State followers: number = 0
  @State following: number = 0
  @State uid: number = 0;
  @State email:string = "";

  private userName:string = ""
  private Description:string = ""
  // @State username:string = "nickname"


  save():void{
    if(this.userName === '')
    {
      promptAction.showToast({
        "message":"昵称不能为空"
      })
      return
    }
    else
    {
      if(this.Description === '')
        this.Description = "这个人很懒，什么都没有留下"

      const editRequest:EditRequest = {
        avatarUrl:this.avatarUrl,
        username:this.userName,
        description:this.Description,
        email:this.email,
        followers:this.followers,
        following:this.following,
        id:this.uid
      }

      editRequest.username = this.userName
      editRequest.description = this.Description
      console.log("new username = " + editRequest.username)
      console.log("new description = " + editRequest.description)
      console.log("editRequest = " + JSON.stringify(editRequest))

      // console.log()

      axios.post<EditRequest>('/user/edit', editRequest)
        .then((res) => {
            if (res.status === 200) {
              promptAction.showToast({
                "message":"信息已更改"
              })
            }
        })
        .catch((err) => {
          console.error("UserInfoScreenErr Returnerr:"+err);
          promptAction.showToast({
            "message":"请求失败，请检查连接"
          })
        })

      AppStorage.SetOrCreate('username',this.userName)
      AppStorage.SetOrCreate('description',this.Description)
      AppStorage.SetOrCreate('userAvatar',this.avatarUrl)
      AppStorage.SetOrCreate('userUId',this.uid.toString())
      console.log("UserInfoScreenSet username: " + AppStorage.Get('username'))
      console.log("UserInfoScreenSet description: " + AppStorage.Get('description'))
      console.log("UserInfoScreenSet userAvatar: " + AppStorage.Get('userAvatar'))
      console.log("UserInfoScreenSet userUId: " + AppStorage.Get('userUId'))
    }
  }

  back_intent():void{

      try {
        promptAction.showDialog({
          'title': "确定离开了吗？",
          'message': "别忘了点击右上角的按钮保存哟！\n\n",
          'buttons': [
            {
              text: "我已确定！",
              color: '#000000'
            },
            {
              text: "再考虑考虑",
              color: '#000000'
            }]
        },
          (err, data) => {
            if (err) {
              console.info('showDialog err: ' + err);
              return;
            }
            console.info('showDialog success callback, click button: ' + data.index);
            if (data.index === 0)
              //this.save()
            {
              router.back({
                url:'pages/Index',
                params:{
                  username:this.userName,
                  description:this.Description
                }
              })
            }
          })

      }
      catch (err)
      {
        console.error("UserInfoScreenErr backIntent:"+err);
      }


  }

  aboutToAppear() {
    console.info("UserInfoScreen appear")
    const tokenName: string = AppStorage.Get("tokenName")
    const tokenValue: string = AppStorage.Get("tokenValue")
    console.info("Userinfo tokenName:"+tokenName)
    console.info("Userinfo tokenValue:"+tokenValue)



    axios.get<UserProfileResponse>('/user/info', {
      headers: {
        [tokenName]: tokenValue
      }
    })
      .then((res) => {
          console.log("UserInfoScreen res = "+ res)
          console.log("UserInfoScreen UserProfileResponse: " + JSON.stringify(res.data))
          console.log("UserInfoScreen Username: " + res.data.username)
          console.log("UserInfoScreen Description: " + res.data.description)

          this.username = res.data.username
          this.description = res.data.description
          this.avatarUrl = res.data.avatarUrl
          this.uid = res.data.id
          this.followers = res.data.followers
          this.following = res.data.following
          this.email = res.data.email

          // AppStorage.SetOrCreate('username', res.data.username)
          // AppStorage.SetOrCreate('userAvatar', res.data.avatarUrl)
      })
      .catch((err) => {
        console.error("UserInfoScreenErr:"+err);
      })
    }


  build()
  {
    Column(){
      Row(){
        Column(){
          Image($r("app.media.back_icon"))
            .height(50)
            .width(50)
            .onClick(() =>{
              this.back_intent()
            })
        }
        // .backgroundColor(Color.Red)
        .width("20%")
        // .backgroundColor(Color.Red)
        Column(){

        }
        .width("60%")

        Column() {
          Image($r("app.media.ic_save"))
            .height(40)
            .width(40)
            // .margin({right:10})
        }
        .width("15%")
        .onClick(() =>{
          this.save()
        })
        // .backgroundColor(Color.Red)
        // .margin({right:20})
      }
      .width("100%")
      .padding({top:10})

      // Column(){
      //
      // }
      // .backgroundColor($r('app.color.loginPage_line_color'))
      // .height(1)
      Line().lineStyle().margin({top:10})


      Image(this.avatarUrl)
        .width(84)
        .height(84)
        .margin({top:"10%"})

      Text("用户信息")
        .fontSize(16)
        .margin({top:"4%"})

      // UserInfoText()
        // .width("100%")

      Column() {
        Row() {
          // Image()
          Image($r("app.media.ic_nickname"))
            .width(32)
            .height(32)
            .margin({ left: 12 })

          TextInput({ placeholder: "新昵称" })
            .fontSize(24)
            .padding({ left: 12 })
            .placeholderColor("#99000000")
            .backgroundColor(Color.White)
            .fontWeight(FontWeight.Normal)
            .fontStyle(FontStyle.Normal)
            .fontColor(Color.Black)
            .margin({ right: 32 })
            .height(64)
            .layoutWeight(1)
            .onChange((value:string) =>{
              this.username = value
              this.userName = value
            })


        }
        .margin({ top: '8%' })
        .borderRadius(24)
        .backgroundColor(Color.White)
        .width('93.3%')
        .height(80)

        // Text(this.username)

        Row() {
          // Image()
          Image($r("app.media.ic_signature"))
            .width(32)
            .height(32)
            .margin({ left: 12 })

          TextInput({ placeholder: "新描述" })
            .fontSize(24)
            .padding({ left: 12 })
            .placeholderColor("#99000000")
            .backgroundColor(Color.White)
            .fontWeight(FontWeight.Normal)
            .fontStyle(FontStyle.Normal)
            .fontColor(Color.Black)
            .margin({ right: 32 })
            .height(64)
            .layoutWeight(1)
            .onChange((value:string) =>{
              this.description = value
              this.Description = value
            })


        }
        .margin({ top: '5%' })
        .borderRadius(24)
        .backgroundColor(Color.White)
        .width('93.3%')
        .height(80)

        // Text(this.description)
      }




    }
    .backgroundColor("#F5F5F5")
    .width("100%")
    .height("100%")
  }


}