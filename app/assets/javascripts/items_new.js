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
                <p class= "photos_input_text">ドラッグ＆ドロップ<br>またはクリックしてファイルをアップロード</p>
            </label>`;
        return html;
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
            if ($(".input_photo_file").length == 11) $("#input_photo_field").hide();
        }
    });
    //削除ボタンクリックで選択されたpreviewとfilefieldの削除
    $("#input_photos_field").on("click", ".input_photo_remove", function () {

        const targetIndex = $(this).parent().data("index");
        const hiddenCheckbox = $(`input[data-index= "${targetIndex}"].hidden_destroy`);
        $(this).parent().remove();
        $(`label[data-index= "${targetIndex}"]`).remove();

        if ($(".input_photo_file").length == 0) $("#input_photos_field").append(buildFileField(fileIndex[0]));
    });
});