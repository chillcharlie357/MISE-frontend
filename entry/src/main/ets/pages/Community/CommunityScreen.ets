import image from '@ohos.multimedia.image';
import { PostCard } from '../Community/Components/PostCard';

@Entry
@Component
@Preview
struct CommunityScreen {
  @State message: string = 'Drawing Panel'
  @State contents: Array<Content> = generateFakeData();

  build() {
    Column() {
      List() {
        ForEach(this.contents, (item: Content) => {
          ListItem() {
            PostCard({ content: item })
          }
        }, content => content.id)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .backgroundColor($r('app.color.snow_grey'))
  }
}

class Content {
  id: number;
  avatar: Resource;
  title: string;
  context: string;
  description: string;
  images: Array<Resource>;

  constructor(id: number,
              avatar: Resource,
              title: string,
              context: string,
              description: string,
              images ?: Array<Resource>
  ) {
    this.id = id;
    this.avatar = avatar;
    this.title = title;
    this.context = context;
    this.description = description;
    this.images = images;
  }
}

const generateFakeData = () => {
  const dataList: Array<Content> = [];
  const filledArray: Array<Resource> = Array(4).fill($r('app.media.icon'));

  for (let i = 1; i <= 10; i++) {
    const newItem = new Content(
      i,
      $r('app.media.icon'),
      `title${i}`,
      `content${i}`,
      `description${i}`,
      filledArray
    );
    dataList.push(newItem);
  }

  return dataList;
}


export { CommunityScreen, Content }