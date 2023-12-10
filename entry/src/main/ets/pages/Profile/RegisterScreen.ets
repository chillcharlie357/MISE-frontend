import router from '@ohos.router'
import CommonConstants from '../../common/constants/LoginPage_CommonConstants'
import axios from '../../axios'
import { RegisterRequest, RegisterResponse } from '../../data/data'

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
struct RegisterScreen {
  @State email: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State username: string = '';
  @State isPasswordMatch: boolean = true;
  @State isEmailValid: boolean = true;
  register: () => void = () => {
    const registerRequest: RegisterRequest = {
      email: this.email,
      password: this.password,
      username: this.username
    }
    console.info('register: ' + JSON.stringify(registerRequest))

    if (this.password != this.confirmPassword) {
      console.error('password not match')
      this.isPasswordMatch = false
      return
    }

    axios.post<RegisterResponse>('/user/register', registerRequest).then((res) => {
      console.info(JSON.stringify(res))
      if (res.status == 201) {
        router.pushUrl({
          url: 'pages/Profile/LoginPage'
        })
      }
    }).catch((err) => {
      if (err.response.status == 400) {
        console.error(err.response.data.msg)
        this.isEmailValid = false
      }
      console.error(JSON.stringify(err))
    })
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

      Text($r('app.string.register_page'))
        .fontSize($r('app.float.page_title_text_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r("app.color.loginPage_title_text_color"))

      TextInput({ placeholder: $r('app.string.username') })
        .maxLength(CommonConstants.INPUT_ACCOUNT_LENGTH)
        .type(InputType.Email)
        .inputStyle()
        .onChange((value: string) => {
          this.username = value;
        })

      Line().lineStyle()
      TextInput({ placeholder: $r('app.string.email') })
        .maxLength(CommonConstants.INPUT_ACCOUNT_LENGTH)
        .type(InputType.Email)
        .inputStyle()
        .onChange((value: string) => {
          this.email = value;
        })
        .bindPopup(!this.isEmailValid, {
          message: "邮箱无效或已存在",
          maskColor: Color.Red,
        })

      Line().lineStyle()

      TextInput({ placeholder: $r('app.string.password') })
        .maxLength(CommonConstants.INPUT_ACCOUNT_LENGTH)
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.password = value;
        })
        .bindPopup(!this.isPasswordMatch, {
          message: "密码与确认密码不匹配",
          maskColor: Color.Red,
        })

      Line().lineStyle()

      TextInput({ placeholder: $r('app.string.confirm_password') })
        .maxLength(CommonConstants.INPUT_ACCOUNT_LENGTH)
        .type(InputType.Password)
        .inputStyle()
        .onChange((value: string) => {
          this.confirmPassword = value;
        })

      Line().lineStyle()

      Button($r('app.string.register'), { type: ButtonType.Capsule })
        .width(CommonConstants.BUTTON_WIDTH)
        .height($r('app.float.login_button_height'))
        .fontSize($r('app.float.normal_text_size'))
        .fontWeight(FontWeight.Medium)
        .backgroundColor($r("app.color.loginPage_login_button_color"))
        .margin({ top: $r('app.float.login_button_margin_top'), bottom: $r('app.float.login_button_margin_bottom') })
        .onClick(() => {
          this.register()
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