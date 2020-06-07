
$(function(){
  
  // プルダウンのHTMLを生成
  function buildHTML(data){

    var html = $("<div>").addClass("header-bottom-left-category-field-nav")
    var link

    data.forEach(function(value){
      link = $("<a>", {
        href: "/api/categories/" + value.id ,
        "class":"category_name"
      }).text(value.name)
      link = $("<p>").append(link)

      html.append(link)
    })

    return html
  }

  // カテゴリーのタイトルに触れたら、一から表示し直す
  $("#catroy_top_title").mouseenter(function(){
    $(".header-bottom-left-category-field-nav").remove()
  })

   // マウスが離れた時に起動
   $(".header-bottom-left-category").mouseleave(function(){
    $(".header-bottom-left-category-field-nav").remove()
  })

  $(document).on({

    // カーソルが乗ったときに起動
    'mouseenter' : function() {

      // カテゴリーのパスを取得
      var path = $(this).attr("href");

      // 触れたカテゴリーの子要素を取得
      $.ajax({
        url: path,
        type: "GET",
        dataType: "json",
        context:this,
        cache: false,
      })
      .done(function(result){
  
        // 子要素がなければ選択肢を表示しない
        if( result.length != 0 ){
  
          // 選択したフォームの下に新たなフォームを追加
          var html = buildHTML(result)

          // 先に追加されていたリストがあれば削除
          $(this).parent().parent().nextAll(".header-bottom-left-category-field-nav").remove()
          $(".header-bottom-left-category-field").append(html)

        } 

      })

      // マウスが離れた時に起動
      $(".header-bottom-left-category-field-nav").mouseenter(function(eo){ 
        $(this).find("a").css("color","")
      })

    },'mouseleave' : function(){

       // マウスが離れた時に起動
      $(".header-bottom-left-category-field-nav").mouseleave(function(eo){
        $(eo.fromElement).css("color","orange")
      })
     
    }
  }, ".category_name")

 
 

})

