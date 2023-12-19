import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import request from '@ohos.request';
//获取文件路径

// 上传任务配置项
type Fi={
  filename:string,
  name:string,
  uri:string,
  type:string,
}
@Component
export struct UploadButton{
  context=getContext(this) as common.UIAbilityContext;
  cacheDir = this.context.cacheDir;
  @State fileList: Array<Fi>=new Array<Fi>();
  @State selectImage:Array<string>=new Array<string>();
  @State imgSrc: string = ''
  scroller: Scroller = new Scroller()
  uploadConfig = {
  // 后端接口
  url: 'http://192.168.3.48:8740/file/upload',
  header: { key1: 'Content-Type', key2: 'multipart/form-data' },
  method: 'POST',
  files: this.fileList,
  // 这边可以上传表单数据
  data: [
    { name: 'fileId', value: 'FP000008' }
  ]
  }
  async  SelectImage(){
  try {
    let PhotoSelectOptions = new picker.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    // 设置上传的最大图片数量
    PhotoSelectOptions.maxSelectNumber = 5;
    let photoPicker = new picker.PhotoViewPicker();
    console.log(this.cacheDir)
    photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
      console.log('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));

      let uris=PhotoSelectResult["photoUris"];
      for(let i=0;i<uris.length;i++){

        //用于展示图片
         this.selectImage.push(uris[i]);
        // 这边图片的名字可以考虑采取随即算成算法生成名字，以免重复
       this.imgSrc=uris[i]
        console.log(this.selectImage.toString())
        let temp=uris[i].split("/");
        let imageName=temp[temp.length-1];
        let imageFile=fs.openSync(uris[i],fs.OpenMode.CREATE)
        fs.copyFileSync(imageFile.fd,this.cacheDir+'/'+imageName+'.jpeg')
        let file={filename:imageName+'.jpeg',name:imageName,uri:this.cacheDir+'/'+imageName+'.jpeg',type:"jpeg"};
        this.fileList.push(file)
      }
       console.log(JSON.stringify(this.fileList))
       console.log(JSON.stringify(this.selectImage))
    }).catch((err) => {
      console.error('PhotoViewPicker.select failed with err: ' + err);
    });
  } catch (err) {
    console.error('PhotoViewPicker failed with err: ' + err);
  }
}
  async uploadRequest(){
    try {
      request.uploadFile(this.context,this.uploadConfig).then((uploadTask)=>{
        uploadTask.on('complete', (taskStates) => {
          //成功之后清空上传列表
          this.selectImage=[]
          this.fileList=[]
          for (let i = 0; i < taskStates.length; i++) {
            console.info(`xx upload complete taskState: ${JSON.stringify(taskStates[i])}`);
            //this.message = JSON.stringify(taskStates[i])
          }
        });
      })
        .catch((err)=>{
          console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
        })
    }catch (err){
      console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
    }
  }
  build() {
    Column({space:5}) {
      Row() {
        Button("上传图片")
          .onClick(this.uploadRequest)
      }
      Grid(this.scroller) {
        ForEach(this.selectImage, (imageUir: string) => {
          GridItem() {
            Badge({
              value:"-",
              position: BadgePosition.RightTop,// 设置 badge 显示在右上角
              style: { color: 0xFFFFFF, fontSize: 10, badgeSize: 12, badgeColor: Color.Red } // 设置 badge 的显示样式
            }){
              Image(imageUir)
            }.width('80%')
            .height("20%")
          }.margin(5)
        })
        GridItem() {
          Button({type: ButtonType.Circle}){
          }
          .onClick(this.SelectImage.bind(this))
          .width(40)
          .height(40)
        }
      }
      .columnsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .margin(10)
      .width('90%')
      .backgroundColor("#fff")
      .height(300)
    }
  }
}