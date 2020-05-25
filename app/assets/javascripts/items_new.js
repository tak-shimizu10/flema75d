$(function () {
    //プレビュー生成の関数
    const buildPhotoPreview = (index, url) => {
        const html = `<img data-index="${index}" src="${url}" width="100px" height="100px">`;
        return html;
    }
    //file_field生成の関数
    const buildFileField = (index) => {
        const html = `
            <div data-index= "${index}" class= "input_photo_file_group">
                <input class= "input_photo_file" type= "file"
                name="item[images_attributes][${index}][image]"
                id= "item_images_attributes_${index}_image photo_file_${index}"><br>
                <div class= "input_photo_remove">削除</div>
            </div>`;
        return html;
    }

    let fileIndex = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    lastIndex = $(".input_photo_file_group:last").data("index");
    fileIndex.splice(0, lastIndex);

    $(".hidden_destroy").hide();

    //ファイル選択時新しいpreview, file_fieldを生成
    $("#photos_input").on("change", ".input_photo_file", function (e) {

        const targetIndex = $(this).parent().data("index");
        const file = e.target.files[0];
        const blobUrl = window.URL.createObjectURL(file);

        if (img = $(`img[data-index= "${targetIndex}"]`)[0]) {
            img.setAttribute("src", blobUrl);
        } else {
            $(".input_photo_previews").append(buildPhotoPreview(targetIndex, blobUrl));
            $("#photos_input").append(buildFileField(fileIndex[0]));
            fileIndex.shift();
            fileIndex.push(fileIndex[fileIndex.length - 1] + 1);
        }
    });
    //削除ボタン
    $("#photos_input").on("click", ".input_photo_remove", function () {
        const targetIndex = $(this).parent().data("index");
        const hiddenCheckbox = $(`input[data-index="${targetIndex}"].hidden_destroy`);

        $(this).parent().remove();
        $(`img[data-index= "${targetIndex}"]`).remove();
        if ($(".input_photo_file").length == 0) $("#photos_input").append(buildFileField(fileIndex[0]));
    })
});