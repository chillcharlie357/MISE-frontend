import router from '@ohos.router'
@Entry
@Component
struct addIcon{
  build(){
    Column(){
      Button({type:ButtonType.Circle, stateEffect: true}){
        Image($r('app.media.ic_public_add_norm'))
          .width(40)
          .height(40)
      }
      .backgroundColor(0xffffff)
      .align(Alignment.Center)
      .width(50)
      .height(50)
      .position({ x: '10%', y: 600, })
      .onClick(()=>{
        router.pushUrl({url:'pages/Community/AddPost'})
      })
    }.width('100%').margin({ top: 5 })
  }
}

export {addIcon}