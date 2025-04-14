@Entry
@Component
struct Index {
  pageStack: NavPathStack = new NavPathStack()

  build() {
   Navigation(this.pageStack) {
     Text('simple')
       .onClick(()=>{
         this.pageStack.pushPathByName('simple', undefined)
       })
   }
  }
}