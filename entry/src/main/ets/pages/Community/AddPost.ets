import {UploadButton} from '../../components/UploadImage'
import axios from '../../axios'
import {UserProfileResponse,PostData} from '../../data/data'
import { Content } from '../../data/PostContent'

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
  scroller: Scroller = new Scroller()



  build() {
    Column(){
      Text('发布')
        .textAlign(TextAlign.Center)
        .fontSize(30)
        .padding(10)
        .width('100%')

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
          })

        Button('取消')
          .width(100)
          .height(50)
      }
      .margin({top:50})

    }
  }
}