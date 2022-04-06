# UnsplashDemo

# Summary
- Unsplash API를 이용한 사진 검색 기능 구현
- First Tab : /photos api 사진 list를 세로 스크롤 화면으로 보여줌
- Second Tab : /search/photos api를 이용해 검색한 사진을 세로 스크롤 화면으로 보여줌. (검색어 미입력시 flower 검색하도록 임시구현)
- Detail page : First, Second Tab에서 사진을 선택시 가로로 스크롤 하여 볼 수 있고, Tab시 버튼, Navigation Control을 숨길 수 있음
- 사진 List의 마지막으로 이동하면 추가 사진을 서버로부터 load 함
- Detail page에서 이전화면으로 돌아갈 때 마지막사진으로 Focus 이동

# Demo
![Image](https://github.com/jedchoi/UnsplashDemo/blob/main/UnsplashDemo.gif)

# 적용기술
- UIKit(StoryBoard), Combine
- Clean Architecture, VIPER(without presenter)

# Architecture
<img src=https://github.com/jedchoi/UnsplashDemo/blob/main/UnsplashDemoArchitecture.svg>

# VIPER 
<img src=https://github.com/jedchoi/UnsplashDemo/blob/main/UnsplashUIVIPER.svg>
