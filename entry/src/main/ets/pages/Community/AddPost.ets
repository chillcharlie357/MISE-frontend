@Entry
@Component
@Preview
struct AddPostPage{
  @State title: string = ''
  @State content: string = ''
  @State pictureURL: Array<string> = ['pages/icon/ic_public_favor.svg']
  scroller: Scroller = new Scroller()

  build() {
    Column(){
      Text('发布')
        .textAlign(TextAlign.Center)
        .fontSize(30)
        .padding(10)
        .width('100%')

      TextInput({placeholder:'请输入标题'})
        .height(40)
        .textAlign(TextAlign.Start)
        .fontSize(15)
        .margin({top:10})
        .width('95%')
        .onChange((value)=>{
          this.title=value
        })

      Divider()
        .strokeWidth(2)
        .margin({top:10})

      TextArea({placeholder:'请输入正文'})
        .height('40%')
        .margin({top:10})
        .width('95%')
        .onChange((value)=>{
          this.content=value
        })

      Scroll(this.scroller) {
        Row() {
          ForEach(this.pictureURL, (item) => {
            Image(item)
              .height(80)
              .width(80)
              .margin({right:10})
              .onClick(()=>{
                //
              })
          })
        }.width('100%')
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(10)
      .margin({top:10})


      Row({space:50}){
        Button('发布')
          .width(100)
          .height(50)
        Button('取消')
          .width(100)
          .height(50)
      }
      .margin({top:50})

    }
  }
}