$(function () {
    $('#floara-upload-image').froalaEditor({
        // Set the image upload URL.
        imageUploadURL: '/upload_image',

        imageUploadParams: {
            id: 'my_editor'
        }
    })
});
