// addEventListenerメソッド→クリックやキーボードからの入力といった様々なイベント処理を実行するメソッド。
// [書き方]対象の要素.addEventListener(イベントの種類, 実行するための関数, イベント伝搬の方式をtrueかfalseで指定);
// document(HTMLすべて)
// addEventListener("DOMContentLoaded（ページの骨組み（HTML）が全部読み込まれて準備できたときに実行される合図→そのタイミングで関数に書いた処理を実行してほしい）
// function→ここから関数の定義、イベント伝搬の方式は省略（デフォルトでfalse、通常falseを記載する）
document.addEventListener('DOMContentLoaded', () => {
  // const(変数宣言)で「Swiperクラス（＝スライドショーの機能を持った設計図）」を使って新しいインスタンス（＝実際に動くスライドショー）を作成し、
  // それを swiper という名前の変数に代入（".mySwiper"はHTML上で記載したクラス名→どこでそのスライドショーを動かすかを指定）
  new Swiper('.mySwiper', {
    loop: true,            // ループさせる
    autoplay: {            // 自動スライド設定
      delay: 3000,         // 3秒ごとに切り替え
    },
    // 1スライドあたりに表示する枚数は1（each_slice(3)で３件のスライドに設定）
    slidesPerView: 1,
    // スライド間のスペース（margin）を「30px」に設定
    spaceBetween: 30,
  });
});


