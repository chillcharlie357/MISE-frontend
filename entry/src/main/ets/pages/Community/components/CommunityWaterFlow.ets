import { PostCard } from '../../../components/PostCard'
import { Content } from '../../../data/PostContent'
import { fakePostContentData } from '../../../utils/fakePostContent'
import { WaterFlowDataSource } from './WaterFlowDataSource'

@Component
struct CommunityWaterFlow {
  @State title:string = "title"
  @State description:string = "description123345346234234234234234"
  @State avater:string = "https://ts1.cn.mm.bing.net/th?id=OIP-C.cYA-_PINA-ND9OeBaolDTwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&pid=3.1&rm=2"

  build() {
    Column()
    {
      Text(this.title)
        .fontSize(20)
      Image(this.avater)
        .height(100)
        .width(50)
      Text(this.description)
        .fontSize(10)

    }
    .width(60)

  }
}


@Preview
@Component
struct waterflowComponentpre{

  @State datasource:WaterFlowDataSource = new WaterFlowDataSource();

  @State contents: Array<Content> = fakePostContentData();

  build(){
    Column()
    {
      // CommunityWaterFlow({title:"TITLE"});
      WaterFlow(){
        ForEach(this.contents,(item:Content) =>{
          FlowItem(){
            PostCard({content:item})
          }
          // .height(100 + (item % 5) * 10)
          // .backgroundColor(Color.Gray)
        },content => content.id)

        // LazyForEach(this.datasource,(item:number) =>{
        //     FlowItem()
        //     {
        //       CommunityWaterFlow();
        //     }
        //     .height(100 + (item % 5) * 10)
        //     .backgroundColor(Color.Gray)
        //   },(item:string) => item
        // )


      }
      // .columnsTemplate("1fr 1fr")
      .columnsGap(10)
      .rowsGap(5)
      .backgroundColor(0xFAEEE0)
      .width('100%')
      .height('80%')
    }
    .height("100%")
    .width("100%")
  }
}