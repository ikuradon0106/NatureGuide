// Leaflet.js を用いて、GBIF APIから取得した出現データを地図上にプロットする機能
// Leaflet.jsとは、オープンソースのJavaScriptライブラリ
// document（ページ全体）に対して、Turbolinksで新しいページが読み込まれたとき（turbolinks:load）に、
// 指定した処理（地図表示処理）を実行する
document.addEventListener("turbolinks:load", () => {
  // URLのクエリパラメータからtaxon_keyを取得（例：?taxon_key=12345）
  const taxonKey = new URLSearchParams(window.location.search).get("taxon_key");
  if (!taxonKey) return;  // taxon_keyがない場合は処理を中断

  // 地図を初期化し、ズームレベル2のグローバルマップを表示（Leafletライブラリ使用）
  const map = L.map("map").setView([0, 0], 2);

   // OpenStreetMapのタイルレイヤーを読み込み、地図に追加
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: '&copy; OpenStreetMap contributors', // 著作権表示
    maxZoom: 18 // 最大ズームレベルの設定
  }).addTo(map);

  // サーバー側に非同期でfetchリクエストを送り、生物種の出現データを取得
  fetch(`/maps/fetch_map_data?taxon_key=${taxonKey}`) 
    .then(response => response.json()) // レスポンスをJSONとして解析
    .then(data => {
      // 取得した出現データ（occurrences）を1件ずつ処理
      data.occurrences.forEach(occ => {
         // 緯度経度情報が存在するデータのみを対象とする
        if (occ.decimalLatitude && occ.decimalLongitude) {
           // 緯度経度にマーカーを配置し、ポップアップに学名（または「不明な学名」）を表示
          L.marker([occ.decimalLatitude, occ.decimalLongitude])
            .addTo(map)
            .bindPopup(occ.scientificName || "不明な学名");
        }
      });
    })
    .catch(error => {
      // データ取得に失敗した場合のエラーハンドリング（開発者向けログ）
      console.error("地図データの取得に失敗しました", error);
    });
});
