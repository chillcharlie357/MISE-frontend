class Content {
  id: number;
  avatar: string;
  title: string;
  content: string;
  images: Array<string>;

  constructor(id: number,
              avatar: string,
              title: string,
              content: string,
              images ?: Array<string>
  ) {
    this.id = id;
    this.avatar = avatar;
    this.title = title;
    this.content = content;
    this.images = images;
  }
}

export {Content}