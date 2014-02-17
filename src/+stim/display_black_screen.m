function display_black_screen(window, black, img, params)
    
    import gen.gen_show_img
    import stim.display_image
    
    % ---------- Show black screen in between stim 
    % presentations
    showimg = gen_show_img(img, [0 0 0], params.annulus);
    display_image(window, black, showimg, ...
        params.left, params.right)
    pause(params.pause_time);
end