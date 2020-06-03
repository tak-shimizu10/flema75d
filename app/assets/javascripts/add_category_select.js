
$(function () {

    function buildHTML(data, it) {

        var select = $(it).clone().removeAttr("id").empty();
        var option = $("<option>", { value: "" }).text("選択してください");
        select.append(option);

        data.forEach(function (value) {
            option = $("<option>", { value: value.id }).text(value.name);
            select.append(option);
        })

        var div = $(it).parent().clone().removeAttr("id").html(select);

        return div
    }

    $(document).on("change", ".category_list", function (event) {

        event.preventDefault();

        // 選択したフォームより下にある選択肢を削除する
        $(this).parent().nextAll('.category_form').remove()

        var category_id = $(this).val();

        $.ajax({
            url: "/api/categories/" + category_id,
            type: "GET",
            dataType: "json",
            context: this,
            cache: false
        })
            .done(function (data) {

                // 子要素がなければ選択肢を表示しない
                if (data.length != 0) {

                    // 選択したフォームの下に新たなフォームを追加
                    var html = buildHTML(data, this)
                    $(this).parent().after(html)
                }
            })
            .fail(function () {
                console.log("error!")
            })

    })

    $(window).on("load", function (e) {

        if ($("#item_category_id").val() > 0) {

            const selectedChildCategory = $(".category_list").last()[0];
            const selectedValue = $(".category_list").last().val();
            e.preventDefault();

            $.ajax({
                url: "/api/categories/" + selectedValue,
                type: "GET",
                dataType: "json",
                context: selectedChildCategory,
                data: { category_id: selectedValue }
            })
                .done(function (data) {
                    // 子要素がなければ選択肢を表示しない
                    if (data.length != 0) {
                        // 選択したフォームの下に新たなフォームを追加
                        html = buildHTML(data, selectedChildCategory);
                        $(selectedChildCategory).parent().after(html);
                    }
                })
                .fail(function () {
                    console.log("error!");
                });
        }
    });

})