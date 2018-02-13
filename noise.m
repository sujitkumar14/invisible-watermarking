function noise(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary,str)
if strcmp(str,'salt & pepper')
    coverImageGrayScale = imnoise(coverImageGrayScale,str,0.01);
else
    coverImageGrayScale = imnoise(coverImageGrayScale,str,1,0.1);
end
    show(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary);
end
