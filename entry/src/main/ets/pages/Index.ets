@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private arr: number[] = [1, 2, 3];

  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Tabs({barPosition: BarPosition.End}) {
      TabContent() {
        Text('首页的内容').fontSize(30)
      }
      .tabBar(this.TabBuilder("首页", 0, $r('app.media.ic_public_home'), $r('app.media.ic_public_home')))

      TabContent() {
        Text('画板').fontSize(30)
      }
      .tabBar(this.TabBuilder("画板", 2, $r('app.media.ic_screenshot_penshape'), $r('app.media.ic_screenshot_penshape')))

      TabContent() {
        Text('我的').fontSize(30)
      }
      .tabBar(this.TabBuilder("我的", 1, $r('app.media.ic_public_contacts'), $r('app.media.ic_public_contacts')))

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

const toolBarItems = [
  {
    value: "Home",
    icon: $r('app.media.ic_public_home'),
    action: () => {
    }
  },
  {
    value: "Profile",
    icon: $r('app.media.ic_public_contacts'),
    action: () => {
    }
  },
  {
    value: "Draw",
    icon: $r('app.media.ic_screenshot_penshape'),
  }
]