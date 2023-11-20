@Entry
@Component
struct CommunityScreen {
  @State message: string = 'Community'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}

export { CommunityScreen }