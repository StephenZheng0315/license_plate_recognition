%1.2����ͼ��Ԥ����
clear all
clc
% 1.�ҶȻ�
I=imread('t.jpg'); %����ԭʼͼ��
figure(1)
subplot(2,1,1);
imshow(I);
title('ԭʼͼ��');
I_gray=rgb2gray(I);
subplot(2,1,2);
imshow(I_gray);
title('�Ҷ�ͼ��');

%2.ͼ��ȥ��
I_med=medfilt2(I_gray,[3,3]); %�ԻҶ�ͼ�������ֵ�˲�������ͼ���ϵ����ʸ���
imshow(I_med);
title('��ֵ�˲����ͼ��');

%3.�Ҷȱ任
I_imad=imadjust(I_med);
imshow(I_imad);
title('�Ҷȱ任���ͼ��');

%4.��Ե���
I_edge=edge(I_imad,'Roberts'); %��ΪRoberts
imshow(I_edge);
title('��Ե�����ͼ��');

%5.��̬ѧ����
se=[1;1;1];
I_erode=imerode(I_edge,se); %ͼ��ʴ����
se=strel('rectangle',[25,25]);
I_close=imclose(I_erode,se); %ͼ������㣬���ͼ��
I_final=bwareaopen(I_close,3000); %ȥ�����ŻҶ�ֵС��2000�Ĳ���
imshow(I_final);
title('��̬�˲����ͼ��');

%1.3���ƶ�λ
[y,x,z]=size(I_final);		%��I5���������ص��ܺͷֱ�������y,x��
I6=double(I_final);
Y1=zeros(y,1);			%����һ��y��1�еľ���
for i=1:y
    for j=1:x
		if(I6(i,j,1) ==1)
			Y1(i,1)=Y1(i,1)+1;
		end
	end
end
[temp,MaxY]=max(Y1);	%������������ֵ�ܺ͡��������������ڵ�λ�ô�ŵ�MaxY��
PY1=MaxY;				%�Ƚ����������ܺ�λ�ø�ֵ��PY1
while((Y1(PY1,1) >=50) && (PY1>1))
		PY1=PY1-1;
	end		%whileѭ���õ���������ص���ͨ������ϱ߽�
	PY2=MaxY;	%�Ƚ����������ܺ�λ�ø�ֵ��PY2
	while((Y1(PY2,1) >=50) && (PY2<y))
		PY2=PY2+1;
	end			%whileѭ���õ��ĺ�������ص���ͨ��������±߽�
	%%%%%%%%%%%%%%%��ĳ��Ƶ�����ʼλ�ú���ֹλ��%%%%%%%%%%%
	X1=zeros(1,x);	%����һ��1��x�еľ���
	for j=1:x
		for i=PY1:PY2
			if(I6(i,j,1)==1)
				X1(1,j)=X1(1,j)+1;
			end
		end
	end  %ͨ��ѭ������õ�����ֵ�ܺ���� ��λ��
	PX1=1;	%�Ƚ�PX1��ֵΪ1
	while((X1(1,PX1)<3) && (PX1<x))
		PX1=PX1+1;
	end		%��whileѭ���õ���߽�
	PX2=x;	%��PX2��ֵΪ���ֵx
	while((X1(1,PX2)<3) && (PX2>PX1))
		PX2=PX2-1;
	end  %��whileѭ���õ��ұ߽�
	PX1=PX1-1;
	PX2=PX2+1;
	PY1=PY1+15/915*(PY2-PY1);
	PX1=PX1+15/640*(PX2-PX1);
	PX2=PX2-15/940*(PX2-PX1);

%���ݾ���ֵ�Գ���ͼ���λ�ý���΢��
dw=I(PY1:PY2,PX1:PX2,:);
imshow(dw); %���в������λ��ĳ���

% t=toc; 
figure(7),subplot(1,2,2),imshow(dw),title('��λ���к�Ĳ�ɫ����ͼ��')
imwrite(dw,'dw.jpg');
[filename,filepath]=uigetfile('dw.jpg','����һ����λ�ü���ĳ���ͼ��');
jpg=strcat(filepath,filename);
a=imread('dw.jpg');
b=rgb2gray(a);
imwrite(b,'1.���ƻҶ�ͼ��.jpg');
figure(8);subplot(3,2,1),imshow(b),title('1.���ƻҶ�ͼ��')
g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3); % T Ϊ��ֵ������ֵ
[m,n]=size(b);
d=(double(b)>=T);  % d:��ֵͼ��
imwrite(d,'2.���ƶ�ֵͼ��.jpg');
figure(8);subplot(3,2,2),imshow(d),title('2.���ƶ�ֵͼ��')
figure(8),subplot(3,2,3),imshow(d),title('3.��ֵ�˲�ǰ')

% �˲�
h=fspecial('average',3);
d=im2bw(round(filter2(h,d)));
imwrite(d,'4.��ֵ�˲���.jpg');
figure(8),subplot(3,2,4),imshow(d),title('4.��ֵ�˲���')

% ĳЩͼ����в���
% ���ͻ�ʴ
% se=strel('square',3);  % ʹ��һ��3X3�������ν��Ԫ�ض���Դ�����ͼ���������
% 'line'/'diamond'/'ball'...
se=eye(2); % eye(n) returns the n-by-n identity matrix ��λ����
[m,n]=size(d);
if bwarea(d)/m/n>=0.365
    d=imerode(d,se);
elseif bwarea(d)/m/n<=0.235
    d=imdilate(d,se);
