cukunity
========

cukunity（キュキュニティー）とは、自動化及びテストのための一つフレームワークである。
目的としては、[BDD（振舞駆動開発）](http://ja.wikipedia.org/wiki/%E3%83%93%E3%83%98%E3%82%A4%E3%83%93%E3%82%A2%E9%A7%86%E5%8B%95%E9%96%8B%E7%99%BA)を
[Unity3D](http://unity3d.com)のゲームの開発プロセスにより簡単に引き取ること。

## 概念

cukunityは[BDD（振舞駆動開発）](http://ja.wikipedia.org/wiki/%E3%83%93%E3%83%98%E3%82%A4%E3%83%93%E3%82%A2%E9%A7%86%E5%8B%95%E9%96%8B%E7%99%BA)
という開発プロセスの意思に触発されて出来たものである。
「cukunity」といった言葉自体が「Cucumber」と「Unity」というかばん語である。
そういう意味では、[Cucumber](http://cukes.info)用のヘルパークラスも提供するが
cukunityを単体でも使える（操作のシミュレーションなどのため）。

下記にcukunityの基本機能の説明である：

* 実機でUnity3Dのゲームをインストール・アンインストール・実行することが出来るプラットフォームにとらわれないAPIの提供。
* Unity3Dのゲームにタッチ・キーボード入力といったイベントを発生（シミュレーション）させるプラットフォームにとらわれないAPIの提供。
* 既存のUnity3Dのプロジェクトにcukunityプラグインをインポートするための `cukunity` といった実行ファイルのツールの提供。 
* Cucumberで使えるデフォルトのヘルパークラスとステップ定義の提供。
* cucunityを使ったデフォルトのrakeタスクの提供。

## 制限

現状、cukunityの使い方が下記制限によって限られている。

* Android 2.x以降とiOS 5.x以降にしか対応していない（将来的に Desktop/Flash/WebPlayer にも適用出来ると望ましい)。
* XcodeはMacOSXでしか使えないためcukunityによるiOSでのテストもMacOSXでしか出来ない。
* iOSの場合、Unity3DプロジェクトのBuild Settingsにて "Development Build" といった設定が必要。
* Androidの場合、現状MacOSXでしか出来ていないが将来的に（約束ではないが）WindowsもLinuxもサポート可能 。

追加詳細は、`プロジェクトの進捗とロードマップ` を参照下さい。

## 本ツールを使うための必要な環境など

* Ruby 1.9.x以降（ [RVM](http://beginrescueend.com)  などでインストール可能）。
* cukunityをcucumberで使うにはcucumberをインストールする (例 `gem install cucumber`）。
* Mac OS X 10.6以降（Snow Leopardで動作確認したが、Lionでも大丈夫だと思う）。
* iOSの場合、iOS SDKを含めて [XCode 4.2](https://developer.apple.com/xcode/) 以降と [mobiledevice](http://github.com/imkira/mobiledevice) をインストール。
* Androidの場合、[Android SDK](http://developer.android.com/sdk/) とplatform-toolsパケージをインストール。

## インストール方法

まずはRuby 1.9.x以降がインストールしてあることを確認した上で、cukunityを下記のようにインストールする：

```
gem install cukunity
```

最新バージョンを使うには、下記の方でインストールする：

```
git clone git://github.com/imkira/cukunity.git
cd cukunity
rake install
```

## 使い方

オプション無しで下記のようにcukunityを実行すると、

```
cukunity
```

下記の通り、基本使い方の説明画面の確認が出来る（下記は日本語に翻訳したもの）。

```
Usage: cukunity [オプション] <コマンド>

コマンド:
doctor              テスト環境に問題があるかどうかをチェック。
bootstrap <ぱパス>  既存のUnity3Dのプロジェクトにcukunityプラグインをインポート。
features [<パス>]  「path」に存在するcucumber用のフィチャーファイルをインプットにしてcucumberを実行する。

オプション:
    -v, --[no-]verbose               詳細出力をオン／オフにするといったスイッチ。
        --[no-]android               Androidプラットホームを使う／使わないといったスイッチ。
        --[no-]ios                   iOSプロとホームを使う／使わないといったスイッチ。
    -h, --help                       同ヘルップ画面を表示する。
```

### テスト環境に問題があるかどうかをチェック

cukunityをインストールした直後に、 `cuckunity doctor` を実行して
テスト環境に問題があるかどうかをチェックしよう！
同コマンドは、iOS及びAndroidでcukunityを使用するための必要なツールが
全てインストールされているかどうかっといったチェックを行う。
`--no-ios` もしくは `--no-android` を指定すれば、そのプラットホームのチェックを外すことが出来る。

### 既存のUnity3Dのプロジェクトにcukunityプラグインをインポート

既存のUnity3Dのプロジェクトにcukunityプラグインをインポートするには、
下記コマンドを実行する：

```
cukunity bootstrap <unity/プロジェクトへの/ベースのパス>
```

同コマンドは、必要なファイルを `Assets/Plugins` にコピーする。
その後に、 `CukunityInstance.prefab` といったプレハブをゲームの起動時に最初に読み込まれるシーンに
ドラッグ＆ドロップしてください。
「全てのシーンにも追加しないと行けないの？」、「他のシーンをロードしたらどうなるの？」など
は、もう手配済みなので大丈夫！

最後に、Unity3Dのプロジェクトを再ビルドする。
注意：iOSの場合は、 Unity3DプロジェクトのBuild Settingsにて"Development Build" といった設定を有効にしてください！

### フィチャー（機能）ファイルをインプットにしてcucumberを実行する

同コマンドでフィーチャーファイルをインプットにしてcucumberを実行することが出来る。

```
cukunity features <cucumber用の/features/フォルダーへの/パス>
```
同コマンドは、Rubyの `require 'cukunity/cucumber'` でcukunityをインクルードしてcucumberを実行する。
そして、`features` フォルダーにあるフィーチャーファイルをインプットとして `cucumber` を実行する。
また、`--no-ios` もしくは `--no-android` を指定すればそのプラットホームのテストが行われない。

## デフォルトのステップ定義

次は、`cukunity features` というコマンド（あるいは、Rubyで `require 'cukunity/cucumber'` ）で
デフォルトで使える機能の一覧である。そのため、予めコピーを撮っておく必要がない。ただ、
デフォルトの動作をカスタマイズしたりするには、コピーを撮っておいて好きに編集することが出来る。

* [ゲームをインストールする](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/install_steps.rb)
* [ゲームを起動する](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/install_steps.rb)
* [現在のシーン情報を取得する](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/get_scene_command_steps.rb)
* [キーボード入力のイベントを発生させる](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/keyboard_input_steps.rb)
* [タッチ入力のイベントを発生させる](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/touch_input_steps.rb)
* [画面に表示されているオブジェクトのセレクター](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/select_visible_steps.rb)
* [Unityのレベルをロードさせる](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/load_level_command_steps.rb)

### i18n（ローカライズ）対応

Cukunityが[i18n](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/i18n)に対応している。
現状英語がデフォルトですが、[日本語](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/i18n/ja)でのフィーチャーファイルの記述に対応している。

## フィーチャー定義のサンプル

下記は、倉庫番というゲームをテストするサンプルのフィーチャーの定義ファイルである。

```
# language: ja
フィーチャ: cukunityが提供するデフォルトのステップ定義のサンプル
  Unityのゲームをcukunityでテストするためには
  プログラマーとして
  Unityのデフォルトのステップ定義を使いたい。

  Background:
    # Specify fixtures/sokoban.apk (Android) or fixtures/sokoban.app (iOS) as the target game. 
    Given I install the app "fixtures/sokoban"
    # launch it on device
    And I launch it
    # You probably don't need this, but this will cause an Application.LoadLevel of "demo_title" level.
    And I load the "demo_title" level

  背景:
    # fixtures/sokoban.apk (Android) もしくは fixtures/sokoban.app (iOS) のようにテスト対象となるゲームへのパス（拡張子は不要）を指定するにして端末にインストールさせる。
    前提 "fixtures/sokoban"からゲームをインストールしている
    # 端末でアプリを起動させる。
    かつ ゲームを起動している
    # おそらく下記要らないかもしれないが、Application.LoadLevelで"demo_title"というレベルを強制的にロードさせる。
    かつ レベル"demo_title"をロードしている

  シナリオ: ゲームが起動する
    # ゲームが動作していることを確認する。
    かつ アプリが動作していること
    # "demo_title"というレベルがロードされていることを確認する。
    かつ レベル"demo_title"がロードされていること
    # "OptionsMenu"というGameObjectが存在しないことを確認する。
    かつ "OptionsMenu"が存在していないこと

  Scenario: Clear game
    When I tap "Play"
    And I tap "Up"
    # <ommited for simplicity>
    # A GameObject called "GameClear" should be visible.
    Then I should see "GameClear"
    # A label showing it took us "40" steps should be visible.
    And I should read "40"

  シナリオ: パーフェクトでレベル１をクリアする
    # "Play"という画面に表示されているGameObjectをタップさせる。
    もし "Play"をタップしたら
    # "Up"という画面に表示されているGameObjectをタップさせる。
    かつ "Up"をタップしたら
    # 省略
    # "GameObject"というGameObjectが画面に表示されているかを確認する。
    ならば "GameClear"を表示していること
    # "40"という内容を持ったラベルが画面に表示されているかを確認する。
    かつ "40"と表示していること

  シナリオ: Optionsメニューにてプレイヤー名を変更する
    # "Options"という画面に表示されているGameObjectをタップさせる。
    もし "Options"をタップしたら
    # "PlayerName"という画面に表示されているGameObjectをタップさせる。
    かつ "PlayerName"をタップしたら
    # "Super Player"という文字列をキーボードで入力させる。
    かつ "Super Player"と入力したら
    # "Super Player"という内容を持ったラベルが画面に表示されているかを確認する。
    ならば "Super Player"と表示していること

  シナリオ: ゲームをQuitボタンから終了する
    # "Quit"という画面に表示されているGameObjectをタップさせる。
    もし "Quit"をタップして3秒待ったら
    # ゲームが動作していない（いなくなる）ことを確認する。
    ならば アプリが動作していないこと
```

元々のUnityプロジェクトのソースコードは [こちらへ](http://github.com/imkira/cukunity/blob/master/Unity)。
サンプルのフィーチャーファイルは [こちらへ](http://github.com/imkira/cukunity/blob/master/features)。

## デモ動画

同動画は、主に[キーボード入力のイベント](http://github.com/imkira/cukunity/blob/master/features/keyboard_input.feature)と
[タッチ入力のイベント](http://github.com/imkira/cukunity/blob/master/features/touch_input.feature)のシミュレーションのデモ動画となる。
フィーチャーの記述ファイルは [こちらへ](http://github.com/imkira/cukunity/tree/master/features) 。

低解像度のデモ動画は、申し訳ない。どうか、基本機能のデモになればと嬉しい。

[デモ動画](http://youtu.be/3etDThp4fMo)

## ドキュメンテーション

cukunityのソースコードはまだドキュメンテーションがとても足りない。
近いうちにどうにかしたいが、それが出来るまでに自動生成されたドキュメンテーションを
[こちら](http://rubydoc.info/gems/cukunity/frames) でご参照ください。

## プロジェクトの進捗とロードマップ

現状、cukunityがUnityのコアなクラスの一部（GameObject、Component、Behavior、Camera、
GUIElement、GUIText、GUITexture、Transformなど）とGameObjectとGameObjectの親・子の関係しか対応していない。
そのため、今後のバージョンのロードマップとしてはUnityのデフォルトのクラスに完全に対応する事と
EZGUIのようなプラグインのクラスととあるゲームのスペシフィックなクラスのテストも
より簡単に対応出来る仕組みを用意する事。

また、実際に開発されてマーケットにリリースされているゲームのテストに役に立つステップ定義を
デフォルトのステップ定義として新しいステップ定義を提供したり、現在あるステップ定義を調整したりする必要があると。

## 「貢献したい！」

* 「不具合を発見！」
* 「こんな凄い機能を作っちゃったのでcukunityに追加したいけど...」

といった時にcukunityプロジェクトをforkしpull requestをお願いします！

## Twitter

cukunityに関する最新情報は [@imkira85](http://twitter.com/#!/imkira85) をフォーローください。

## コミューニティーの創ってくれた参考資料

* [cukunityのデモ実行手順](http://bit.ly/HE8YZa)
* [cukunity install memo](http://goo.gl/Lx1SD) 

## ライセンス

cukunityはMIT Licenseに準拠する：

www.opensource.org/licenses/MIT

## Copyright

Copyright (c) 2012 Mario Freitas.  [LICENSE.txt](http://github.com/imkira/cukunity/blob/master/LICENSE.txt)をご確認ください。
