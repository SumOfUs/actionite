// Creates a function that returns parameters built based on DOM image element size
// that get passed to cropper.js for the image crop UI when creating petitions or donations.
create_cropper_parameters = function(ratio_width, ratio_height, image_id) {
    var dom_image = document.getElementById(image_id);
    //Since we want a fixed ratio. Setting max_width and height on top of the ratio is necessary
    //because we are using responsive images.
    var cropper_parameters = {
        ratio: {
            width: ratio_width,
            height: ratio_height
        },
        max_height: 0,
        max_width: 0,
    }        
    // Setting max dimensions for the image cropping box. 
    // If image is wider than it is tall, use its height to constrain crop size.
    // else, use its width. Without these, it fails on responsive images.
    if (dom_image.offsetHeight <= dom_image.offsetWidth) {
        cropper_parameters.max_height = dom_image.offsetHeight;
        cropper_parameters.max_width = cropper_parameters.max_height/ratio_height*ratio_width;
    }
    else {
        cropper_parameters.max_width = dom_image.offsetWidth;
        cropper_parameters.max_height = cropper_parameters.max_width/ratio_width*ratio_height;
    }
    return cropper_parameters;
}

$(document).ready(function (){
    $("#image_container").hide();
    $("#image_url").change(function() {
        $("#image").attr('src', $(this).val());
    })
    $("#image").load(function() {
        console.log('image loaded')
        $("#image_container").show();

        var image_cropper_parameters = create_cropper_parameters(14, 10, 'image');
        image_cropper_parameters.update = function (coordinates) {
            for (item in coordinates) {
                document.getElementById("image_"+ item).value = coordinates[item];
            }
        }
        // Creates a new cropper box on top of the image.
        // The object is passed as a DOM element with $(this).get(0), 
        // because the library expects a DOM element instead of a jQuery object.
        new Cropper($(this).get(0), image_cropper_parameters);

    })
    $("#image").unload(function() {
        console.log('unloaded image')
        $("#image_container").hide()
    })      
})