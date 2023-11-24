@Entry
@Component
struct ProfileScreen {
  @State message: string = 'Profile'
  image_add = 'app.media.profile_default_user'

  @State Username: string = "USER"
  @State UserPersonalSign: string = "Hello, world!"

  build() {
    Row() {
      Column() {
        // Text("123")
        //   .fontSize(20)
        //   .padding({bottom:300})

        Row(){
          Text('123')
        }
        .height('5%')

        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Row({space:20}){
          Image($r("app.media.profile_default_user"))
            .width(90)
            .height(90)
            .borderStyle(BorderStyle.Dotted)
            .borderWidth(1)
            .borderColor(Color.Blue)

          Text(this.Username)
            .fontSize(40)

        }

        Text(this.UserPersonalSign)
          .fontSize(20)
          .padding({top:20})


      }
      .width('100%')


    }
    .height('100%')


  }
}

export {ProfileScreen}