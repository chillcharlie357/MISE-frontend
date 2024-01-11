import { UploadButton } from '../../components/UploadImage'
import axios from '../../axios'
import { UserProfileResponse, PostData } from '../../data/data'
import { Content } from '../../data/PostContent'
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import request from '@ohos.request';
import promptAction from '@ohos.promptAction'
import router from '@ohos.router'

type Fi = {
  filename: string,
  name: string,
  uri: string,
  type: string,
}

@Entry
@Component
@Preview
struct AddPostPage {
  private addPost = (postData: PostData) => {
    const tokenName: string = AppStorage.Get("tokenName")
    const tokenValue: string = AppStorage.Get("tokenValue")
    return axios.post('/community/post', postData, {
      headers: {
        [tokenName]: tokenValue
      }
    })
  }
  @State avatar: string = AppStorage.Get("userAvatar")
  @State uid: number = parseInt(AppStorage.Get("userUId"))
  @StorageProp('login_state') login_state: boolean = false
  @State title: string = ''
  @State content: string = ''
  @State pictureURL: Array<string> = ['pages/Community/icon/ic_public_favor.svg']
  // 图片功能
  @State fileList: Array<Fi> = new Array<Fi>();
  @State selectImage: Array<string> = new Array<string>();
  // 后端返回图片地址
  @State OSSImage: Array<string> = new Array<string>();
  @State imgSrc: string = ''
  // 是否允许继续添加图片
  @State AllowAdd: boolean = true;
  context = getContext(this) as common.UIAbilityContext;
  cacheDir = this.context.cacheDir;
  uploadConfig = {
    // 后端接口
    url: axios.defaults.baseURL + '/community/postPic',
    header: { key1: 'Content-Type', key2: 'multipart/form-data' },
    method: 'POST',
    files: this.fileList,
    // 这边可以上传表单数据
    data: [
      { name: 'uid', value: this.uid.toString() },
      { name: 'title', value: this.title },
      { name: 'content', value: this.content },
      { name: 'avatar', value: this.avatar },
    ]
  }

  async SelectImage() {
    try {
      let PhotoSelectOptions = new picker.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      // 设置上传的最大图片数量
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new picker.PhotoViewPicker();
      console.log(this.cacheDir)
      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
        console.log('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));

        let uris = PhotoSelectResult["photoUris"];
        for (let i = 0;i < uris.length; i++) {

          //用于展示图片
          this.selectImage.push(uris[i]);

          // 这边图片的名字可以考虑采取随即算成算法生成名字，以免重复
          this.imgSrc = uris[i]
          console.log(this.selectImage.toString())
          let temp = uris[i].split("/");
          let imageName = temp[temp.length-1];
          let imageFile = fs.openSync(uris[i], fs.OpenMode.CREATE)
          fs.copyFileSync(imageFile.fd, this.cacheDir + '/' + imageName + '.jpeg')
          let file = {
            filename: imageName + '.jpeg',
            name: imageName,
            uri: this.cacheDir + '/' + imageName + '.jpeg',
            type: "jpeg"
          };
          this.fileList.push(file)
          this.OSSImage.push("https://lab22.oss-cn-beijing.aliyuncs.com/MISE-image/"+imageName)
        }

        if (this.selectImage.length >= 1) {
          this.AllowAdd = false
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

  async uploadRequest() {
    try {

      request.uploadFile(this.context, this.uploadConfig).then((uploadTask) => {
        uploadTask.on('complete', (taskStates) => {
          //成功之后清空上传列表
          this.selectImage = []
          this.fileList = []
          this.AllowAdd = true
          this.OSSImage=[]
          for (let i = 0; i < taskStates.length; i++) {
            console.info(`xx upload complete taskState: ${JSON.stringify(taskStates[i])}`);
            //this.message = JSON.stringify(taskStates[i])
          }
        });
      })
        .catch((err) => {
          console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
        })
    } catch (err) {
      console.error(`xx Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
    }
  }
  // end

  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Text('发布')
        .textAlign(TextAlign.Center)
        .fontSize(30)
        .padding(10)
        .width('100%')
      Grid() {
        ForEach(this.selectImage, (imageUir: string, index: number) => {
          GridItem() {
            Badge({
              value: "-",
              position: BadgePosition.RightTop, // 设置 badge 显示在右上角
              style: { color: 0xFFFFFF, fontSize: 10, badgeSize: 12, badgeColor: Color.Red } // 设置 badge 的显示样式
            }) {
              Image(imageUir)
                .height(55)
                .width(55)

            }.height(55)
            .width(55)
            .onClick(() => {
              this.selectImage.splice(index, 1)
              this.fileList.splice(index, 1)
              this.AllowAdd = true
              this.OSSImage=[]
              promptAction.showToast({
                message: "删除图片",
                duration: 1000,
              })
              // this.AllowAdd=true
            })
          }.margin(5)
        })
        if (this.AllowAdd) {
          GridItem() {
            Button({ type: ButtonType.Circle }) {
              Image($r('app.media.ic_public_add_norm'))
            }
            .onClick(this.SelectImage.bind(this))
            .width(30)
            .height(30)
          }.margin(15)
        } else {
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
        .margin({ top: 10 })

      TextInput({ placeholder: '请输入标题' })
        .height(40)
        .textAlign(TextAlign.Start)
        .fontSize(15)
        .margin({ top: 10 })
        .width('95%')
        .onChange((value) => {
          this.title = value
        })


      Divider()
        .strokeWidth(2)
        .margin({ top: 10 })

      TextArea({ placeholder: '请输入正文' })
        .margin({ top: 10 })
        .width('95%')
        .height(200)
        .onChange((value) => {
          this.content = value
        })


      // Scroll(this.scroller) {
      //   Row() {
      //     ForEach(this.pictureURL, (item) => {
      //       Image(item)
      //         .height(80)
      //         .width(80)
      //         .margin({right:10})
      //         .onClick(()=>{
      //           //
      //         })
      //     })
      //   }.width('100%')
      // }
      // .scrollable(ScrollDirection.Horizontal)
      // .scrollBar(BarState.On)
      // .scrollBarColor(Color.Gray)
      // .scrollBarWidth(10)
      // .margin({top:10})


      Row({ space: 50 }) {
        Button('发布')
          .width(100)
          .height(50)
          .onClick(() => {
            if (this.login_state == true) {
              if (this.title == '' || this.content == '') {
                promptAction.showToast({
                  message: "标题或正文不能为空",
                  duration: 1000,
                })
                return
              }
              if (this.OSSImage.length == 0) {
                promptAction.showToast({
                  message: "请至少上传一张图片",
                  duration: 1000,
                })
                return
              }
              this.uploadRequest()
              const postData: PostData = {
                id: this.uid,
                avatar: this.avatar,
                title: this.title,
                content: this.content,
                images: this.OSSImage
              }
              this.addPost(postData)
                .then((res) => {
                  console.info(JSON.stringify(res))
                }).catch((err) => {
                console.error(JSON.stringify(err))
                promptAction.showToast({
                  message: "发布失败",
                  duration: 1000,
                })
              })
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
          .onClick(() => {
            router.back()
            promptAction.showToast({
              message: "取消发布",
              duration: 1000,
            })
          })
      }
      .margin({ top: 50 })

    }
    .width('100%')
    .height('100%')
  }
}