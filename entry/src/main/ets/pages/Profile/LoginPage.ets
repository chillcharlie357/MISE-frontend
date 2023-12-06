import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import CommonConstants from '../../common/constants/LoginPage_CommonConstants';
import axios from '../../axios';
import { LoginRequest, LoginResponse } from '../../data/data';

@Extend(TextInput) function inputStyle() {
  .placeholderColor($r('app.color.loginPage_placeholder_color'))
  .height($r('app.float.login_input_height'))
  .fontSize($r('app.float.big_text_size'))
  .backgroundColor($r('app.color.loginPage_background'))
  .width(CommonConstants.FULL_PARENT)
  .padding({ left: CommonConstants.INPUT_PADDING_LEFT })
  .margin({ top: $r('app.float.input_margin_top') })
}

@Extend(Line) function lineStyle() {
  .width(CommonConstants.FULL_PARENT)
  .height($r('app.float.line_height'))
  .backgroundColor($r('app.color.loginPage_line_color'))
}

@Extend(Text) function blueTextStyle() {
  .fontColor($r('app.color.loginPage_blue_text_color'))
  .fontSize($r('app.float.small_text_size'))
  .fontWeight(FontWeight.Medium)
}

@Entry
@Component
struct LoginPage {
  @State email: string = 'default@test';
  @State password: string = 'default';
  @StorageLink('login_state') login_state: boolean = false

  login(): void {
    if (this.email === '' || this.password === '') {
      promptAction.showToast({
        message: $r('app.string.input_empty_tips')
      })

    } else {
      const loginRequest: LoginRequest = {
        email: this.email,
        password: this.password
      }
      axios.post<LoginResponse>('/user/login', loginRequest)
        .then((res) => {
          if (res.status === 200) {
            // login success
            console.log(JSON.stringify(res.data))
            this.login_state = true
            router.pushUrl({ url: 'pages/Profile/ProfileScreen' })
          }
        })
        .catch((error: any) => {
          promptAction.showToast({
            message: "login failed"
          })
          console.log(error)
        })

    }
  }

  build() {


    Column() {

      Row() {
        Image($r('app.media.back_icon'))
          .height(48)
          .width(48)
          .onClick(() => {
            router.back()
          })

      }
      .height('50')
      .width(CommonConstants.FULL_PARENT)

      Line().lineStyle()
      Line().lineStyle()

      Image($r('app.media.icon'))
        .width($r('app.float.logo_image_size'))
        .height($r('app.float.logo_image_size'))
        .margin({ top: $r('app.float.logo_margin_top'), bottom: $r('app.float.logo_margin_bottom') })

      Text($r('app.string.login_page'))
        .fontSize($r('app.float.page_title_text_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r("app.color.loginPage_title_text_color"))

      Text($r('app.string.login_more'))
        .fontSize($r('app.float.normal_text_size'))
        .fontColor($r("app.color.loginPage_login_more_text_color"))
        .margin({ bottom: $r('app.float.login_more_margin_bottom'), top: $r('app.float.login_more_margin_top') })

      TextInput({ placeholder: $r('app.string.account') })
        .maxLength(CommonConstants.INPUT_ACCOUNT_LENGTH)
        .type(InputType.Number)
        .inputStyle()
        .onChange((value: string) => {
          this.email = value;
        })

      Line().lineStyle()

      TextInput({ placeholder: $r('app.string.password') })
        .maxLength(CommonConstants.INPUT_ACCOUNT_LENGTH)
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.password = value;
        })

      Line().lineStyle()

      Row() {
        Text($r('app.string.register_account')).blueTextStyle()
          .onClick(() => {
            router.pushUrl({ url: 'pages/Profile/RegisterScreen' })
          })


        Text($r('app.string.forgot_password')).blueTextStyle()


      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(CommonConstants.FULL_PARENT)
      .margin({ top: $r('app.float.forgot_margin_top') })

      Button($r('app.string.login'), { type: ButtonType.Capsule })
        .width(CommonConstants.BUTTON_WIDTH)
        .height($r('app.float.login_button_height'))
        .fontSize($r('app.float.normal_text_size'))
        .fontWeight(FontWeight.Medium)
        .backgroundColor($r("app.color.loginPage_login_button_color"))
        .margin({ top: $r('app.float.login_button_margin_top'), bottom: $r('app.float.login_button_margin_bottom') })
        .onClick(() => {

          this.login()

        })

    }
    .backgroundColor($r('app.color.loginPage_background'))
    .height(CommonConstants.FULL_PARENT)
    .width(CommonConstants.FULL_PARENT)
    .padding({
      left: $r('app.float.page_padding_hor'),
      right: $r('app.float.page_padding_hor'),
      bottom: $r('app.float.login_page_padding_bottom')
    })
  }
}
