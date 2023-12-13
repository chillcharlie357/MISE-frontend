import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
async function example() {
  try {
    let PhotoSelectOptions = new picker.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    PhotoSelectOptions.maxSelectNumber = 5;
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {

      console.log('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult["photoUris"]));
      let uris=PhotoSelectResult["photoUris"];
      for(let i=0;i<uris.length;i++){

      }
    }).catch((err) => {
      console.error('PhotoViewPicker.select failed with err: ' + err);
    });
  } catch (err) {
    console.error('PhotoViewPicker failed with err: ' + err);
  }
}
async function save() {
  let URI = null;
  try {

    let PhotoSaveOptions = new picker.PhotoSaveOptions();
    PhotoSaveOptions.newFileNames = ['PhotoViewPicker02.jpg'];
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.save(PhotoSaveOptions, (err, PhotoSaveResult) => {
      URI=PhotoSaveResult[0]
      if (err) {
        console.error('PhotoViewPicker.save failed with err: ' + err);
        return;
      }
      console.info('PhotoViewPicker.save successfully, PhotoSaveResult uri: ' + JSON.stringify(PhotoSaveResult));
      console.info('获取的uri'+URI);
    });
    console.log("我是你弟额大王大大伟大哇")

  } catch (err) {
    console.error('PhotoViewPicker failed with err: ' + err);
  }
  console.log('-------------------------------------------------' );
  let file = fs.openSync(URI, fs.OpenMode.READ_WRITE);
  let writeLen = fs.writeSync(file.fd, 'hello, world');
  console.log('write data to file succeed and size is:' + writeLen);
  fs.closeSync(file);
  console.info('file fd: ' + file.fd);
  console.log('-------------------------------------------------' );
}

@Component
export struct SelectPhoto{

    build(){
      Row(){
        Button('test')
          .onClick(example)
        Button('save')
          .onClick(save)
      }

    }
}