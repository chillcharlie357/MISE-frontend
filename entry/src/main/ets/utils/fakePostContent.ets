import { Content } from '../data/PostContent';
const fakePostContentData = () => {
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

export { fakePostContentData }