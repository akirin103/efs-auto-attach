# efs-auto-attach
EC2にEFSをマウントし、EC2間でファイル共有ができることを確認する。

<br />

## プライベートサブネット内のEC2からパッケージをインストールする
VPCエンドポイントを作成し、ルーティング情報を追加することで外部パッケージをインストールできる。

<br />

## プライベートサブネット内のEC2に多段SSHする

```
$ ssh -o ProxyCommand='ssh -W %h:%p ec2-user@<パブリックサーバのpublic-ip>' ec2-user@<プライベートサーバのprivate-ip>
```

<br />

## 参考
[[初心者向け]EFSチュートリアル実装時にハマったところ](https://dev.classmethod.jp/articles/attach-efs-to-multiple-ec2-for-beginners/)

[【小ネタ】えっ、Private SubnetからNATサーバを経由せずにyum updateができるって！？](https://dev.classmethod.jp/articles/yum-update-in-private-subnet/)

<br />

## Memo
EC2のユーザデータ経由でEFSを自動マウントさせる場合、EC2よりEFSを先に作成すること。
