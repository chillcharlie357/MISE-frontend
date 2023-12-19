import promptAction from '@ohos.promptAction'
@Component
struct UserInfoText{
  // private ImageUrl?:Resource
  // @State title:string = "title"
  // @State content:string = "content"

  // is_on_change:boolean = false
  // @State rotateAngle: number = 0
  // @State
  @State nickname:string = "nickname"


  build()
  {
    Column() {
      Row() {
        // Image()
        Image($r("app.media.ic_nickname"))
          .width(24)
          .height(24)
          .margin({ left: 12 })

        TextInput({ placeholder: "昵称" })
          .fontSize(16)
          .padding({ left: 12 })
          .placeholderColor("#99000000")
          .backgroundColor(Color.White)
          .fontWeight(FontWeight.Normal)
          .fontStyle(FontStyle.Normal)
          .fontColor(Color.Black)
          .margin({ right: 32 })
          .height(48)
          .layoutWeight(1)
          .onChange((value:string) =>{
            this.nickname = value
          })


      }
      .margin({ top: '24' })
      .borderRadius(24)
      .backgroundColor(Color.White)
      .width('93.3%')
      .height(64)

      Text(this.nickname)
    }
  }

}

@Component
@Preview
struct TextPre{
  build(){
    UserInfoText()
      .width("100%")
      .height("100%")
  }
}

export {UserInfoText}