// jpostal関数でjpostalライブラリの処理を定義
// idがzipcodeのinputタグに郵便番号が入力されると、jpostalが動作
function jpostal() {
  $('#zipcode').jpostal({
    postcode : ['#zipcode'],
    address : {
      '#post_image_address': '%3%4%5'
    }
  });
}
$(document).on("turbolinks:load", jpostal);