function [bBlockOut] =  watermarkingFunction(coverImagePathString,watermarkImagefunction)
    clc;
    %value for block division
    blocks =16;
    %step1: read cover image and convert it into a gray scale image
    coverImage = imread(coverImagePathString);
    coverImage = imresize(coverImage,[256 256]);
    coverImageGrayScale = rgb2gray(coverImage);
    CoverImageGrayScaleTemp = coverImageGrayScale;
    
    %rotation attack
    %coverImageGrayScale = imrotate(coverImageGrayScale,50);

    %read watermark image and convert it into binary image
    watermark = imread(watermarkImagefunction);
    watermark = imresize(watermark,[16  16]);
    watermarkBinary = im2bw(watermark);


    %step2:-divide image into blocks and find the entropy
    ent = blkproc(coverImageGrayScale,[blocks blocks],@entropy); %row wise
    %a=ent;
    %q=a(a>=5.5)
    %size(q)

    %threshold value for block selection ,tbs threshold block selection value 
    tbs = 5.5;
    [entx enty] = size(ent);
    valueEnt = []; %array formation  for value
    posEnt = []; %array formation for position
    entCell = cell(blocks);
    count =0;
    k =0;
    for i=1:entx
        for j=1:enty
            k = k+1;
            if ent(i,j)>tbs
               entCell{i,j} = ent(i,j);
               count = count +1;
               valueEnt(count) = ent(i,j);
               posEnt(count) = k;          
               %[val pos] = ent
            end
        end
    end

    valueLoc = containers.Map(posEnt,valueEnt);
    posEnt;
    valueEnt;
    % sorting of array based on entropy value
    for i=1:length(valueEnt)
        for j= i+1:length(valueEnt)
            if valueEnt(j)<valueEnt(i)
                temp = valueEnt(i);
                valueEnt(i) = valueEnt(j);
                valueEnt(j) = temp;

                temp = posEnt(i);
                posEnt(i) = posEnt(j);
                posEnt(j) = temp;
            end
        end
    end


    %disp('Total number of blocks:') 
    length(valueEnt);
    %disp('position of block selected:')
    posEnt;
    %disp('value of block selected')
    valueEnt;

