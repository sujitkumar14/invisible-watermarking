function  scaling(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary)
    coverImageGrayScale = imresize(coverImageGrayScale,[250 250]);
    coverImageGrayScale = imresize(coverImageGrayScale,[256 256]);
    show(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary);
end