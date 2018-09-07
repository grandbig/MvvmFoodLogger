# MvvmFoodLogger

## アーキテクチャ
本プロジェクトでは `MVVM` アーキテクチャを採用しています。

### MVVMとは
`MVVM` は `View` / `ViewModel` / `Model` から構成されたアーキテクチャです。  
各関係性は次の通りです。  

[MVVMの各関係性](https://user-images.githubusercontent.com/4291518/45229474-d9c8fd80-b300-11e8-9a21-f54749f5c901.png)

#### Modelとは
`MVC` で言うところの `Model` と同じで、ビジネスロジックの管理を担当します。  

本プロジェクトでは例えば、

* `GooglePlacesAPI` : Google Places APIを叩いて必要としているレストランの情報を取得する  
* `LocationManager` : GPSから端末の位置情報を取得する  
* `Places` ,`Place` : Google Places APIのレスポンスデータ   

などが該当します。  

#### Viewとは
ユーザの操作を受け付けて、`ViewModel` に渡します。  
また、画面の描画ロジックの管理を担当します。  

#### ViewModelとは
`View` からのイベントを受け付けて、必要な `Model` のロジックを呼び出します。  
また、 `Model` から受け取ったデータを `View` が表示しやすい形に変換して `View` に返却します。  

## プロジェクト構成

```
MvvmFoodLogger
  ├── Protocol
  ├── ViewModel
  ├── View
  │    └── Parts
  ├── Model
  └── Resources
```
