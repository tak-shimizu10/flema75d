
$(function(){ 

  function buildHTML(data){

    var html = `<div class="category_form">\n`
    
    html += `  <p>　</p>\n  <select name="category_id" class="category_list">\n`

    html += `    <option value="">選択してください</option>\n`  
    data.forEach(function(value){
      html += `    <option value="${value.id}">${value.name}</option>\n`
    })
    html += `  </select>\n</div>`

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
        var html = buildHTML(data)
        $(this).parent().after(html)
      } 
    })
    .fail(function(){
      console.log("error!")
    })

  })
})