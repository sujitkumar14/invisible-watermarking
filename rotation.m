function rotation(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary)
    coverImageGrayScale = imrotate(coverImageGrayScale,1);
    coverImageGrayScale = imresize(coverImageGrayScale,[256 256]);
    show(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary);
end