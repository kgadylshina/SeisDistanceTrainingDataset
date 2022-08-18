function SeisDist2Upload(model, mdist, output)
% model - defines the model we are dealing with if model=1 we use Vanavar, otherwise - BP
% mdist - defines the limiting Hausdorfff distance in percents
% oputput is the name of the output file
if model==1
    Ns=1901;
    fid=fopen('VanavarDist.bin','r');
else
    Ns=2696;
    fid=fopen('BPDist.bin','r');
end

Dmatr=fread(fid,[Ns,Ns],'real*4');
fclose(fid);

figure;
imagesc(Dmatr);
title("distance matrix")





%% construct the set where the distance between the seismogramms is fixed - new version
metout=-1;
clear ii;
ii(1)=1;
itemp=1;
Ncl=1;
while metout<0
    j=itemp
    clear tempInd;
    %mdist=meanAll(1);%nr(1);
    tempInd(1)=j;
    tempMet=-1;
    kk=1;
    if j>=Ns
        tempMet=1;
    end
    while (tempMet<0)
        tempInd(kk+1)=j+kk;
        qq=min(max(Dmatr(tempInd,tempInd)));
        kk=kk+1;
        if qq>mdist
            tempMet=1;
        end
        if kk+j>Ns
            tempMet=1;
        end
    end
    [qq,jj]=min(max(Dmatr(tempInd,tempInd)));
    ii(Ncl)=jj+j-1;
    Ncl=Ncl+1;
    itemp=j+kk;
    if (itemp>=Ns)
        metout=1;
    end
end





for i=1:Ns
    dd(i)=min(Dmatr(i,ii));
end
figure;
plot(dd, 'LineWidth',2);
grid on;
title('Distance to trianing datset');

Ncl2=length(ii)

fid=fopen([output '.bin'],'w');
fwrite(fid,Ncl2,'int32'); % number of sources in the training dataset
fwrite(fid,ii,'int32'); % sources numbers
fclose(fid);



