function deWatermarkingFunction(bBlockOut,w)
    %watermarked image passed through function argument 
    blocks = 16;
    tbs = 5.5;
    ent = blkproc(bBlockOut,[blocks blocks],@entropy);
    valueEnt = []; % array formation for entropy value
    posEnt = [];%array formation for position value
    [x y] = size(ent);
    entCell = cell(x);
    count =0;
    k =0;
    for i=1:x
        for j=1:y
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
    
    %sorting of value within a block
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
     
     
    %histogram shape method
    bin= [0:4:255];
    bincount=histc(uint8(bBlockOut),bin);
    b=bincount;
    c=sum(b,2);
    d=c';
    sum(d);
    [x,y]=size(bBlockOut);
     e= round(0.008*x*y);
    
    [val,loc]=sort(d,'descend');
    bincountPosition = [];
    bincountValue = [];
    thresholdValue = e;
    k=0;
    count =0;
    for i=1:length(c)
        k = k+1;
        if c(i)>thresholdValue
            count = count +1;
            bincountPosition(count) = k;
            bincountValue(count) =c(i);
        end
    end
    %  wsize=input('enter watermarksize')
    %  wa=randi([0,1],[1,wsize]);
    %  
    bin=[0:2:255];
    bincount2=histc(uint8(bBlockOut),bin);
    p=bincount2;
    q=sum(p,2);
    s=q';
    
  %extraction process 
    for k= 1:length(bincountPosition)
        b1=(2*bincountPosition(k))-1;
        b2=2*bincountPosition(k);
        ratio=s(b1)/s(b2);
            if (ratio<1)
                %w(k)=1;
                w1(k) = 1;
            else
                %w(k)=0;
                w1(k)= 0;
            end
           phase2= w1;
    end
    imshow(w);title('Extracted watermark');
    w1;
    %he=isequal(w,w1)
    count=0;
    length(bincountPosition);
    for i = 1:length(bincountPosition)
        if(w(i)~=w1(i))
            count=count+1;

        end
    end
    count;
    disp('biterror');
    biterror = count/length(w1)


end

    
