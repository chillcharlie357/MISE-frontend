class Content {
  id: number;
  avatar: string;
  title: string;
  context: string;
  description: string;
  images: Array<string>;

  constructor(id: number,
              avatar: string,
              title: string,
              context: string,
              description: string,
              images ?: Array<string>
  ) {
    this.id = id;
    this.avatar = avatar;
    this.title = title;
    this.context = context;
    this.description = description;
    this.images = images;
  }
}

export {Content}