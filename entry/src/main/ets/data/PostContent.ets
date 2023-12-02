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

export {Content}