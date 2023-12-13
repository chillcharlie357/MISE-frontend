import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import File from '@system.file';
//获取文件路径
let context=getContext(this) as common.UIAbilityContext;
let cacheDir = context.cacheDir;
// 上传任务配置项


@Component
export struct UploadButton{
  @State private fileList:Array<File>=new Array();
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
        let file={filename:"text.jpg",name:"text",uri:uris[i],type:"jpeg"};
        this.fileList.push(file)
      }
    }).catch((err) => {
      console.error('PhotoViewPicker.select failed with err: ' + err);
    });
  } catch (err) {
    console.error('PhotoViewPicker failed with err: ' + err);
  }
}
  build(){

  }
}