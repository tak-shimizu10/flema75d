
$(function(){ 

  function buildHTML(data,it){

    var select = $(it).clone().removeAttr("id").empty();
    var option = $("<option>",{value:""}).text("選択してください");
    select.append(option);

    data.forEach(function(value){
      option = $("<option>",{value:value.id}).text(value.name);
      select.append(option);
    })

    var html = $(it).parent().clone().removeAttr("id").html(select);

    return html
  }

  $(document).on("change",".category_list", function(event){
    
    event.preventDefault();
    
    // 選択したフォームより下にある選択肢を削除する
    $(this).parent().nextAll('.category_form').remove()

    var category_id =  $(this).val();
    if(category_id == null){
      return true;
    }

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
        var html = buildHTML(data,this)
        $(this).parent().after(html)
      } 
    })
    .fail(function(){
      console.log("error!")
    })

  })
})