$(function(){
  // 郵便番号に自動でハイフンを挿入する
  function insertHyphen(input) {
    return input.slice(0, 3) + "-" + input.slice(3, input.length);
  };
  $(".field-input").on("keypress", "#address_zipcode", function (e) {
    let string = String.fromCharCode(e.which);
    if ("0123456789-".indexOf(string, 0) < 0) return false;
    return true;
  });
  $(".field-input").on("keyup", "#address_zipcode", function (event) {
    let input = $(this).val();
    let key = event.keyCode || event.charCode;
    if (key == 8 || key == 46) return false;
    if (input.length === 3) $(this).val(insertHyphen(input));
  });
  $(".field-input").on("blur", "#address_zipcode", function () {
    let input = $(this).val();
    if (input.length >= 3 && input.substr(3, 1) != "-") {
      $(this).val(insertHyphen(input));
    }
    if (input.length >= 8 && input.substr(3, 1) != "-") {
      $(this).val(insertHyphen(input.slice(0,-1)));
    }
  });

  // 郵便番号入力のフォーカスがはずれると、全角を半角に自動変換
  $("#address_zipcode").change(function(){
    var str = $(this).val();
    str = str.replace( /[Ａ-Ｚａ-ｚ０-９－！”＃＄％＆’（）＝＜＞，．？＿［］｛｝＠＾～￥]/g, function(s) {
        return String.fromCharCode(s.charCodeAt(0) - 65248);
    });
    $(this).val(str);
  }).change();

  // 必須の入力フォームが未入力の場合、エラーメッセージ
  $('input.required').on('blur', function() {
    var error; // エラー用の変数を定義
    if( $(this).val() === '' ) { // この要素のvalueが空文字だったらエラー
      error = true;
    }
    if( error ) {
      // エラーが見つかった場合
      if( !$(this).next('span.error').length ) { // この要素の後続要素が存在しない場合
        $(this).after('<span class="error">未入力です</span>'); // この要素の後にエラーメッセージを挿入
      }
    } else {
      // エラーがなかった場合
      $(this).next('span.error').remove(); // この要素の後続要素を削除
    }
  });

  // 郵便番号入力で、住所を自動検索（プラグインjquery.jpostal.js）
  return $("#address_zipcode").jpostal({
    postcode: ["#address_zipcode"],
    address: {
      "#address_prefecture_name": "%3",
      "#address_city": "%4%5",
      "#address_street": "%6%7"
    }
  });
})