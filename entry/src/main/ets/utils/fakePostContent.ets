import { Content } from '../data/PostContent';
const fakePostContentData = () => {
  const dataList: Array<Content> = [];
  const filledArray: Array<string> = Array(4).fill("https://dummyimage.com/20/09f/fff.png");

  for (let i = 1; i <= 10; i++) {
    const newItem = new Content(
      i,
      "https://dummyimage.com/20/09f/fff.png",
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