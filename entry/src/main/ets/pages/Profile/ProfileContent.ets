@Component
@Preview
struct ProfileContent {
  build() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {

      }
      .tabBar('作品')

      TabContent() {

      }
      .tabBar('收藏')

      TabContent() {

      }
      .tabBar('赞过')
    }
  }
}