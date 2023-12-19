import {UploadButton} from '../../components/UploadImage'
import axios from '../../axios'
import {UserProfileResponse,PostData} from '../../data/data'
import { Content } from '../../data/PostContent'
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import request from '@ohos.request';
type Fi={
  filename:string,
  name:string,
  uri:string,
  type:string,
}
@Entry
@Component
@Preview
struct AddPostPage{

  private getUser = () =>{
    return axios.get<UserProfileResponse>('/user/info')
      .then((response)=>{
        this.uid=response.data.id
        this.avatar=response.data.avatarUrl
          return response.data
      })
      .catch((err)=>{
          console.log('get user profile err')
          return null;
      })
  }

  private addPost = (postData : PostData)=>{
    return axios.post('/community/post',postData)
  }


  @State avatar:string=''
  @State uid:number = 0
  @State title: string = ''
  @State content: string = ''
  @State pictureURL: Array<string> = ['pages/Community/icon/ic_public_favor.svg']
  // 图片功能
  @State fileList: Array<Fi>=new Array<Fi>();
  @State selectImage:Array<string>=new Array<string>();
  @State imgSrc: string = ''
  context=getContext(this) as common.UIAbilityContext;
  cacheDir = this.context.cacheDir;

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
  // end

  scroller: Scroller = new Scroller()

  build() {
    Column(){

      Text('发布')
        .textAlign(TextAlign.Center)
        .fontSize(30)
        .padding(10)
        .width('100%')
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
           // .onClick()
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


      Scroll(this.scroller) {
        Row() {
          ForEach(this.pictureURL, (item) => {
            Image(item)
              .height(80)
              .width(80)
              .margin({right:10})
              .onClick(()=>{
                //
              })
          })
        }.width('100%')
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(10)
      .margin({top:10})


      Row({space:50}){
        Button('发布')
          .width(100)
          .height(50)
          .onClick(()=>{
            if(this.getUser()!=null){
              const postData:PostData={
                id:this.uid,
                avatar:this.avatar,
                title:this.title,
                content:this.content,
                images:null
              }
              this.addPost(postData)
                .then((res) => {
                  console.info(JSON.stringify(res))
                }).catch((err) => {
                console.error(JSON.stringify(err))
              })
            }
          })

        Button('取消')
          .width(100)
          .height(50)
      }
      .margin({top:50})

    }
  }
}