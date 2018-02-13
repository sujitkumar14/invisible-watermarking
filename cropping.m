function cropping(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary,x,y,h,w)
    coverImageGrayScale = imcrop(coverImageGrayScale,[x y h w]);
    coverImageGrayScale = imresize(coverImageGrayScale,[256 256]);
    show(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary);
end
