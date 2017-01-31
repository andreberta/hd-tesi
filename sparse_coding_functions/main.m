% main di esempio


clear
close all

addpath(genpath('sporco'));
addpath('functions');

% patch size
psz = 15;

% numero di patch usate per il training
np_train = 1000;

% lambda usato per lo sparse coding
lambda = 0.1;

% numero di punti della griglia per kde
ngrid = 2^8;

%% Training del dizionario
% carico un'immagine senza difetti per il training
img = im2double(imread('Data/Normal/ITIA11/ITIA1130.tif'));

% calcolo la maschera delle patch nere da escludere
mask_black = preprocess_image(img);

% estraggo patch random dall'immagine
S = random_patches(img,psz,np_train,mask_black);

% tolgo la media da ogni patch
S = bsxfun(@minus,S,mean(S,1));

% apprendo il dizionario
D0 = randn(psz^2,round(psz^2*1.5));
D = bpdndl(D0,S,lambda);


%% Stima della densità degli indicatori di patch normali
% carico un'immagine per la stima della densità
img = im2double(imread('Data/Normal/ITIA11/ITIA1139.tif'));

% estraggo patch random dall'immagine
S = random_patches(img,psz,2*np_train);

% tolgo la media da ogni patch
S = bsxfun(@minus,S,mean(S,1));

% sparse coding
X = bpdn(D,S,lambda);

% calcolo degli indicatori
err = sqrt(sum((D*X-S).^2,1));
l1 = sum(abs(X),1);

indicators = [err',l1'];

% uso metà degli indicatori per la stima della densità
[~,density,xx,yy]  = kde2d(indicators(1:end/2,:),ngrid);

kde_density.density = density;
kde_density.X = xx;
kde_density.Y = yy;

% uso la seconda metà degli indicatori per la stima del threshold
FPR_target = 0.01; % false positive rate desiderato
v = loglikelihood_kde(kde_density,indicators(end/2+1:end,:));
threshold = quantile(v,1-FPR_target);



%% Coding di un'immagine di test

% processo una patch ogni 4. Per processare tutte le patch usare step=1
% (più lento)
step = 4;

% carico l'immagine di test
img = im2double(imread('Data/Anomalous/ITIA11/images/ITIA1110.tif'));
% calcolo la maschera delle patch nere da escludere
mask_black = preprocess_image(img);

data.img = img;
data.psz = psz;
data.step = step;
data.lambda = lambda;
data.D = D;
data.kde_density = kde_density;


% sparse coding e calcolo dei valori della likelihood
stat = sparse_coding(data);

% calcolo la maschera con le detection
mask = compute_mask(stat,threshold,mask_black,psz);

% genero un'immagine segnando rossi i pixel anomali
[img_over] = overlap_mask(img,mask);

imagesc(img_over);












