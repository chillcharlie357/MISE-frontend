import { PostData } from '../data/data';

const fakePostContentData = () => {
  const dataList: Array<PostData> = [];
  const filledArray: Array<string> = Array(4).fill("https://dummyimage.com/20/09f/fff.png");

  for (let i = 1; i <= 10; i++) {
    const newItem = {
      id: i,
      title: `title${i}`,
      content: `content${i}`,
      avatar: "https://dummyimage.com/20/09f/fff.png",
      images: filledArray
    }
    dataList.push(newItem);
  }

  return dataList;
}

export { fakePostContentData }