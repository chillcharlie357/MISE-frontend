@Component
export struct ColorSelect {
  // 渲染设置-抗锯齿
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  // 画布渲染上下文对象，使用此对象画线
  private crc: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  // 画布宽度
  private canvasWidth = 0
  // 画布高度
  private canvasHeight = 0
  // 颜色选择改变回调
  private colorChange: (color: string) => void
  // 指示器x偏移量
  @State offsetX: number = 0

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Canvas(this.crc)
        .margin({ top: 5, bottom: 5 })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.canvasWidth = parseInt(newValue.width.toString())
          this.canvasHeight = parseInt(newValue.height.toString())
          const grad = this.crc.createLinearGradient(0, 0, this.canvasWidth, 0)
          grad.addColorStop(0, 'rgb(0, 0, 0)')
          grad.addColorStop(1 / 7, 'rgb(255, 0, 0)')
          grad.addColorStop(2 * 1 / 7, 'rgb(255, 255, 0)')
          grad.addColorStop(3 * 1 / 7, 'rgb(0, 255, 0)')
          grad.addColorStop(4 * 1 / 7, 'rgb(0, 255, 255)')
          grad.addColorStop(5 * 1 / 7, 'rgb(0, 0, 255)')
          grad.addColorStop(6 * 1 / 7, 'rgb(255, 0, 255)')
          grad.addColorStop(1, 'rgb(255, 0, 0)')
          this.crc.fillStyle = grad
          this.crc.fillRect(0, 0, this.canvasWidth, this.canvasHeight)
        })

      Stack() {
      }
      .offset({ x: this.offsetX })
      .markAnchor({ x: '50%' })
      .width(4)
      .height('100%')
      .borderRadius(1.5)
      .backgroundColor(Color.White)
      .shadow({ radius: 3, color: Color.Black })
    }
    .onTouch((event) => this.onTouchEvent(event))
    .width('100%')
    .height('100%')
  }
  /**
   * 触摸事件
   */
  onTouchEvent(event: TouchEvent) {
    // x坐标
    let x = event.touches[0].x
    // y坐标
    let y = event.touches[0].y
    // 触摸区域限制
    if (x < 0) x = 0
    if (x > this.canvasWidth - 1) x = this.canvasWidth - 1
    console.log(`触摸位置：x = ${x}, y = ${y}`)
    this.offsetX = x
    // 获取坐标点的颜色值
    let imageData = this.crc.getImageData(x, 1, 1, 1)
    console.log(`颜色值：` + JSON.stringify(imageData))
    // 颜色选择改变回调
    this.colorChange(`rgb(${imageData.data[0]},${imageData.data[1]},${imageData.data[2]})`)
  }
}