import { DrawInfoModel, Coord } from './model/drawInfoModel';
import { HintDialog } from './dialog/hintDialog';
import { StyleSetting } from './Component/styleSetting';
import image from '@ohos.multimedia.image';
import fs from '@ohos.file.fs';
import promptAction from '@ohos.promptAction'
import picker from '@ohos.file.picker';
import { UploadButton } from '../../components/UploadImage'
@Entry
@Component
struct DrawingPanelScreen  {

  // 所有的绘制信息数组
  private listAllXY: Array<DrawInfoModel> = new Array()
  // 执行撤回后的绘制信息数组
  private listTempXY: Array<DrawInfoModel> = new Array()
  // 当前绘制的坐标点数
  private currentListCoord: Array<Coord> = new Array()
  // 撤回的笔画数
  private revocationNumber = 0
  // 渲染设置-抗锯齿
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  // 画布渲染上下文对象，使用此对象画线
  private crc: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  // 自定义提示框
  // private context = getContext(this) as  any;

  // private context=this.entry.context

  private URI:string=null
  //
  private dialogController: CustomDialogController = new CustomDialogController({

    builder: HintDialog({
      title: '清空画板',
      content: '确定清空当前画板？',
      confirm: () => {
        // 撤回不可用
        this.revocationEnabled = false
        // 回撤不可用
        this.unRevocationEnabled = false
        // 清空不可用
        this.clearEnabled = false
        // 记录的数组清空
        this.listTempXY = []
        this.listAllXY = []
        // 选中画笔
        this.isSelectPen = true
        // 清空画布
        this.crc.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
      },
      cancel:()=>{

      }
    }),
  })
  private async upload(){
    this.pixelMap=this.crc.getPixelMap(0,0,this.canvasWidth,this.canvasHeight);
    try {
      let PhotoSaveOptions = new picker.PhotoSaveOptions();
      PhotoSaveOptions.newFileNames = ['PhotoViewPicker02.png'];
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.save(PhotoSaveOptions, (err, PhotoSaveResult) => {
        this.URI=PhotoSaveResult[0]
        if (err) {
          console.error('PhotoViewPicker.save failed with err: ' + err);
          return;
        }
        console.info('PhotoViewPicker.save successfully, PhotoSaveResult uri: ' + JSON.stringify(PhotoSaveResult));
        console.info('获取的uri'+this.URI);
      });
    } catch (err) {
      console.error('PhotoViewPicker failed with err: ' + err);
    }

  }
  private async uploadImage(){
    await this.upload();
    const imagePackerApi=image.createImagePacker();
    let packOpts={ format:"image/jpeg",quality:98}
    imagePackerApi.packing(this.pixelMap,packOpts).then(async data=>{
      console.log('Succeeded in packing the image.');
      const imageSource = image.createImageSource(data);
      this.pixelMap1= await imageSource.createPixelMap()
      let file=fs.openSync(this.URI,fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.write(file.fd,data,(err, writeLen)=>{
        if (err) {
          console.info("write failed with error message: " + err.message + ", error code: " + err.code);
        } else {
          console.log("write data to file succeed and size is:" + writeLen);
          fs.closeSync(file);
        }
      })
    }).then(()=>{
      promptAction.showToast({
        message:"保存到本地相册成功",
        duration:1000,
      })
      console.log("success!")
    }).catch(error=>{
      console.error("failed to pack hte image")
    })
  }
  private saveController:CustomDialogController =new CustomDialogController({
    builder:HintDialog({
      title:"保存",
      content: '确定保存当前画板？',
      confirm:() => {
        promptAction.showToast({
          message:"正在保存",
          duration:1000,
        })
        // var context : Context = getContext(this) as Context
        // this.pathdir=context.filesDir
        // this.pixelMap=this.crc.getPixelMap(0,0,this.canvasWidth,this.canvasHeight);
        // const imagePackerApi=image.createImagePacker();
        // let packOpts={ format:"image/jpeg",quality:98}
        this.uploadImage().then(()=>{
          promptAction.showToast({
            message:"保存成功",
            duration:1000,
          })
        })
      },
      cancel:()=>{
        promptAction.showToast({
          message:"取消保存",
          duration:1000,
        })
      }
    })
  })
  // 撤回是否可用
  @State revocationEnabled: boolean = false
  // 回撤是否可用
  @State unRevocationEnabled: boolean = false
  // 清空是否可用
  @State clearEnabled: boolean = false
  // 是否显示画笔样式设置
  @State isShowPenSetting: boolean = false
  // 是否显示橡皮擦样式设置
  @State isShowEraserSetting: boolean = false
  // 是否选中画笔，是：画笔，否：橡皮擦
  @State isSelectPen: boolean = true
  // 导出的pixelMap对象
  @State private pixelMap:PixelMap=null;
  @State private pixelMap1:PixelMap=null;
  @State pathdir:string="123"
  // 画笔颜色
  private penColor = '#000000'
  // 画笔宽度
  private penWidth = 5
  // 橡皮擦宽度
  private eraserWidth = 5
  // 画布宽度
  private canvasWidth = 0
  // 画布高度
  private canvasHeight = 0
  // 画布对象
  @State private s:ArrayBuffer=new ArrayBuffer(4096)
  //
  @State isShowTools: boolean = false

  /**
   * 操作栏
   */

  @Builder OperationBar() {
    Row() {
      Image($r('app.media.palette'))
        .width(80)
        .height('100%')
        .padding(13)
        .objectFit(ImageFit.Contain)
        .margin({ left: 5 })
      Blank()
      if(this.isShowTools){
        Scroll() {
          Row() {
            Image(this.isSelectPen ? $r('app.media.pen_blue') : $r('app.media.pen'))
              .width(50)
              .height("100%")
              .padding(10)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                if (this.isSelectPen) {
                  this.isShowPenSetting = true
                }
                this.isSelectPen = true
              })

            // 橡皮擦
            Image(this.getEraserSrc())
              .enabled(this.revocationEnabled)
              .width(50)
              .height('100%')
              .padding(10)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                if (!this.isSelectPen) {
                  this.isShowEraserSetting = true
                }
                this.isSelectPen = false
              })

            // 撤回
            Image(this.revocationEnabled ? $r('app.media.chexiao') : $r('app.media.chexiao_gray'))
              .enabled(this.revocationEnabled)
              .width(50)
              .height('100%')
              .padding(10)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.revocationNumber++
                this.revocation()
              })

