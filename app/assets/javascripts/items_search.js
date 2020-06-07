$(function() {
  $(".search_box").on("keyup", function() {
    var input = $(this).val();
    $.ajax({
      type: 'GET',
      url: '/items/search',
      data: { keyword: input },
      dataType: 'json'
    })
    .done(function(items) {
      console.log(items);
    })
  });
});