end
imwrite(d,'5.���ͻ�ʴ�����.jpg');
figure(8),subplot(3,2,5),imshow(d),title('5.���ͻ�ʴ�����')

% Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�
d=incise(d);
[m,n]=size(d);
figure,subplot(2,1,1),imshow(d),title(n)
k1=1;k2=1;s=sum(d);j=1;
while j~=n
    while s(j)==0
        j=j+1;
    end
    k1=j;
    while s(j)~=0 && j<=n-1
        j=j+1;
    end
    k2=j-1;
    if k2-k1>=round(n/6.5)
        [val,num]=min(sum(d(:,[k1+5:k2-5])));
        d(:,k1+num+5)=0;  % �ָ�
    end
end
% ���и�
d=incise(d);
% �и�� 7 ���ַ�
y1=10;y2=0.25;flag=0;word1=[];
while flag==0
    [m,n]=size(d);
    left=1;wide=0;
    while sum(d(:,wide+1))~=0
        wide=wide+1;
    end
    if wide<y1   % ��Ϊ��������
        d(:,[1:wide])=0;
        d=incise(d);
    else
        temp=incise(imcrop(d,[1 1 wide m]));
        [m,n]=size(temp);
        all=sum(sum(temp));
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
        if two_thirds/all>y2
            flag=1;word1=temp;   % WORD 1
        end
        d(:,[1:wide])=0;d=incise(d);
    end
end
% �ָ���ڶ����ַ�
[word2,d]=getword(d);
% �ָ���������ַ�
[word3,d]=getword(d);
% �ָ�����ĸ��ַ�
[word4,d]=getword(d);
% �ָ��������ַ�
[word5,d]=getword(d);
% �ָ���������ַ�
[word6,d]=getword(d);
% �ָ�����߸��ַ�
[word7,d]=getword(d);
% �ָ���ڰ˸��ַ�
[word8,d]=getword(d);

% ע�� �������ַ�Ϊ�㣬��˴ӵ��ĸ��ַ���ʼ
% ������ʾΪ1 2 4 5 6 7 8
subplot(5,7,1),imshow(word1),title('1');
subplot(5,7,2),imshow(word2),title('2');
subplot(5,7,3),imshow(word4),title('3');
subplot(5,7,4),imshow(word5),title('4');
subplot(5,7,5),imshow(word6),title('5');
subplot(5,7,6),imshow(word7),title('6');
subplot(5,7,7),imshow(word8),title('7');
[m,n]=size(word1);

% ����ϵͳ�����й�һ����СΪ 40*20,�˴���ʾ
word1=imresize(word1,[40 20]);
word2=imresize(word2,[40 20]);
word3=imresize(word4,[40 20]);
word4=imresize(word5,[40 20]);
word5=imresize(word6,[40 20]);
word6=imresize(word7,[40 20]);
word7=imresize(word8,[40 20]);

subplot(5,7,15),imshow(word1),title('1');
subplot(5,7,16),imshow(word2),title('2');
subplot(5,7,17),imshow(word4),title('3');
subplot(5,7,18),imshow(word5),title('4');
subplot(5,7,19),imshow(word6),title('5');
subplot(5,7,20),imshow(word7),title('6');
subplot(5,7,21),imshow(word8),title('7');

imwrite(word1,'1.jpg');
imwrite(word2,'2.jpg');
imwrite(word4,'3.jpg');
imwrite(word5,'4.jpg');
imwrite(word6,'5.jpg');
imwrite(word7,'6.jpg');
imwrite(word8,'7.jpg');
liccode=char(['���ղش����ʸӹ��ڻ������������³������������������ԥ������' 'A':'Z' '0':'9']);
%liccode=char(['0':'9' 'A':'Z' '��ԥ��³']);  %�����Զ�ʶ���ַ������  
%liccode=char(['0':'9'  'A':'Z' '�ղش����ʸӹ��ڻ������������³��������������������ԥ������']);

SubBw2=zeros(40,20);
l=1;
for I=1:8
      ii=int2str(I);
     t=imread([ii,'.jpg']);
      SegBw2=imresize(t,[40 20],'nearest');
      SegBw2=im2bw(SegBw2);
        if l==1                 %��һλ����ʶ��
            kmin=1;
            kmax=31;
        elseif l==2             %�ڶ�λ A~Z ��ĸʶ��
            kmin=32;
            kmax=57;
        else l >= 3;              %����λ�Ժ�����ĸ������ʶ��
            kmin=58;
            kmax=67;
        
        end
        
        for k2=kmin:kmax
            fname=strcat('�ַ�ģ��\',liccode(k2),'.jpg');
            SamBw2 = imread(fname);
            SamBw2=im2bw(SamBw2);
            for  i=1:40
                for j=1:20
                    SubBw2(i,j)=SegBw2(i,j)-SamBw2(i,j);
                end
            end
           % �����൱������ͼ����õ�������ͼ
            Dmax=0;
            for k1=1:40
                for l1=1:20
                    if  ( SubBw2(k1,l1) > 0 || SubBw2(k1,l1) <0 )
                        Dmax=Dmax+1;
                    end
                end
            end
            Error(k2)=Dmax;
        end
        Error1=Error(kmin:kmax);
        %Error1=Error(1:68);
        MinError=min(Error1);
        findc=find(Error1==MinError);
        Code(l*2-1)=liccode(findc(1)+kmin-1);
        Code(l*2)=' ';
        l=l+1;
end
figure(13),
imshow(dw),
title (['���ƺ���Ϊ:',Code]);
