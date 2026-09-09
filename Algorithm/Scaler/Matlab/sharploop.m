function sharploop(orgimage)

    w = sharpning(1);
    sfimage1 = imfilter(orgimage,w);
    imwrite(sfimage1,'shimage_n1_1920_1080.bmp');
    
    w = sharpning(2);
    sfimage1 = imfilter(orgimage,w);
    imwrite(sfimage1,'shimage_n2_1920_1080.bmp');

    w = sharpning(3);
    sfimage1 = imfilter(orgimage,w);
    imwrite(sfimage1,'shimage_n3_1920_1080.bmp');

end % end of function