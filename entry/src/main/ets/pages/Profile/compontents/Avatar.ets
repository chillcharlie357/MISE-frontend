import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import axios from '@ohos/axios';

@Component
struct Avatar {
  @Prop avatarUrl: string
  @Prop username: string
  @Prop description: string
  @Prop uid: string
  @StorageLink('login_state') login_state: boolean = false
  @StorageLink('description') des: string = this.description
  @StorageLink('username') usr: string = this.username

  aboutToAppear() {
    console.info("avatarUrl: " + this.avatarUrl)
    console.log("Avater username: " + this.usr)
    console.log("Avater description: " + this.des)
  }

  logout_trial(): void {
    try {
      promptAction.showDialog({
        'title': "登出提示",
        'message': "你确定要登出吗？",
        'buttons': [
          {
            text: "确定",
            color: '#000000'
          },
          {
            text: "取消",
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
            this.login_state = false
        })

      axios.post('/user/logout').then((res) => {
        console.info('logout success: ' + JSON.stringify(res));
      }).catch((err) => {
        console.info('logout failed: ' + JSON.stringify(err));
      });

      AppStorage.SetAndProp('tokenName', '');
      AppStorage.SetAndProp('tokenValue', '');
    } catch (error) {
      console.error(`showDialog args error code is ${error.code}, message is ${error.message}`);
    }
    ;
  }

  build() {
    Row() {
      Column() {
        Row() {
          Row({ space: 10 }) {
            Image(this.avatarUrl)
              .height(50)
              .width(50)
              .borderWidth(1)
              .borderStyle(BorderStyle.Solid)
              .borderColor("#ffc3c3c3")
              .borderRadius(5)
              .alignSelf(ItemAlign.Center)
              .objectFit(ImageFit.Auto)
            // .onClick(() =>{
            //   console.log("AvaterClick username: " + this.usr)
            //   console.log("AvaterClick description: " + this.des)
            // })

            Column({ space: 5 }) {
              // Text(this.username)
              Text(this.usr)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)

              Row() {
                Text('UID: ')
                  .fontSize(15)
                Text(this.uid)
                  .fontSize(15)
                  .baselineOffset(TextAlign.Start)
              }
            }.width("50%")
            .alignItems(HorizontalAlign.Start)
            .padding({ bottom: 15 })

            Image($r('app.media.ic_settings'))
              .height(30)
              .width(30)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Profile/UserInfoScreen' })
              })

            Image($r('app.media.profile_logout'))
              .height(30)
              .width(30)
              .onClick(() => {
                this.logout_trial()
              })
          }
          .padding({ left: 10, top: 15 })

        }.layoutWeight(1)

        // Text(this.description)
        Text(this.des)
          .fontSize(15)
          .layoutWeight(2)
          .alignSelf(ItemAlign.Start)
          .padding({ left: 15 })
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
    .height(200)
    .margin(6)
  }
}


@Component
@Preview
struct AvatarPre {
  private avatarUrl: string = "http://dummyimage.com/120x90"
  private userName: string = "Test"
  private description: string = "description"

  build() {
    Row() {
      // CardView()
      // Avatar({
      //   avatarUrl: this.avatarUrl,
      //   username: this.userName,
      //   description: this.description
      // })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}

export { Avatar }