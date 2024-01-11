import image from '@ohos.multimedia.image';
import { PostCard } from '../../components/PostCard';
import { CustomDialogUser } from '../../components/CustomDialogExample';
import { PostList } from '../../components/PostList';
import axios from '../../axios'
import { PostDataGetter, PostData, PostResponse } from '../../data/data';
import { fakePostContentData } from '../../utils/fakePostContent';
import { addIcon } from '../Community/components/addIcon'

@Entry
@Component
@Preview
struct CommunityScreen {
  /**
   * 给PostList组件传递的获取数据的方法, 如果直接传contents会导致PostList组件在无法渲染
   * @returns Promise<PostResponse> | null
   */
  private getPostData: PostDataGetter = () => {
    return axios.get<PostResponse>('/community/posts')
      .then((response) => {
        console.info('CommunityScreen response: ', JSON.stringify(response.data));
        return response.data;
      })
      .catch((error) => {
        console.error('CommunityScreen error: ', error);
        return null;
      });
  }

  aboutToAppear() {
    console.info('CommunityScreen aboutToAppear');
  }

  build() {
    Column() {
      CustomDialogUser().zIndex(9999)
      addIcon().zIndex(9999)

      PostList({ getPostData: this.getPostData })
        .zIndex(50)


    }
    .width('100%')
    .backgroundColor(Color.White)
  }
}


export { CommunityScreen }