            // 回撤
            Image(this.unRevocationEnabled ? $r('app.media.huiche') : $r('app.media.huiche_gray'))
              .enabled(this.unRevocationEnabled)
              .width(50)
              .height('100%')
              .padding(10)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.revocationNumber--
                this.revocation()
              })

            // 清空
            Image(this.clearEnabled ? $r("app.media.clear") : $r("app.media.clear_gary"))
              .enabled(this.clearEnabled)
              .width(50)
              .height('100%')
              .padding(10)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.dialogController.open()
              })
            // 保存
            Image($r('app.media.save'))
              .width(45)
              .height('90%')
              .padding(10)
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.saveController.open();
              })
          }.height(50)
        }.scrollable(ScrollDirection.Horizontal)// 设置滚动条水平方向滚动
        .width(230)
        .height(50)
        .scrollBar(BarState.Off)
      }
       Button({type: ButtonType.Circle}) {
         Image(this.isShowTools?$r('app.media.back_icon'):$r('app.media.back_icon_two'))
           .width(30)

       }.height(35)
        .width(50)
        .backgroundColor('#aabbcc')
        .onClick(()=>{
          this.isShowTools=this.isShowTools? false:true
      })
    }
    .width('100%')
    .height(50)
    .shadow({ radius: 5, color: '#27040404', offsetY: 5 })
  }

  /**
   * 绘制
   */
  @Builder Draw() {
    Canvas(this.crc)
      .width('100%')
      .layoutWeight(1)
      .onTouch((event) => this.onTouchEvent(event))
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.canvasWidth = parseInt(newValue.width.toString())
        this.canvasHeight = parseInt(newValue.height.toString())
         this.crc.fillStyle = '#fff'
        this.crc.fillRect(0,0, this.canvasWidth,this.canvasHeight)
      })
      .onReady(() => {
         this.crc.fillStyle = '#0000'
        console.log("draw dok-------------------------------------")

        // 设置线端点以圆形结束
        this.crc.lineCap = 'round'

      })

  }

  build() {
    Stack() {
      Column() {
        // 操作栏
        this.OperationBar()
        // 绘制
         this.Draw()
         UploadButton()
      }.width('100%')
      .height('100%')
      // 画笔样式设置
      StyleSetting({
        isShow: $isShowPenSetting,
        styleChange: (lineWidth, lineColor) => {
          // 设置画笔样式
          this.penColor = lineColor
          this.penWidth = lineWidth
        }
      })

      // 橡皮擦样式设置
      StyleSetting({
        isSettingPen: false,
        isShow: $isShowEraserSetting,
        styleChange: (lineWidth) => {
          // 设置橡皮擦样式
          this.eraserWidth = lineWidth

        }
      })
    }.width('100%')
    .height('100%')
  }

  /**
   * 触摸事件
   */
  onTouchEvent(event: TouchEvent) {
    // x坐标
    const x = event.touches[0].x
    // y坐标
    const y = event.touches[0].y

    // 记录本次笔画的路径坐标
    this.currentListCoord.push(new Coord(x, y))
    // 清空按钮可用
    this.clearEnabled = true
    // 撤回组件可用
    this.revocationEnabled = true
    // 撤回数量重置为0
    this.revocationNumber = 0
    // 回撤组件不可用
    this.unRevocationEnabled = false

    switch (event.type) {
      case TouchType.Down: // 手指按下
        {
          // 设置线颜色
          this.crc.strokeStyle = this.penColor
          // 设置线宽度
          this.crc.lineWidth = this.isSelectPen ? this.penWidth : this.eraserWidth
          // 设置合成属性
          this.crc.globalCompositeOperation = this.isSelectPen ? 'source-over' : 'destination-out'
          // 创建一个新的绘制路径
          this.crc.beginPath()
          // let image
          // 设置起点坐标
          this.crc.moveTo(x, y)
        }
        break;
      case TouchType.Move: // 手指移动
      case TouchType.Up: // 手指抬起
        {
          // 设置移动点
          this.crc.lineTo(x, y)
          // 进行路径绘制
          this.crc.stroke()
          if (event.type === TouchType.Up) {
            // 撤回后数组替换成全部数组
            this.listAllXY = this.listTempXY
            // 线宽度
            let lineWidth = this.isSelectPen ? this.penWidth : this.eraserWidth
            // 本次绘制信息
            const drawInfo = new DrawInfoModel(this.isSelectPen, this.penColor, lineWidth, this.currentListCoord)
            // 记录本次绘制信息
            this.listAllXY.push(drawInfo)
            // 清空当前绘制坐标点，为记录下次绘制准备
            this.currentListCoord = []
          }
        }
        break;
      default:
        break;
    }
  }


  /**
   * 不同情况，橡皮擦图标不一样
   */
  getEraserSrc(): Resource{
    if (this.revocationEnabled) {
      return this.isSelectPen ? $r('app.media.eraser') : $r('app.media.eraser_blue')
    } else {
      return $r('app.media.eraser_gray')
    }
  }

  /**
   * 撤回
   */
  revocation() {
    this.listTempXY = this.listAllXY
    // 根据撤回数量进行判断
    if (this.revocationNumber === 0) {
      // 可撤回，不可回撤
      this.revocationEnabled = true
      this.unRevocationEnabled = false
    } else if (this.revocationNumber === this.listTempXY.length) {
      // 不可撤回，可回撤了
      this.revocationEnabled = false
      this.unRevocationEnabled = true
    } else {
      // 可撤回，可回撤
      this.revocationEnabled = true
      this.unRevocationEnabled = true
    }
    // 根据撤回的个数，截取数组
    this.listTempXY = this.listTempXY.slice(0, this.listTempXY.length - this.revocationNumber)
    // 清空画布
    this.crc.clearRect(0, 0, this.canvasWidth, this.canvasHeight)
    // 拼接笔画路径
    for (const drawInfo of this.listTempXY) {
      // 设置线颜色
      this.crc.strokeStyle = drawInfo.lineColor
      // 设置线宽度
      this.crc.lineWidth = drawInfo.lineWidth
      // 设置合成属性
      this.crc.globalCompositeOperation = drawInfo.isPen ? 'source-over' : 'destination-out'
      // 创建一个新的绘制路径
      this.crc.beginPath()
      // 设置绘制的坐标点
      for (let i = 0; i < drawInfo.listCoord.length; i++) {
        const coord = drawInfo.listCoord[i]
        if (i === 0) {
          this.crc.moveTo(coord.x, coord.y)
        } else {
          this.crc.lineTo(coord.x, coord.y)
        }
      }
      // 进行路径绘制

      this.crc.stroke()
    }
  }
}

export { DrawingPanelScreen }