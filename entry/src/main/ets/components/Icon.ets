@Component
export struct Icon {
  private icon:Resource = null
  private name:string = ""
  private clickable:boolean = false
  private iconHeight:number = 40
  private iconWidth:number = 40

  click:()=> void
  build() {
    Column(){
      Image(this.icon)
        .width(this.iconWidth)
        .height(this.iconHeight)
        .hitTestBehavior(this.clickable?HitTestMode.Default:HitTestMode.None)
        .onClick(this.click)
      Text(this.name)
        .textAlign(TextAlign.Center)
    }
  }
}