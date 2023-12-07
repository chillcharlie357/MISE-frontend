class Message {
  id: number;
  value: string;

  constructor(id: number, value: string) {
    this.id = id;
    this.value = value;
  }
}


@CustomDialog
struct CustomDialogExample {
  @Link textValue: string
  @Link inputValue: string
  @State submitValue: string = ''
  @State arr: Array<Message> = []
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void
  scroller: Scroller = new Scroller()
  private idCount: number = 0;
  private messageValue: string;


  build() {
    Column() {
      // 顶部横条
      Row() {
        RelativeContainer() {
          Text('Q&A Assistant').fontSize(15)
            .alignRules({
              middle:{ anchor:"__container__", align:HorizontalAlign.Center},
              center:{ anchor:"__container__", align:VerticalAlign.Center}
            })
            .id("text1")

          Button({ type: ButtonType.Circle, stateEffect: true }) {
            Image($r("app.media.close")).width(15).height(15)
          }
          .width(20)
          .height(20)
          .alignRules({
            center:{ anchor:"__container__", align:VerticalAlign.Center},
            right: { anchor: "__container__", align: HorizontalAlign.End },
          })
          .backgroundColor(0x65cafe)
          .margin({ right: 12 })
          .align(Alignment.Center)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          })
          .id("button1")
        }.width("100%").height("100%")
      }.margin({ top: 8, bottom: 8 }).width("100%").height(20)

      //聊天界面
      Scroll(this.scroller){
        Column() {
          ForEach(this.arr, (item: Message) => {
            Row(){
              //Text(item.id.toString())
              Text(item.value)
                .height(35)
                .backgroundColor(0xffffff)
                .textAlign(TextAlign.Center)
                .borderRadius(8)
                .borderWidth(8)
                .borderColor(0xffffff)
                .margin({right: 5, left: 5})
              Image($r("app.media.user"))
                .width(35)
                .height(35)
            }.height(35)
            .width("100%")
            .justifyContent(FlexAlign.End)
            .margin({top : 8, bottom: 8})
          }, (item: Message) => item.value)
        }.width('100%')
      }.width("100%")
      .height(550)
      .backgroundColor(0xe6e6e6)

      // 对话输入框
      Row() {
        RelativeContainer() {
          TextInput({ placeholder: '输入你的问题', text: this.messageValue }).height(35).width('80%')
            .alignRules({
              center:{ anchor:"__container__", align:VerticalAlign.Center},
              left:{ anchor:"__container__", align:HorizontalAlign.Start}
            })
            .placeholderFont({ size: 13 })
            .borderRadius(8)
            .id("text_input1")
            .margin({left: 8})
            .enterKeyType(EnterKeyType.Send)
            .onChange((value: string)=>{
              this.messageValue = value;
            })
            .onSubmit((EnterKeyType)=>{
              this.idCount++;
              this.arr.push(new Message(this.idCount, this.messageValue));
              this.messageValue = "";
            })

          Button({ type: ButtonType.Normal, stateEffect: true }) {
            Text("发送").fontColor(0xffffff).fontSize(13)
          }
          .width(50).height(35)
          .alignRules({
            center:{ anchor:"__container__", align:VerticalAlign.Center},
            right: { anchor: "__container__", align: HorizontalAlign.End },
          })
          .backgroundColor(0x65cafe)
          .borderRadius(8)
          .margin({ right: 8 })
          .align(Alignment.Center)
          .onClick(() => {
            this.idCount++;
            this.arr.push(new Message(this.idCount, this.messageValue));
            //this.messageValue = "";
          })
          .id("button2")

        }.width("100%").height("100%")
      }.margin({ top: 8, bottom: 8 }).width("100%").height(40)

      // Flex({ justifyContent: FlexAlign.SpaceAround }) {
      //   Button('cancel')
      //     .onClick(() => {
      //       this.controller.close()
      //       this.cancel()
      //     }).backgroundColor(0xffffff).fontColor(Color.Black)
      //   Button('confirm')
      //     .onClick(() => {
      //       this.inputValue = this.textValue
      //       this.controller.close()
      //       this.confirm()
      //     }).backgroundColor(0xffffff).fontColor(Color.Red)
      // }.margin({ bottom: 10 })
    }
  }
}

@Entry
@Component
struct CustomDialogUser {
  @State textValue: string = ''
  @State inputValue: string = 'assistant'
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: this.onCancel,
      confirm: this.onAccept,
      textValue: $textValue,
      inputValue: $inputValue
    }),
    cancel: this.existApp,
    autoCancel: true,
    alignment: DialogAlignment.Default,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  aboutToDisappear() {
    delete this.dialogController,
    this.dialogController = undefined
  }

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  existApp() {
    console.info('Click the callback in the blank area')
  }

  build() {
    Column() {

      // Button(this.inputValue)
      //   .onClick(() => {
      //     if (this.dialogController != undefined) {
      //       this.dialogController.open()
      //     }
      //   }).backgroundColor(0x317aff)

      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r('app.media.assistant'))
          .width(40)
          .height(40)
      }.backgroundColor(0xffffff)
      .align(Alignment.Center)
      .width(50)
      .height(50)
      .position({x: '80%', y:600,})
      .onClick(() => {
        if (this.dialogController != undefined) {
          this.dialogController.open()
        }
      })

    }.width('100%').margin({ top: 5 })
  }
}

export{ CustomDialogUser }