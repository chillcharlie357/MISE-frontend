import {ColorSelect} from './colorSelect'


@Component
export struct StyleSetting {
  // 渲染设置-抗锯齿
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  // 画布渲染上下文对象，使用此对象画线
  private crc: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  // 画布宽度
  private canvasWidth = 0
  // 画布高度
  private canvasHeight = 0
  // 线颜色
  private lineColor = 'rgb(0,0,0)'
  // 颜色选中的索引
  @State selectIndex: number = 0
  // 线宽度
  private lineWidth = 5
  // 滑块的值
  @State sliderValue: number = 50
  // 是否设置画笔，是：画笔样式、否：橡皮擦样式
  private isSettingPen = true
  // 样式改变回调
  private styleChange: (lineWidth, lineColor) => void
  // 是否显示，不能初始化值，使用父组件传过来的值
  @Link @Watch("onIsShowChanged") isShow: boolean
  // 是否加载了，是：下次显示加载布局，为了执行onAreaChange方法，计算canvas宽高
  @State isLoading: boolean = false

  onIsShowChanged() {
    if (this.isShow && !this.isLoading) {
      this.isLoading = true
    }
  }

  build() {
    Column() {
      if (this.isLoading) {
        Column() {
        }
        .width('100%')
        .height(55)
        .onClick(() => {
          // 点击背景消失
          this.isShow = false
        })

        Column() {
          // 标题
          Text(this.isSettingPen ? '画笔样式' : '橡皮擦样式')
            .fontSize(20)

          // 样式展示
          Canvas(this.crc)
            .width('100%')
            .height(50)
            .margin({ top: 20 })
            .onAreaChange((oldValue: Area, newValue: Area) => {
              this.canvasWidth = parseInt(newValue.width.toString())
              this.canvasHeight = parseInt(newValue.height.toString())
            })
            .onReady(() => {
              this.draw()
            })

          // 粗细设置
          Row() {
            Text('粗细:').fontSize(16)
            Slider({
              value: this.sliderValue,
              min: 1,
              max: 200,
              step: 1,
              style: SliderStyle.OutSet
            }).layoutWeight(1)
              .blockColor('#3879F8')
              .trackColor('#d7d7d7')
              .onChange((value: number, mode: SliderChangeMode) => {
                this.sliderValue = value
                let width = value / 10
                if (width < 1) width = 1
                this.lineWidth = width
                this.draw()
                // 样式改变回调
                this.styleChange(this.lineWidth, this.lineColor)
              })
          }.width('100%')
          .margin({ top: 30, bottom: 15 })

          // 画笔才有颜色设置
          if (this.isSettingPen) {
            // 颜色设置
            Row() {
              Text('颜色:').fontSize(16)
              Stack() {
                ColorSelect({
                  colorChange: (color) => {
                    this.lineColor = color
                    this.draw()
                    // 样式改变回调
                    this.styleChange(this.lineWidth, this.lineColor)
                  }
                })
              }.margin({ left: 12, right: 50 })
              .height(20)
            }.width('100%')
            .margin({ bottom: 15 })
          }
        }
        .width('100%')
        .padding({ left: 15, right: 15, top: 30, bottom: 30 })
        .backgroundColor(Color.White)

        Blank()
          .backgroundColor('#3f000000')
          .onClick(() => {
            // 点击背景消失
            this.isShow = false
          })
      }
    }
    .width('100%')
    .height('100%')
    .visibility(this.isShow ? Visibility.Visible : Visibility.Hidden)
    .onAppear(() => {
      // 样式改变回调
      this.styleChange(this.lineWidth, this.lineColor)
    })
  }

  /**
   * 绘制线
   * @param color 颜色
   * @param lineWidth 线宽度
   */
  draw() {
    // 清空画布
    this.crc.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
    // 设置线端点以圆形结束
    this.crc.lineCap = 'round'
    // 设置线颜色
    this.crc.strokeStyle = this.lineColor
    // 设置线宽度
    this.crc.lineWidth = this.lineWidth
    // 创建一个新的绘制路径
    this.crc.beginPath()
    // 设置起点坐标
    this.crc.moveTo(30, 30)
    // 创建三次贝赛尔曲线的路径
    this.crc.bezierCurveTo(150, -20, 200, 70, 300, 20)
    // 进行路径绘制
    this.crc.stroke()
  }
}