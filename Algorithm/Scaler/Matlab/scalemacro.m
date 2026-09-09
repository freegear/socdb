function scalemacro(filename,dstfile)

    orgimage = imread(filename);
    w        = sharpning(1);
    
    dstimage = bicubic(1920,1080,orgimage);
    sfimage  = imfilter(dstimage,w);
    imwrite(sfimage,dstfile);

end % end of function