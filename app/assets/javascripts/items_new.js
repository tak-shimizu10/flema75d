$(function () {
    //プレビュー生成の関数
    const buildPhotoPreview = (index, url) => {
        const html =
            `<div data-index= "${index}" id= "input_photo_preview">
                <img data-index= "${index}" src= "${url}" width= "100px" height= "100px">
                <span class= "input_photo_remove">削除</span>
            </div>`;
        return html;
    }
    //file_field生成の関数
    const buildFileField = (index) => {
        const html =
            `<label id= "input_photo_field" data-index= "${index}">
                <input class= "input_photo_file" type= "file", required= "false"
                name= "item[images_attributes][${index}][image]"
                id= "item_images_attributes_${index}_image photo_file_${index}"><br>
                <img class= "fas fa-camera" src= "/assets/icon/icon_camera-24c5a3dec3f777b383180b053077a49d0416a4137a1c541d7dd3f5ce93194dee.png">
                <p class= "photos_input_text">クリックしてファイルをアップロード</p>
            </label>`;
        return html;
    }

    //エラーメッセージの表示・非表示の関数宣言
    function showCautionMessage(scopeClass) {
        scopeClass.find(".items_new_caution").show();
    }
    function hideCautionMessage(scopeClass) {
        scopeClass.find(".items_new_caution").hide();
    }
    
    let fileIndex = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    lastIndex = $(".input_photo_file_group:last").data("index");
    fileIndex.splice(0, lastIndex);
    $(".hidden_destroy").hide();

    //ファイル選択時新しいpreview, file_fieldを生成
    $("#input_photos_field").on("change", ".input_photo_file", function (e) {

        const targetIndex = $(this).parent().data("index");
        const file = e.target.files[0];
        const blobUrl = window.URL.createObjectURL(file);

        if (img = $(`img[data-index= "${targetIndex}"]`)[0]) {
            img.setAttribute("src", blobUrl);
        } else {
            $(`label[data-index= "${targetIndex}"]`).hide();
            $("#input_photos_field").append(buildPhotoPreview(targetIndex, blobUrl));
            $("#input_photos_field").append(buildFileField(fileIndex[0]));
            fileIndex.shift();
            fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
            const countPreview = $("#input_photos_field #input_photo_preview").length;
            
            if (countPreview >= 10) $("label").hide();
            if (countPreview >= 1) hideCautionMessage($(".items_new_form_photos"))
            $(".input_photo_file").attr("required", false);
        }
    });

    //削除ボタンクリックで選択されたpreviewとfilefieldの削除
    $("#input_photos_field").on("click", ".input_photo_remove", function (e) {

        const targetIndex = $(this).parent().data("index");
        const hiddenCheckbox = $(`input[data-index= "${targetIndex}"].hidden_destroy`);
        const countPreview = $("#input_photos_field #input_photo_preview").length - 1;
        const lastFileField = $("#input_photos_field #input_photo_field").last();

        $(this).parent().remove();
        $(`label[data-index= "${targetIndex}"]`).remove();

        if (countPreview == 0) showCautionMessage($(".items_new_form_photos"));
        if (countPreview <= 9) (lastFileField).show();
        if ($(".input_photo_file").length == 0)
            $("#input_photos_field").append(buildFileField(fileIndex[0]))
            $(".input_photo_file").attr("required", true);
    });

    //商品説明の文字数表示
    $(".items_new_detail").on("keyup change", "#item_detail", function () {
        let targetWordCount = $(this).val().length;
        $(".input_text_length").html(`${targetWordCount}`);
    });

    //配送の方法表示・非表示
    $("form").on("change", "#item_pay_side", function (e) {
        if (e.target.selectedIndex == 0) {
            $(".items_new_post_way").hide();
            $("#item_post_way_id").val("");
            hideCautionMessage($(".items_new_post_way"));
        } else {
            $(".items_new_post_way").show();
        };
    })

    //価格の表示(販売手数料、販売利益)
    $("#item_price").on("keyup change", function () {
        let targetPrice = $(this).val();
        if (targetPrice >= 10000000) $(this).val(9999999);
        let calculateFee = Math.floor(targetPrice * 0.1);
        let calculateProfit = targetPrice - calculateFee;
        $(".display_fee_value").html(`¥${calculateFee.toLocaleString()}`);
        $(".display_profit_value").html(`¥${calculateProfit.toLocaleString()}`);
    });

    //ドラッグ＆ドロップ操作
    $(".photos_input").on("dragover", "#input_photos_field", function (e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).addClass("hover_photo_file");
    });
    $(".photos_input").on("dragleave", "#input_photos_field", function (e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).removeClass("hover_photo_file");
    });
    $(document).on("dragover drop", function (e) {
        e.stopPropagation();
        e.preventDefault();
    });

    //エラーメッセージ表示・非表示
    $("form").on("keyup", "#item_name", function () {
        let inputNameLength = $(this).context.value.length;
        if (inputNameLength > 0) {
            hideCautionMessage($(".items_new_name"));
        } else {
            showCautionMessage($(".items_new_name"));
        };
    });
    $("form").on("keyup", "#item_detail", function () {
        let inputDetailLength = $(this).context.value.length;
        if (inputDetailLength > 0) {
            hideCautionMessage($(".items_new_detail"));
        } else {
            showCautionMessage($(".items_new_detail"));
        };
    });
    $("form").on("change", "#item_category_id", function () {
        let selectCategory = $(this).val();
        if ( selectCategory > 0) {
            hideCautionMessage($(".items_new_category"));
        } else {
            showCautionMessage($(".items_new_category"));
        };
    })
    $("form").on("change", "#item_status", function () {
        let selectStatus = this.selectedIndex;
        if (selectStatus > 0) {
            hideCautionMessage($(".items_new_status"));
        } else {
            showCautionMessage($(".items_new_status"));
        };
    });
    $("form").on("change", "#item_pay_side", function () {
        let selectPaySide = this.selectedIndex;
        if (selectPaySide > 0) {
            hideCautionMessage($(".items_new_pay_side"));
        } else {
            showCautionMessage($(".items_new_pay_side"));
        };
    });
    $("form").on("change", "#item_prefecture_id", function () {
        let selectPrefecture = this.selectedIndex;
        if (selectPrefecture > 0) {
            hideCautionMessage($(".items_new_post_prefecture"));
        } else {
            showCautionMessage($(".items_new_post_prefecture"));
        };
    });
    $("form").on("change", "#item_post_date", function () {
        let selectPostDate = this.selectedIndex;
        if (selectPostDate > 0) {
            hideCautionMessage($(".items_new_post_date"));
        } else {
            showCautionMessage($(".items_new_post_date"));
        };
    });
    $("form").on("keyup", "#item_price", function () {
        let inputPriceLength = $(this).context.value.length;
        if (inputPriceLength > 0) {
            hideCautionMessage($(".items_new_form_price"));
        } else {
            showCautionMessage($(".items_new_form_price"));
        };
    });
    $("form").on("change", "#item_post_way_id", function () {
        let inputPostWayLength = $(this).context.value.length;
        if (inputPostWayLength > 0) {
            hideCautionMessage($(".items_new_post_way"));
        } else {
            showCautionMessage($(".items_new_post_way"));
        };
    });

    //送信ボタンクリック時、空のフォームにエラーメッセージ表示
    $("form").on("click", ".item_submit", function () {

        if ($("#input_photos_field #input_photo_preview").length == 0)
            showCautionMessage($(".items_new_form_photos"))
            $(window).scrollTop($("#photos_input").offset().top);
        if ($("#item_name").val().length == 0)
            showCautionMessage($(".items_new_name"));
        if ($("#item_detail").val().length == 0)
            showCautionMessage($(".items_new_detail"));
        if ($("#item_category_id").val().length == 0)
            showCautionMessage($(".items_new_category"));
        if ($("#item_status").val().length == 0)
            showCautionMessage($(".items_new_status"));
        if ($("#item_pay_side").val().length == 0)
            showCautionMessage($(".items_new_pay_side"));
        if ($("#item_post_way_id").val().length == 0)
            showCautionMessage($(".items_new_post_way"));
        if ($("#item_prefecture_id").val().length == 0)
            showCautionMessage($(".items_new_post_prefecture"));
        if ($("#item_post_date").val().length == 0)
            showCautionMessage($(".items_new_post_date"));
        if ($("#item_price").val() == 0)
            showCautionMessage($(".items_new_form_price"));
        
    });
});