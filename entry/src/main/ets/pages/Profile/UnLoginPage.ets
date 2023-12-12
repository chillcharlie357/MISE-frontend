import router from '@ohos.router'

@Entry
@Component
struct UnLoginPage {
  build() {
    Row() {
      Column() {
        Image($r('app.media.logo'))
          .width("95%")
        Button("点我登录/注册")
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Profile/LoginPage'
            })
          })
          .margin({top: 50})
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor(Color.White)
  }
}

export default UnLoginPage;