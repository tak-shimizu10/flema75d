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
                <input class= "input_photo_file" type= "file"
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
            if (countPreview >= 1) hideCautionMessage($(".items_new_form_photos"));
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
            $("#input_photos_field").append(buildFileField(fileIndex[0]));
    });

    //商品説明の文字数表示
    $(".items_new_detail").on("keyup change", "#item_detail", function () {
        let targetWordCount = $(this).val().length;
        $(".input_text_length").html(`${targetWordCount}`);

    });

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
        if ($(this).context.value.length > 0) {
            hideCautionMessage($(".items_new_name"));
        } else {
            showCautionMessage($(".items_new_name"));
        };
    });
    $("form").on("keyup", "#item_detail", function () {
        if ($(this).context.value.length > 0) {
            hideCautionMessage($(".items_new_detail"));
        } else {
            showCautionMessage($(".items_new_detail"));
        };
    });
    $("form").on("change", "#item_status", function () {
        if (this.selectedIndex > 0) {
            hideCautionMessage($(".items_new_status"));
        } else {
            showCautionMessage($(".items_new_status"));
        };
    });
    $("form").on("change", "#item_pay_side", function () {
        if (this.selectedIndex > 0) {
            hideCautionMessage($(".items_new_pay_side"));
        } else {
            showCautionMessage($(".items_new_pay_side"));
        };
    });
    $("form").on("change", "#item_prefecture_id", function () {
        if (this.selectedIndex > 0) {
            hideCautionMessage($(".items_new_post_prefecture"));
        } else {
            showCautionMessage($(".items_new_post_prefecture"));
        };
    });
    $("form").on("change", "#item_post_date", function () {
        if (this.selectedIndex > 0) {
            hideCautionMessage($(".items_new_post_date"));
        } else {
            showCautionMessage($(".items_new_post_date"));
        };
    });
    $("form").on("keyup", "#item_price", function () {
        if ($(this).context.value.length > 0) {
            hideCautionMessage($(".items_new_form_price"));
        } else {
            showCautionMessage($(".items_new_form_price"));
        };
    });
});