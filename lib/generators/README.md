## staff index generator

어드민 페이지를 만드는데 필요한 boiler plate 코드를 자동으로 생성해줍니다. 생성된 코드는 용도에 맞게 기존의 구현 방식을 보고 수정하면 됩니다. staffs index를 생성하기 전에 Repository부터 만들어두면 좋습니다.

1. 먼저 모델을 만듭니다 (Optional)
2. 모델을 만들고 나서 아래와 같이 model의 underscore 표기 방식대로 제네레이터 명령의 파라미터로 넘겨줍니다.

```
rails g staff_index message
```


## Repository Generator

Repository 클래스의 boiler plate 코드를 생성하며, Repository 클래스가 올바르게 동작하는지 검증하기 위한 테스트 코드를 생성하는 역할을 합니다.

1. 어떤 모델에 대한 Repository 클래스를 생성하고 싶은지 제네레이터 명령의 파라미터를 넘겨줍니다. (Repository 생략)
2. Repository 클래스, Repository 클래스에 대한 Rspec 코드가 생성됩니다.

```
rails g repository Order # (or order)
```
