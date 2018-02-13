function show(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary)
    
    size(coverImageGrayScale)
    figure,subplot(1,2,1);imhist(uint8(CoverImageGrayScaleTemp)); title('before embedding');
    subplot(1,2,2);imhist(uint8(coverImageGrayScale)); title('after embedding');
    disp('psnr')
    psnr(coverImageGrayScale,CoverImageGrayScaleTemp)
    disp('mean square error')
    immse(coverImageGrayScale,CoverImageGrayScaleTemp)
    figure,subplot(1,2,1);   imshow(CoverImageGrayScaleTemp); title('Before embedding ');
    subplot(1,2,2); imshow(coverImageGrayScale); title('After embedding');
    figure,imshow(watermarkBinary);
    deWatermarkingFunction(coverImageGrayScale,watermarkBinary);
end