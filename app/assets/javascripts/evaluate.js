
$(function () {
    //評価ボタンクリック時色付け（クラス付与）
    $(".radio_btns").on("click", ".label_btn", function () {
        $(".label_btn").removeClass("checked");
        $(this).addClass("checked");
    })
})