@CustomDialog
export struct HintDialog {
  private controller: CustomDialogController
  private title = '标题'
  private content = '内容'
  private btnCancelText = '取消'
  private btnConfirmText = '确定'
  private cancel: () => void
  private confirm: () => void

  build() {
    Column() {
      Text(this.title)
        .textAlign(TextAlign.Center)
        .width('100%')
        .fontSize(20)
        .padding(15)

      Text(this.content)
        .fontSize(17)
        .padding(15)

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button(this.btnCancelText)
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(Color.White)
          .fontColor('#3879F8')
          .fontSize(16)

        Button(this.btnConfirmText)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          }).backgroundColor(Color.White)
          .fontColor('#3879F8')
          .fontSize(16)
      }.margin({ top: 10, bottom: 15 })
    }
  }
}
