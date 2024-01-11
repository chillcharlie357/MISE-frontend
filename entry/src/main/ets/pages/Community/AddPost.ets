import {UploadButton} from '../../components/UploadImage'
import axios from '@ohos/axios'
import {UserProfileResponse,ImageResponse} from '../../data/data'
import { AxiosError, AxiosProgressEvent, AxiosResponse, FormData } from '@ohos/axios'
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import request from '@ohos.request';
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
@Entry
@Component
@Preview
struct AddPostPage{

  @State avatar: string = AppStorage.Get("userAvatar")
  @State uid: number = parseInt(AppStorage.Get("userUId"))
  @StorageProp('login_state') login_state: boolean = false
  @State title: string = ''
  @State content: string = ''
  @State pictureURL: Array<string> = ['pages/Community/icon/ic_public_favor.svg']
  // 图片功能
  @State fileList:Array<string>=new Array<string>();
  @State selectImage:Array<string>=new Array<string>();
  // 后端返回图片地址
  //@State OSSImage:Array<string>=new Array<string>();
  @State imgSrc: string = ''
  // 是否允许继续添加图片
  @State AllowAdd : boolean = true;

  context=getContext(this) as common.UIAbilityContext;
  cacheDir = this.context.cacheDir;
  async SelectImage(){
    try {
      let PhotoSelectOptions = new picker.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      // 设置上传的最大图片数量
      PhotoSelectOptions.maxSelectNumber = 1;
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
          this.fileList.push("internal://cache/"+imageName+'.jpeg')
          //this.formData.append('file',"internal://cache/"+imageName+'.jpeg')
          //this.file.push({filename:imageName+'.jpeg',name:imageName,uri:"internal://cache/"+imageName+'.jpeg',type:"jpeg"})
        }
        console.log(this.fileList.toString())
        if(this.selectImage.length>=1){
          this.AllowAdd=false
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
    var formData=new FormData()

    for(let i = 0; i < this.fileList.length; i++){
      formData.append('file',this.fileList[i]);
    }
    formData.append('avatar', this.avatar);
    formData.append('uid', this.uid);
    formData.append('title', this.title);
    formData.append('content', this.content);

    axios.post<string, AxiosResponse<string>, FormData>('http://172.31.27.189:4523/m1/3686963-0-default/community/post', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
        context: this.context,
        onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
          console.info(progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) + '%' : '0%');
        },
     }).then((res:AxiosResponse<string>)=>{
     }).catch((err: AxiosError) => {
       console.error("error:" + JSON.stringify(err));
      })
  }
  // end

  scroller: Scroller = new Scroller()

  build() {
    Column(){
      Text('发布')
        .textAlign(TextAlign.Center)
        .fontSize(30)
        .padding(10)
        .width('100%')
      Grid() {
        ForEach(this.selectImage, (imageUir: string,index:number) => {
          GridItem() {
            Badge({
              value:"-",
              position: BadgePosition.RightTop,// 设置 badge 显示在右上角
              style: { color: 0xFFFFFF, fontSize: 10, badgeSize: 12, badgeColor: Color.Red } // 设置 badge 的显示样式
            }){
              Image(imageUir)
                .height(55)
                .width(55)

            }.height(55)
            .width(55)
            .onClick(()=>{
              this.selectImage.splice(index,1)
              this.fileList.splice(index,1)
              this.AllowAdd=true
              promptAction.showToast({
                message:"删除图片",
                duration:1000,
              })
            })
          }.margin(5)
        })
        if(this.AllowAdd){
          GridItem() {
            Button({type: ButtonType.Circle}){
              Image($r('app.media.ic_public_add_norm'))
            }
            .onClick(this.SelectImage.bind(this))
            .width(30)
            .height(30)
          }.margin(15)
        }else{
          GridItem() {
            Text()
          }
        }
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .margin(10)
      .width('95%')
      .backgroundColor("#DCDCDC")
      .height(70)
      .borderRadius(10)
      Divider()
        .strokeWidth(2)
        .margin({top:10})

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
      Text(JSON.stringify(this.fileList))
      Text(JSON.stringify(this.selectImage))
      Row({space:50}){
        Button("发布")
          .width(100)
          .height(50)
          .onClick( ()=>{
            if (this.login_state == true) {
              if (this.title == '' || this.content == '') {
                promptAction.showToast({
                  message: "标题或正文不能为空",
                  duration: 1000,
                })
                return
              }
              this.uploadRequest()
            } else {
              promptAction.showToast({
                message: "请先登录",
                duration: 1000,
              })
            }
            promptAction.showToast({
              message: "发布成功",
              duration: 1000,
            })
            router.back()

          })
        Button('取消')
          .width(100)
          .height(50)
      }
      .margin({top:50})

    }
  }
}