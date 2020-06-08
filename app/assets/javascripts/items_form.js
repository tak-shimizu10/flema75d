$(function () {
    //プレビュー生成の関数
    //引数で番号と画像のURLを取得し、カスタムデータインデックス(data-index="${index}")を用いて番号を割り当てる。
    const buildPhotoPreview = (index, url) => {
        const html =
            `<div data-index= "${index}" class= "input_photo_preview">
                <img data-index= "${index}" src= "${url}" width= "100px" height= "100px">
                <span class= "input_photo_edit">変更</span>
                <span class= "input_photo_remove">削除</span>
            </div>`;
        return html;
    }
    //file_field生成の関数
    //引数で番号を取得し割り当てる
    //nameやidはネストしたモデルに対して保存するために必要な記述
    //name="item[images_attributes][${index}][image]" → item.images[番号].imageを表す。
    //idも同様 photo_file_${index}は識別を容易にするためにidを与えた。
    //labelのdata-index="${index}"のindexに割り当てられた番号を元に情報を取得するため与えている。
    const buildFileField = (index) => {

        const html =
            `<label class= "input_photo_field" data-index= "${index}">
                <input class= "input_photo_file" type= "file", required= "false"
                name= "item[images_attributes][${index}][image]"
                id= "item_images_attributes_${index}_image photo_file_${index}"><br>
                <img class= "fas fa-camera" src= "/assets/icon/icon_camera-24c5a3dec3f777b383180b053077a49d0416a4137a1c541d7dd3f5ce93194dee.png">
                <p class= "photos_input_text">クリックしてファイルをアップロード</p>
            </label>`;
        return html;
    }

    //エラーメッセージの表示・非表示の関数宣言
    //引数で与えられたクラスの中からclass="items_caution"を検索 
    //show()がcssにdisplay: block; を付与
    //hide()がcssにdisplay: none; を付与
    //検証画面で確認してもらうと付与されているのが確認できます。
    function showCautionMessage(scopeClass) {
        scopeClass.find(".items_caution").show();
    }
    function hideCautionMessage(scopeClass) {
        scopeClass.find(".items_caution").hide();
    }

    //fileIndexという配列を作成し、これを用いて番号を割り当てていく。
    let fileIndex = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let lastIndex = $(".input_photo_field:last").data("index");
    fileIndex.splice(0, lastIndex);
    if (fileIndex.length < 1) fileIndex.push(lastIndex + 1);
    while (fileIndex.length <= 10) {
        fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
    }
    $(".hidden_destroy").hide();

    //ファイル選択時新しいpreview, file_fieldを生成
    $("#input_photos_field").on("change", ".input_photo_file", function (e) {
        const targetIndex = $(this).parent().data("index");
        const file = e.target.files[0];
        const blobUrl = window.URL.createObjectURL(file);
        if (searchPreview = $(".input_photo_preview").filter(`[data-index= "${targetIndex}"]`)[0]) {
            const img = $(searchPreview).children("img")[0]
            img.setAttribute('src', blobUrl);
        } else {
            $(".input_photo_field").hide();
            $("#input_photos_field").append(buildPhotoPreview(targetIndex, blobUrl));
            $("#input_photos_field").append(buildFileField(fileIndex[0]));
            const countPreview = $(".input_photo_preview").length;
            fileIndex.shift();
            fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
            $(".input_photo_field").last().show();
            //画像が10枚登録されればfile_fieldを隠す。一枚以上登録されれば、pタグの文字を消して登録が通るように
            if (countPreview >= 10) showOnlyOneFileField();
            if (countPreview >= 1) {
                hideCautionMessage($(".items_form_photos"));
                $(".photos_input_text").html(``);
                $(".input_photo_file").attr("required", false);
            }
        }
    });
    
    //削除ボタンクリックで選択されたpreviewとfilefieldの削除
    $("#input_photos_field").on("click", ".input_photo_remove", function (e) {
        
        const targetIndex = $(this).parent().data("index");
        const countPreview = $(".input_photo_preview").length - 1
        const hiddenCheckbox = $(".hidden_destroy")[targetIndex];
        const lastFileField = $(".input_photo_field").last();
        $(this).parent().remove();
        $(`label[data-index= "${targetIndex}"]`).remove();

        if (countPreview == 0) {
            showCautionMessage($(".items_form_photos"))
            $(".photos_input_text").html(`クリックしてファイルをアップロード`)
        }
        if (countPreview <= 10) (lastFileField).show();
        if ($(".input_photo_preview").length == 0) {
            $(".input_photo_file").attr("required", true);
        } else {
            $(".input_photo_file").attr("required", false);
        }
        if (hiddenCheckbox) $(hiddenCheckbox).prop("checked", true);
    });

    //商品説明の文字数表示
    $(".items_detail").on("keyup change", "#item_detail", function () {
        let targetWordCount = $(this).val().length;
        $(".input_text_length").html(`${targetWordCount}`);
    });

    //配送の方法表示・非表示
    $(".items_form_list").on("change", "#item_pay_side", function (e) {
        if (e.target.selectedIndex == 0) {
            $(".items_post_way").hide();
            $("#item_post_way_id").val("");
            hideCautionMessage($(".items_post_way"));
        } else {
            $(".items_post_way").show();
        };
    })

    //価格の表示(販売手数料、販売利益)入力時と決定時に変化
    function inputPricePreview(input) {
        let targetPrice = $(input).val();
        if (targetPrice >= 10000000) $(input).val(9999999);
        let calculateFee = Math.floor(targetPrice * 0.1);
        let calculateProfit = targetPrice - calculateFee;
        $(".display_fee_value").html(`¥${calculateFee.toLocaleString()}`);
        $(".display_profit_value").html(`¥${calculateProfit.toLocaleString()}`);
    }
    $("#item_price").on("keyup change", function () {
        inputPricePreview(this);
    });

    //ドラッグ＆ドロップ操作しても画面が切り替わらないように
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

    //フォーム入力時空にするとエラーメッセージ表示・非表示
    $(".items_form_list").on("keyup", "#item_name", function () {
        let inputNameLength = $(this).context.value.length;
        if (inputNameLength > 0) {
            hideCautionMessage($(".items_name"));
        } else {
            showCautionMessage($(".items_name"));
        };
    });
    $(".items_form_list").on("keyup", "#item_detail", function () {
        let inputDetailLength = $(this).context.value.length;
        if (inputDetailLength > 0) {
            hideCautionMessage($(".items_detail"));
        } else {
            showCautionMessage($(".items_detail"));
        };
    });
    $(".items_form_list").on("change", "#category_base #item_category_id", function () {
        let selectCategory = $(this).val();
        if (selectCategory > 0) {
            hideCautionMessage($(".items_category"));
        } else {
            showCautionMessage($(".items_category"));
        };
    })
    $(".items_form_list").on("change", "#item_status", function () {
        let selectStatus = this.selectedIndex;
        if (selectStatus > 0) {
            hideCautionMessage($(".items_status"));
        } else {
            showCautionMessage($(".items_status"));
        };
    });
    $(".items_form_list").on("change", "#item_pay_side", function () {
        let selectPaySide = this.selectedIndex;
        if (selectPaySide > 0) {
            hideCautionMessage($(".items_pay_side"));
        } else {
            showCautionMessage($(".items_pay_side"));
        };
    });
    $(".items_form_list").on("change", "#item_prefecture_id", function () {
        let selectPrefecture = this.selectedIndex;
        if (selectPrefecture > 0) {
            hideCautionMessage($(".items_post_prefecture"));
        } else {
            showCautionMessage($(".items_post_prefecture"));
        };
    });
    $(".items_form_list").on("change", "#item_post_date", function () {
        let selectPostDate = this.selectedIndex;
        if (selectPostDate > 0) {
            hideCautionMessage($(".items_post_date"));
        } else {
            showCautionMessage($(".items_post_date"));
        };
    });
    $(".items_form_list").on("keyup", "#item_price", function () {
        let inputPriceLength = $(this).context.value.length;
        if (inputPriceLength > 0) {
            hideCautionMessage($(".items_form_price"));
        } else {
            showCautionMessage($(".items_form_price"));
        };
    });
    $(".items_form_list").on("change", "#item_post_way_id", function () {
        let inputPostWayLength = $(this).context.value.length;
        if (inputPostWayLength > 0) {
            hideCautionMessage($(".items_post_way"));
        } else {
            showCautionMessage($(".items_post_way"));
        };
    });

    //送信ボタンクリック時、空のフォームにエラーメッセージ表示
    $(".items_form_list").on("click", ".item_submit", function () {

        if ($("#photos_input .input_photo_preview").length == 0) {
            showCautionMessage($(".items_form_photos"));
            $("html, body").scrollTop($("#photos_input").offset().top);
        }
        if ($("#item_name").val().length == 0)
            showCautionMessage($(".items_name"));
        if ($("#item_detail").val().length == 0)
            showCautionMessage($(".items_detail"));
        if ($("#category_base #item_category_id").val().length == 0)
            showCautionMessage($(".items_category"));
        if ($("#item_status").val().length == 0)
            showCautionMessage($(".items_status"));
        if ($("#item_pay_side").val().length == 0)
            showCautionMessage($(".items_pay_side"));
        if ($("#item_post_way_id").val().length == 0)
            showCautionMessage($(".items_post_way"));
        if ($("#item_prefecture_id").val().length == 0)
            showCautionMessage($(".items_post_prefecture"));
        if ($("#item_post_date").val().length == 0)
            showCautionMessage($(".items_post_date"));
        if ($("#item_price").val() == 0)
            showCautionMessage($(".items_form_price"));
        
    });

    //file_fieldが1つになるように
    function showOnlyOneFileField() {

        existFileField = $(".input_photo_field").length
        while (existFileField > 11) {
            $(".input_photo_preview").last().remove();
            $(".input_photo_field").last().remove();
        }
        $(".input_photo_field").hide();
        if (existFileField <= 10)
            $(".input_photo_field").last().show();
        
    }
    //画面読み込み時の処理、ファイルがあれば送信を許可してfilefield制御に移動
    $(window).on("load", function () {

        if ($(".items_form").length != 0) {
            if ($(".input_photo_field").length > 10) showOnlyOneFileField();
            if ($(".input_photo_preview").length > 0 && $(".input_photo_field").length > 1)
                $(".input_photo_file").attr("required", false);
            if ($("#item_pay_side").val().length > 0) $(".items_post_way").show();
            showOnlyOneFileField();
            if ($("#item_price").val() > 0) inputPricePreview($("#item_price")[0]);
        }
    });
    
    function moveSelectCategory(index) {
        const movePoint = $(".list_category")[index];
        $("html, body").animate({ scrollTop: $(movePoint).offset().top });
    }
    $(".categories_show").on("click", ".link", function () {
        moveSelectCategory($(this).data("index"))
    })
    //プレビュー編集ボタンをクリックしたとき、相対するFileFieldのクリックを実行
    $("#input_photos_field").on("click", ".input_photo_edit", function () {
        const targetIndex = $(this).parent().data("index");
        const targetFileField = $(".input_photo_field").filter(`[data-index= "${targetIndex}"]`)[0];
        $(targetFileField).click();
    });
    //電話番号入力
    $(".field-input").on("keypress", "#user_phone_number", function (e) {
        let string = String.fromCharCode(e.which);
        if ("0123456789".indexOf(string, 0) < 0) return false;
        return true;
    });
    //マイページスクロール用
    $(".account_show").on("click", ".link_page", function () {
        window.scroll({
            top: 200,
            behavior: "smooth"
        });
    });
});