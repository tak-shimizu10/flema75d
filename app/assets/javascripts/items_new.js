$(function () {
    //プレビュー生成の関数
    const buildPreview = (index, url) => {
        const html =
            `<img data-index= "${index}" src= "${url}" width= "100px" height="100px">`;
        return html
    }
    //ファイル生成の関数
    const buildFileField = (index) => {
        const html =
            `<label class="upload_photo>
                <div data-index="${index}" id="input_photo_file">
                    <input class="input_upload_photo" type="file"
                    name=item[images_attributes][${index}][image]
                    id="item_images_attributes_${index}_image">
                    </div>
                </label>
                <div class="input_photo_remove">削除</div>`;
        return html;
    }
    
    let fileIndex =[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    $("#photos_input").on("change", ".input_photo_upload", function (e) {
        $("#photos_input").append(buildFileField(fileIndex[0]));
        fileIndex.shift();
        fileIndex.push(fileIndex(fileIndex.length - 1) + 1)
    });
    // $("#photos_input").on("change", ".input_photo_upload", function (e) {
    //     const targetIndex = $(this).parent().data("index");
    //     const file = e.target.files[0];
    //     const blobUrl = window.URL.createObjectURL(file);
    //     if(img = $(`img[data-index= "${targetIndex}"]`)[0]) {
    //         img.setAttribute("src", blobUrl);
    //     } else {
    //         $("#photos_input").append(buildPreview(targetIndex, blobUrl))
    //         $("#photos_input").append(buildFileField(fileIndex[0]));
    //         fileIndex.shift();
    //         fileIndex.push(fileIndex[fileIndex.length - 1] + 1)
    //     }
    // });

    //ファイル削除
    $(".input_photo_remove").on("click", function () {
        $(this).parent().remove();
        console.log(this);
        if ($(".input_photo_remove").length == 0) $("#photos_input").append(buildFileField(fileIndex[0]));
        $(`img[data-index= "${targetIndex}"]`).remove();
    });

});