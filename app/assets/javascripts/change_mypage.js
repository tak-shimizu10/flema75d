
$(function () {
  $('.link_page').on('click', function (event) {

    //リクエストを取得
    var path = $(this).attr("href");
    $.ajax({
      url: path,
      dataType: 'json',
      cache: false,
      type: 'get'
    }).done(function (result) {

      //今呼び出しているパーシャルを消して、受け取ったパーシャルを表示
      $('.body__main').html(result.html);
    }).fail(function (err) {
      console.log(err);
    })

  })
})