%%%%%%%%%%%%%%%%%%%%%block selection  and finding minimum and maximum pixel
%%%%%%%%%%%%%%%%%%%%%value within%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %block
    h = waitbar(0,'watermark embedding is in progress...');
    for ithBlock=1:length(posEnt)
        waitbar(ithBlock/length(posEnt));
        %finding of pixel location within a block
        blocki = posEnt(ithBlock);
        if(mod(blocki,(256/blocks))==0)
            pixeli = blocki/(256/blocks);
        else
            pixeli = ceil(blocki/(256/blocks));
        end
        
        if(mod(blocki,(256/blocks))==0)
            pixelj = (mod(blocki,(256/blocks))+1)*blocks -blocks +1;
        else
            pixelj = (mod(blocki,(256/blocks)))*blocks-blocks+1;
        end
        pixeli;
        pixelj ;
        temp  = pixelj;



        a = cell(blocks,blocks);
        x = 1;
        y = blocks;
        min  = 255;
        max = 0;
        for i=x:y;
            temp = pixelj;
            for j=x:y
                 a{i-x+1,j-x+1} = coverImageGrayScale(pixeli,temp);
                 if a{i-x+1,j-x+1}<min
                     min = a{i-x+1,j-x+1};
                 end
                 if a{i-x+1,j-x+1}>max
                     max = a{i-x+1,j-x+1};
                 end
                 temp  = temp+  1;
            end
            pixeli = pixeli +1;
        end

        max;
        min;
       % disp('matrix')
        a;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%watermark embedding method%%%%%%%%%%%%%%
    %%%%    %groups and bins %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        coverImageGrayScale;
        a;
        group = min:4:max;
        %disp('total number of group selected:')
        group;
        bBlock = cell2mat(a);
        imhist(bBlock);
        [rows colns] = size(bBlock);
        %groupFormation 
        %bin=[0:4:255]; % determine no. of groups
        bincount=histc(uint8(bBlock),group);
       % disp('group count:');
        b=bincount; %total number of values lies in a group column wise 
        %disp('group count column wise');
        bincountSumColumnWise=sum(b,2); %total number of pixel values in a group
        d=bincountSumColumnWise';
        sum(d);

        %threshold value for group selection within a block 
        thresholdValue = round(0.008*rows*colns);
        bincountPosition = [];
        bincountValue = [];
        % group selected for watermark embedding 
        k=0;
        count =0;
        for i=1:length(bincountSumColumnWise)
            k = k+1;
            if bincountSumColumnWise(i)>thresholdValue
                count = count +1;
                bincountPosition(count) = k;
                bincountValue(count) = bincountSumColumnWise(i);
            end
        end
        bincountPosition;
        bincountValue;

        %bins Formation
        bins = 0:2:255;
       % disp('total number of bin selected:')
        bins;
        bincount=histc(uint8(bBlock),bins);
        %figure,subplot(1,2,1);imhist(uint8(bBlock)); title('Before embedding ');
        b=bincount; %total number of values lies in a group column wise 
        bincountSumColumnWiseBins=sum(b,2); %total number of pixel values in a group
        d=bincountSumColumnWiseBins';
        sum(d);

        %watermark embedding 
        %step 1: pixel location calculation
         size(bincountSumColumnWiseBins);
         size(bincountPosition);
         bBlockOut = bBlock;
         for i= 1:length(bincountPosition)
            b1 =(2*bincountPosition(i))-1; % bin
            b2 = 2*bincountPosition(i); % bin2
            %disp('bin')
            [b1 b2];
            c1=b1*2-2; % pixels location at bin1
            c2=b1*2-1; % pixels location at bin1
            c3=b2*2-2; % pixels location at bin2
            c4=b2*2-1; % pixels location at bin2
            %disp('pixels')
            [c1 c2 c3 c4];
            %step 2: watermark embedding starts by shifting 
            if(watermarkBinary(i)==1)
                ratio = d(b1)/d(b2);
                t=2; %threshold
                    if (ratio<t)
                        nw1=((t*d(b2))-d(b1))/(1+t);
                        nw1=round(nw1);
                        d(b2)=d(b2)-nw1;
                        d(b1)=d(b1)+nw1;
                        count=0;
                        for u=1:blocks
                            for v=1:blocks
                                if((bBlockOut(u,v)==c3)|| (bBlockOut(u,v)==c4) && count<nw1)
                                    r=randi([c1,c2],1);
                                    bBlockOut(u,v)=r;
                                    count = count +1;
                                end
                            end
                        end
                        %disp('count')
                        count;
                    end
            elseif(watermarkBinary(i)==0)
                ratio=d(b2)/d(b1);
                t=2;
                if(ratio<t)
                    nw0 =(t*d(b1)-d(b2))/(1+t);
                    nw0=round(nw0);
                    d(b1)=d(b1)-nw0;
                    d(b2)=d(b2)+nw0;
        % for h=1:nw0
                count=0;
                for u=1:blocks
                    for v=1:blocks
                        if((bBlockOut(u,v)==c1) ||(bBlockOut(u,v)==c2)&& count<nw0)
                            r=randi([c3,c4],1);
                            bBlockOut(u,v)=r;
                            count=count+1;
                        end
                    end
                end

                end

            end
        end

        
        bBlockOut;
        bBlock;

       
      %  bBlockOut = imrotate(bBlockOut,50);
        %disp('size');
        size(bBlock);
        size(bBlockOut);
        
        
        
%%%%%%%%%%%%recombining the blocks%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      blocki = posEnt(ithBlock);
        if(mod(blocki,(256/blocks))==0)
            pixeli = blocki/(256/blocks);
        else
            pixeli = ceil(blocki/(256/blocks));
        end
        
        if(mod(blocki,(256/blocks))==0)
            pixelj = (mod(blocki,(256/blocks))+1)*blocks -blocks +1;
        else
            pixelj = (mod(blocki,(256/blocks)))*blocks-blocks+1;
        end
        temp = pixelj;
        for i=1:blocks
            temp = pixelj;
            for j=1:blocks
                coverImageGrayScale(pixeli,temp) = bBlockOut(i,j);
                temp = temp+1;
            end
            pixeli = pixeli+1;
        end
    end
    close(h);
    size(CoverImageGrayScaleTemp);
    disp('without attack');
    show(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary);
    disp('rotation')
    rotation(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary);
    disp('scaling');
    scaling(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary);
    disp('cropping 5%');
    cropping(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary,5,5,250,250);
    disp('croping 10%')
    cropping(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary,5,5,240,240);
    
    disp('noise salt & pepper');
    noise(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary,'salt & pepper');
    disp('noise guassian');
    noise(coverImageGrayScale,CoverImageGrayScaleTemp,watermarkBinary,'gaussian');
    
   
   
    