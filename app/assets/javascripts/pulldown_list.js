
$(function(){ 

  function buildHTML(data){

    var html = `<div class="categories_nav category-child">\n`

    data.forEach(function(value){
      html += `  <a class="category_name" data-category-id="${value.id}" href="/categories/${value.id}"><p>${value.name}</p></a>\n`
    })
    html += `</div>`

    return html
  }

  $(document).on({
    'mouseenter' : function() {

      // 触れたカテゴリーのidを取得
      category_id = $(this).data("category-id")

      // 触れたカテゴリーの子要素を取得
      $.ajax({
        url: "/api/selects",
        type: "GET",
        dataType: "json",
        context: this,
        cache: false,
        data: {
  
          // 選択されたカテゴリーのidを取得
          // 表示は日本語だが、実際の値はidになる
          category_id: category_id
        }
      })
      .done(function(data){
  
        // 子要素がなければ選択肢を表示しない
        if( data.length != 0 ){
  
          // 選択したフォームの下に新たなフォームを追加
          var html = buildHTML(data)
          $(this).parent().nextAll(".category-child").remove()
          $(this).parent().after(html)
          $(".categories_nav").css("display","block");

        } 
      })
      .fail(function(){

          console.log("error!")
          $(".category-child").remove()
          
      })

    },
    'mouseleave' : function(){}

    }, ".category_name");

    // リスト全体からポインタが離れたら見えなくする
    $(document).on({
      'mouseenter' : function() {
        $(".categories_nav").css("display","block");
      },
      'mouseleave' : function(){
        $(".categories_nav").css("display","none");
        $(".category-child").remove()
      }
    },".category_lists")

})