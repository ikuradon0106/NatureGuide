// Leaflet.js を用いて、GBIF APIから取得した出現データを地図上にプロットする機能
// Leaflet.jsとは、オープンソースのJavaScriptライブラリ
// document（ページ全体）に対して、Turbolinksで新しいページが読み込まれたとき（turbolinks:load）に、
// 指定した処理（地図表示処理）を実行する(addEventListener→イベントを発生させたときに、指定した関数を実行するメソッド)
document.addEventListener("turbolinks:load", () => {
  // URLに含まれるクエリパラメータ（?から始まる「キー=値」の形式の情報）から taxon_key を取得する（例：?taxon_key=12345）
  // taxon_keyとは、GBIF において特定の生物分類群を識別するための ID のようなもの
  // URLSearchParams は、URLのクエリパラメータ（?key=value）を扱うためのWeb API（JSに組み込まれているAPI）
  // 引数の window.location.search は、現在のURLの「?」以降のクエリパラメータ全体を文字列で返す（例："?taxon_key=12345"）
  // .get("taxon_key") で、"taxon_key" という名前のパラメータの値を取得する（この例では "12345"）
  const taxonKey = new URLSearchParams(window.location.search).get("taxon_key");
  if (!taxonKey) return;  // taxon_keyがない場合は処理を中断（!でfalseを返す→returnでその関数から抜ける）

  // 地図を初期化し、ズームレベル2のグローバルマップを表示（Leafletライブラリ使用）
  // L.map() は、新しい地図インスタンスを作成するための関数
  // 引数の"map" は地図を表示するHTML要素（ここでは <div id="map">に表示してくださいとなる）
  // setView([0, 0], 2)で、初期に表示させる地図の中心位置と地図のズームレベルを設定 setView([経度, 緯度], ズームレベル)を意味
  const map = L.map("map").setView([0, 0], 2);

  // OpenStreetMapのタイルレイヤーを読み込み、作成した地図に追加
  // L.tileLayer()は、地図の背景となる「タイルレイヤー」を作成
  // タイルレイヤーとは、地図の画像を複数の小さな四角い画像（タイル）に分割し、それらを組み合わせて表示する仕組み
  // 引数のURLは、OpenStreetMapから地図画像を取得するためのURL
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: '&copy; OpenStreetMap contributors', // 著作権表示
    maxZoom: 18 // ユーザーがズームインできる最大のズームレベルを設定
  }).addTo(map); // map オブジェクト（作成した地図インスタンスに追加）に追加し、実際に画面に表示させる処理

  // サーバー側に非同期でfetchリクエストを送り、生物種の出現データを取得
  // fetch()で、指定したURLに対してHTTPリクエストを非同期に送信する
  // サーバーの /maps/fetch_map_data エンドポイントに、URLパラメータで taxon_key を付けてリクエストを送る(処理を依頼し、GBIF APIからデータを返す)
  // エンドポイントとは、WebサーバーやWebアプリケーションが外部からのリクエストを受け取る「窓口」のURLのこと
  fetch(`/maps/fetch_map_data?taxon_key=${taxonKey}`) 
    .then(response => response.json()) // そのレスポンスをJSON形式として変換し、.then()で扱いやすい形で受け取る
    .then(data => {
      // 取得したすべてのデータ（occurrences）を.forEach()で1件ずつ処理（occは単一のオブジェクト）
      data.occurrences.forEach(occ => {
        // 緯度経度情報が存在するデータのみを対象とする
        if (occ.decimalLatitude && occ.decimalLongitude) {
          // 緯度経度にマーカーを配置し、マーカーをクリックした際に学名（または「不明な学名」）を表示
          L.marker([occ.decimalLatitude, occ.decimalLongitude])
            .addTo(map)
            .bindPopup(occ.scientificName || "不明な学名");
        }
      });
    })

    // データ取得に失敗した場合の表示
    .catch(error => {
      console.error("地図データの取得に失敗しました", error);
    });
});
