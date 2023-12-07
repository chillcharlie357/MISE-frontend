@Component
struct PostDeny {


  build() {
    Column() {
      Text("您还未登录呦")
        .fontSize(20)
        .textAlign(TextAlign.Start)

        .padding({ top: 20 })
    }
    .height("100%")
    .width("100%")
  }


}

export { PostDeny }