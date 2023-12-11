import router from '@ohos.router';
import { CommentData, CommentDataGetter, CommentResponse } from '../../data/data';
import { Comments } from './components/Comments';
import axios from '../../axios'

let storage = new LocalStorage({ 'postId': 10 });

@Entry(storage)
@Component
struct PostDetail {
  title: string = router.getParams()['title']
  content: string = router.getParams()['content']
  images: string[] = router.getParams()['images']
  postId: number = router.getParams()['id']

  aboutToAppear() {
    console.info("PostDetail postId: ", this.postId)
    storage.set('postId', this.postId)
  }

  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column }) {

        Swiper() {
          ForEach(this.images, (item: string) => {
            Image(item)
              .alignSelf(ItemAlign.Center)
              .objectFit(ImageFit.Cover)
              .padding({ left: 2, right: 2 })
          })
        }

        PostContent({
          title: this.title,
          content: this.content
        })
          .width('95%')
          .margin(10)
          .padding({ top: 10 })


        Comments()
          .padding({ top: 10 })
          .flexShrink(3)

      }
    }
    .scrollable(ScrollDirection.Vertical)
    .width('100%')
    .height('100%')
  }
}

@Component
struct PostContent {
  private title: string = "Hello World"
  private content: string = "Hello World"

  build() {
    Column({ space: 10 }) {
      Text(this.title)
        .fontSize(18)
      Text(this.content)
        .fontSize(14)
      Divider()
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius(12)

  }
}

@Component
struct pre {
  private name: string = "Hello World"
  private content: string = "Hello World"

  build() {
    Column() {
      PostDetail()
    }
    .width('100%')
    .height('100%')
  }
}

export { PostDetail }

