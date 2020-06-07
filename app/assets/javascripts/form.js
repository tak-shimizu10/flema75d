// 郵便番号のハイフン自動入力
window.onload = function() {
  var elements = document.getElementsByClassName("postcd");
  for(var i=0;i<elements.length;i++) {
    elements[i].onfocus = function(){offPostFmt(this);}
    elements[i].onblur = function(){toPostFmt(this);}
  }
}

// 郵便番号入力のフォーカスがはずれると、全角を半角に自動変換
$(function(){
  $("#address_zipcode").change(function(){
      var str = $(this).val();
      str = str.replace( /[Ａ-Ｚａ-ｚ０-９－！”＃＄％＆’（）＝＜＞，．？＿［］｛｝＠＾～￥]/g, function(s) {
          return String.fromCharCode(s.charCodeAt(0) - 65248);
      });
      $(this).val(str);
  }).change();
});

// 郵便番号入力で、住所を自動検索（プラグインjquery.jpostal.js）
$(function() {
  return $("#address_zipcode").jpostal({
    postcode: ["#address_zipcode"],
    address: {
      "#address_prefecture_name": "%3",
      "#address_city": "%4%5",
      "#address_street": "%6%7"
    }
  });
});

// 必須の入力フォームが未入力の場合、エラーメッセージ
$(function () {
  $('input.required').on('blur', function() {
    var error; // エラー用の変数を定義
    if( $(this).val() === '' ) { // この要素のvalueが空文字だったらエラー
      error = true;
    }
    if( error ) {
      // エラーが見つかった場合
      if( !$(this).next('span.error').length ) { // このようの後続要素が存在しない場合
        $(this).after('<span class="error">未入力です</span>'); // この要素の後にエラーメッセージを挿入
      }
    } else {
      // エラーがなかった場合
      $(this).next('span.error').remove(); // この要素の後続要素を削除
    }
  });
});