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
    //ページ読み込み時に選択しているファイルの最後に割り当てられた番号を取得し、
    //配列の０番目から最後の番号までを取り除く
    //ex)lastIndex= 5 → fileIndex.splice(0, 5) → fileIndex=[7, 8, 9, 10]
    let lastIndex = $(".input_photo_field:last").data("index");
    fileIndex.splice(0, lastIndex);
    //fileIndexの配列の数が１０になるように最後のインデックスから順に足していく処理
    //fileIndex=[]の状態なため編集画面の最後のインデックスの値を追加
    if (fileIndex.length < 1) fileIndex.push(lastIndex + 1);
    //fileIndex[11]or[7, 8, 9, 10]等になっているため配列の数が１０になるまで、
    //fileIndex配列内の最後の数を追加する。
    while (fileIndex.length <= 10) {
        fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
    }
    //編集用の削除機能をつけた要素のクラスを隠す。
    $(".hidden_destroy").hide();

    //ファイル選択時新しいpreview, file_fieldを生成
    $("#input_photos_field").on("change", ".input_photo_file", function (e) {
        //選択されたファイルの番号を取得
        const targetIndex = $(this).parent().data("index");
        //選択されたファイルのFileオブジェクトを取得
        const file = e.target.files[0];
        //url形式に変換
        const blobUrl = window.URL.createObjectURL(file);
        //選択されたファイル番号と同じ番号のpreviewがないかで条件分岐
        //同じ番号のものがあれば、imgタグのurlを差し替える。
        if (searchPreview = $(".input_photo_preview").filter(`[data-index= "${targetIndex}"]`)[0]) {
            const img = $(searchPreview).children("img")[0]
            img.setAttribute('src', blobUrl);
        } else {
            //今見えているfile_fieldを隠して、要素の最後にプレビュー作成、その後にfile_fieldを新たに作成。
            $(".input_photo_field").hide();
            $("#input_photos_field").append(buildPhotoPreview(targetIndex, blobUrl));
            $("#input_photos_field").append(buildFileField(fileIndex[0]));
            //現在のプレビューの数
            const countPreview = $(".input_photo_preview").length;
            console.log("処理前")
            console.log(fileIndex)
            console.log(countPreview.length)
            //fileIndexから０番目の数を削除
            //fileIndex = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10] => fileIndex = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            fileIndex.shift();
            console.log(fileIndex);
            //fileIndexにfileIndexの最後の数字に一を足した数を追加
            //fileIndex = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] => fileIndex = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
            fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
            //file_fieldの最後の要素を表示する。display:none; => display:block;
            $(".input_photo_field").last().show();

            console.log("処理あと")
            console.log(fileIndex)
            console.log(countPreview.length)
            //画像が10枚登録されればfile_fieldを隠す。一枚以上登録されれば、pタグの文字を消して登録が通るように
            if (countPreview >= 10) showOnlyOneFileField();
            //一枚以上登録された場合
            if (countPreview >= 1) {
                //隠しているエラーメッセージ表示
                hideCautionMessage($(".items_form_photos"));
                //file_fieldの文字を消す。
                $(".photos_input_text").html(``);
                //送信ボタンが押せるようにinputの属性をrequired:false;にする
                $(".input_photo_file").attr("required", false);
            }
        }
    });
    
    //削除ボタンクリックで選択されたpreviewとfilefieldの削除
    $("#input_photos_field").on("click", ".input_photo_remove", function (e) {
        //クリックした削除ボタンの番号を取得
        //プレビューの数を取得
        //編集画面を開いた時元々登録されている画像を消すかどうかのチェックボックス（隠している）の要素を取得
        //file_fieldの最後の要素を取得
        const targetIndex = $(this).parent().data("index");
        const countPreview = $(".input_photo_preview").length - 1
        const hiddenCheckbox = $(".hidden_destroy")[targetIndex];
        const lastFileField = $(".input_photo_field").last();
        //削除ボタンを押したプレビューの削除、対応するfile_fieldの削除（data-indexが対応）
        $(this).parent().remove();
        $(`label[data-index= "${targetIndex}"]`).remove();
        //プレビューの数が０の場合
        if (countPreview == 0) {
            //エラーメッセージの表示、file_fieldの文字を挿入
            showCautionMessage($(".items_form_photos"))
            $(".photos_input_text").html(`クリックしてファイルをアップロード`)
        }
        //プレビューの数が10枚かなら、file_fieldの最後の要素を表示
        if (countPreview <= 10) (lastFileField).show();
        //登録されている画像が0枚の時input要素にrequired:true;をふよ（プレビューの数で判断）
        if ($(".input_photo_preview").length == 0) $(".input_photo_file").attr("required", true);
        //元々登録されてある要素に対応した削除用のチェックボックス（見えない）があれば、チェックする。
        //これをチェックすると元々登録されてある画像を削除する :_destroy アクションが働く。(ネストされたモデルの削除のためのアクション)
        if (hiddenCheckbox) $(hiddenCheckbox).prop("checked", true);
    });

    //商品説明の文字数表示 入力時と決定時にイベント発火
    $(".items_detail").on("keyup change", "#item_detail", function () {
        //入力された文字数を取得。取得した文字数を指定したHTMlに挿入
        let targetWordCount = $(this).val().length;
        $(".input_text_length").html(`${targetWordCount}`);
    });

    //配送の方法表示・非表示
    $(".items_form_list").on("change", "#item_pay_side", function (e) {
        //配送料の負担が選択されたかどうかで分岐
        //選択されなければ配送方法の表示を隠し、メッセージを表示
        //選択されれば、配送方法を選択肢を表示
        if (e.target.selectedIndex == 0) {
            $(".items_post_way").hide();
            $("#item_post_way_id").val("");
            hideCautionMessage($(".items_post_way"));
        } else {
            $(".items_post_way").show();
        };
    })

    //価格の表示(販売手数料、販売利益)入力時と決定時に変化
    $("#item_price").on("keyup change", function () {
        inputPricePreview(this);
    });
    function inputPricePreview(input) {
        //引数で与えられた入力欄（金額の入力欄）の値を取得
        let targetPrice = $(input).val();
        //７桁以上を入力されれば9999999に変更する
        if (targetPrice >= 10000000) $(input).val(9999999);
        //販売手数料の計算と販売利益の計算
        let calculateFee = Math.floor(targetPrice * 0.1);
        let calculateProfit = targetPrice - calculateFee;
        //計算した手数料と利益の値を指定したHTMLに挿入
        $(".display_fee_value").html(`¥${calculateFee.toLocaleString()}`);
        $(".display_profit_value").html(`¥${calculateProfit.toLocaleString()}`);
    }
    

    //ドラッグ＆ドロップ操作しても画面が切り替わらないように(stopPropagation()がページ遷移を止める関数)
    //ドラッグしたものが指定したエリアの上部に来た時実行
    $(".photos_input").on("dragover", "#input_photos_field", function (e) {
        e.stopPropagation();
        e.preventDefault();
        //id="input_photos_field"にclass="hover_photo_file"を付与
        //class="hover_photo_file"にcssを当てているため
        //JavaScript上でcssの記述しないで済むようにクラスの付与削除で色付けを行っている。
        $(this).addClass("hover_photo_file");
    });
    //ドラッグしたものが指定したエリアの上部から離れた時実行
    $(".photos_input").on("dragleave", "#input_photos_field", function (e) {
        e.stopPropagation();
        e.preventDefault();
        //id="input_photos_field"のclass="hover_photo_file"を削除
        $(this).removeClass("hover_photo_file");
    });
    //documentを指定することでページ全てに対して実行
    $(document).on("dragover drop", function (e) {
        e.stopPropagation();
        e.preventDefault();
    });

    //フォーム入力時空にするとエラーメッセージ表示・非表示
    //全ての入力欄と入力されているかどうかのチェック
    //入力されればメッセージを隠し、入力がなくなれば表示
    //商品名
    $(".items_form_list").on("keyup", "#item_name", function () {
        let inputNameLength = $(this).context.value.length;
        if (inputNameLength > 0) {
            hideCautionMessage($(".items_name"));
        } else {
            showCautionMessage($(".items_name"));
        };
    });
    //商品説明
    $(".items_form_list").on("keyup", "#item_detail", function () {
        let inputDetailLength = $(this).context.value.length;
        if (inputDetailLength > 0) {
            hideCautionMessage($(".items_detail"));
        } else {
            showCautionMessage($(".items_detail"));
        };
    });
    //カテゴリー選択
    $(".items_form_list").on("change", "#category_base #item_category_id", function () {
        let selectCategory = $(this).val();
        if (selectCategory > 0) {
            hideCautionMessage($(".items_category"));
        } else {
            showCautionMessage($(".items_category"));
        };
    });
    //商品の状態
    $(".items_form_list").on("change", "#item_status", function () {
        let selectStatus = this.selectedIndex;
        if (selectStatus > 0) {
            hideCautionMessage($(".items_status"));
        } else {
            showCautionMessage($(".items_status"));
        };
    });
    //配送料の負担
    $(".items_form_list").on("change", "#item_pay_side", function () {
        let selectPaySide = this.selectedIndex;
        if (selectPaySide > 0) {
            hideCautionMessage($(".items_pay_side"));
        } else {
            showCautionMessage($(".items_pay_side"));
        };
    });
    //発送地域
    $(".items_form_list").on("change", "#item_prefecture_id", function () {
        let selectPrefecture = this.selectedIndex;
        if (selectPrefecture > 0) {
            hideCautionMessage($(".items_post_prefecture"));
        } else {
            showCautionMessage($(".items_post_prefecture"));
        };
    });
    //発送の日数
    $(".items_form_list").on("change", "#item_post_date", function () {
        let selectPostDate = this.selectedIndex;
        if (selectPostDate > 0) {
            hideCautionMessage($(".items_post_date"));
        } else {
            showCautionMessage($(".items_post_date"));
        };
    });
    //価格
    $(".items_form_list").on("keyup", "#item_price", function () {
        let inputPriceLength = $(this).context.value.length;
        if (inputPriceLength > 0) {
            hideCautionMessage($(".items_form_price"));
        } else {
            showCautionMessage($(".items_form_price"));
        };
    });
    //配送の方法
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
        //全ての入力欄がからかどうかの判定→からならエラーメッセージ表示
        if ($("#photos_input .input_photo_preview").length == 0) {
            showCautionMessage($(".items_form_photos"));
            //required:true;が要素がないと検索できないため、スクロール位置を画像選択蘭の上部に指定してスクロール
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
        //file_fieldの数を取得
        existFileField = $(".input_photo_field").length
        //file_fieldが11より多ければ、11になるまで
        //filefieldとプレビューの最後の要素を削除
        while (existFileField > 11) {
            $(".input_photo_preview").last().remove();
            $(".input_photo_field").last().remove();
        }
        //file_fieldを隠す(display:none;)
        $(".input_photo_field").hide();
        //file_fieldが１０以下（登録数が9枚以下）なら最後の要素を表示
        if (existFileField <= 10) $(".input_photo_field").last().show();
        
    }
    //画面読み込み時の処理、ファイルがあれば送信を許可してfilefield制御に移動
    $(window).on("load", function () {
        //出品・編集画面でclass="items_form"を利用しているため、
        //他のページでエラーを吐き出さないように入力欄があるかどうかの判断をする。
        if ($(".items_form").length != 0) {
            //登録画像があれば表示するfile_fieldが一つになる関数（作成した関数）を呼び出し
            showOnlyOneFileField();
            //登録画像が一枚でもあればrequired:trueをfalseする。（送信ボタンを押せるように変更）
            if ($(".input_photo_preview").length > 0 && $(".input_photo_field").length > 1)
                $(".input_photo_file").attr("required", false);
            //配送方法が隠した状態なので表示するための条件付け
            if ($("#item_pay_side").val().length > 0) $(".items_post_way").show();
            //計算結果の表示がないので表示するの条件付け
            if ($("#item_price").val() > 0) inputPricePreview($("#item_price")[0]);
        }
    });
    //カテゴリー一覧での挙動の指定を記述
    function moveSelectCategory(index) {
        //割り当ててある対応するカテゴリーの場所へスクロール（animateで動きを付与）
        const movePoint = $(".list_category")[index];
        $("himl, body").animate({ scrollTop: $(movePoint).offset().top });
    }
    //カテゴリー一覧の上部にある親カテゴリー一覧をクリックでイベント発火
    $(".categories_show").on("click", ".link", function () {
        //クリックした親カテゴリーの番号を取得し引数で渡す。関数を実行
        moveSelectCategory($(this).data("index"))
    })
    //プレビュー編集ボタンをクリックしたとき、相対するFileFieldのクリックを実行(隠しているのでファイルの入れ替えを行うために)
    $("#input_photos_field").on("click", ".input_photo_edit", function () {
        //変更ボタンを押したプレビューに割り当てられた番号を取得
        //取得した番号と対応するfile_fieldを取得
        //取得したfile_fieldを実行するためにクリック（隠しているためjsでクリックしたことにする。）
        const targetIndex = $(this).parent().data("index");
        const targetFileField = $(".input_photo_field").filter(`[data-index= "${targetIndex}"]`)[0];
        $(targetFileField).click();
    });
});