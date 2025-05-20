window.initMap = async function () {
  const { Map } = await google.maps.importLibrary("maps");
  const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

  // 地図の初期化（中心座標はRails側で渡すかデフォルトを使う）
  const latitude = window.LATITUDE || 35.681236;
  const longitude = window.LONGITUDE || 139.767125;

  const map = new Map(document.getElementById("map"), {
    center: { lat: latitude, lng: longitude },
    zoom: 15,
    mapId: "DEMO_MAP_ID",
    mapTypeControl: false,
  });

  try {
    // 単一投稿のJSONを取得（例：/posts/:id.json）
    const response = await fetch(`/posts/${window.POST_ID}.json`);
    if (!response.ok) throw new Error("Network response was not ok");

    const post = await response.json();

    const position = { lat: post.latitude, lng: post.longitude };

    const marker = new AdvancedMarkerElement({
      position,
      map,
      title: post.title || "No title",
    });

    // ここで InfoWindow をインスタンス化
    const infoWindow = new google.maps.InfoWindow();

    // 情報ウィンドウの内容を設定
    const contentString = `
      <div style="max-width: 250px;">
        <h5>${post.title || ''}</h5>
        <p><strong>説明:</strong> ${post.body || ''}</p>
        <p><strong>住所:</strong> ${post.address || ''}</p>
      </div>
    `;

    marker.addEventListener("gmp-click", () => {
      infoWindow.setContent(contentString);
      infoWindow.open({
        anchor: marker,
        map,
        shouldFocus: false,
      });
    });
  } catch (error) {
    console.error("Error fetching or processing post:", error);
  }
};
