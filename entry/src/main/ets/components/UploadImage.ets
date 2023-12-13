import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import File from '@system.file';
import request from '@ohos.request';
//获取文件路径
let context=getContext(this) as common.UIAbilityContext;
let cacheDir = context.cacheDir;
let  Fi={
  filename:"",
  name:"",
  uri:"",
  type:"",
}
// 上传任务配置项
@Component
export struct UploadButton{
  @State private fileList:typeof Fi[]=new Array();
  uploadConfig = {
  // 后端接口
  url: 'http://192.168.3.48:8740/file/upload',
  header: { key1: 'Content-Type', key2: 'multipart/form-data' },
  method: 'POST',
  files: this.fileList,
  data: [
    { name: 'fileId', value: 'FP000008' }
  ]
  }
  async  UploadImage() {
  try {
    let PhotoSelectOptions = new picker.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    // 设置上传的最大图片数量
    PhotoSelectOptions.maxSelectNumber = 5;
    let photoPicker = new picker.PhotoViewPicker();

    photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
      console.log('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
      let uris=PhotoSelectResult["photoUris"];
      for(let i=0;i<uris.length;i++){
        // 这边图片的名字可以考虑采取随即算成算法生成名字，以免重复
        let temp=uris[i].split("//");
        let imageName=temp[temp.length-1];
        let imageFile=fs.openSync(uris[i],fs.OpenMode.CREATE)
        fs.copyFileSync(imageFile.fd,cacheDir+'/'+imageName+'.jpeg')
        let file={filename:imageName+'.jpeg',name:imageName,uri:cacheDir+'/'+imageName+'.jpeg',type:"jpeg"};
        this.fileList.push(file)
      }
      console.log(JSON.stringify(this.fileList))
      this.uploadRequest()
    }).catch((err) => {
      console.error('PhotoViewPicker.select failed with err: ' + err);
    });
  } catch (err) {
    console.error('PhotoViewPicker failed with err: ' + err);
  }
}
  async uploadRequest(){
    try {
      request.uploadFile(context,this.uploadConfig).then((uploadTask)=>{
        uploadTask.on('complete', (taskStates) => {
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
  build(){

  }
}