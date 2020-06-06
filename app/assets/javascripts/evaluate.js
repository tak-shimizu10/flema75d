
$(function () {
    $(".radio_btns").on("click", ".label_btn", function () {
        $(".label_btn").removeClass("checked");
        $(this).addClass("checked");
    })
})