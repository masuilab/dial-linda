# Dialコントローラー

- https://github.com/masuilab/dial-linda

![Dial](http://gyazo.com/e746e7f0b3bcacabd8d423fcb3ad09fe.png)

- ロータリーエンコーダ
  - digital pin 3,4 に接続
- ジョグシャトル
  - digtial pin 5,6,7,8 に接続


## nodeインストール

    % brew install node


## nodeモジュールインストール

    % npm install


## サーバー起動

    % npm start

=> http://localhost:3000


### portやArduinoを指定して起動

    % PORT=5000 ARDUINO=/dev/tty.usb-devicename npm start
