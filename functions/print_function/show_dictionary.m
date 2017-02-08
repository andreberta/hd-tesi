function [img,noise_dict] = show_dictionary(D)
% funzione per plottare un dizionario

bound = 2;
[rows,cols] = size(D);
psz = sqrt(rows);

if (psz~=round(psz))
    error('gli atomi del dizionario devono essere quadrati');
end


M = ceil(sqrt(cols));
N = ceil(cols/M);
noise_dict = zeros(1,M*N);
img = ones(M*psz+bound*(M-1),N*psz+bound*(N-1))*max((D(:)));

for ii=1:cols
    m = mod(ii,M);
    if (m==0)
        m = M;
    end
    n = (ii-m)/M+1;
    
    m = (m-1)*psz + bound*(m-1) + 1;
    n = (n-1)*psz + bound*(n-1) + 1;
    
    current_image = reshape(D(:,ii),psz,psz);
    noise_dict(ii) = estimate_noise(current_image);
    img(m:m+psz-1,n:n+psz-1) = current_image;
end
noise_dict = reshape(noise_dict,M,N);

imagesc(img);
colormap(gray);



% 
% TO DO
% 
% 
% %% experiments denoising convolutional sparsity: indagare come scegliere numero e dimensione di filtri usando immagini noise free TECHILA
% 
% Pacchetto Curve ROC
% 
% preparare file pdf su admm per bpdn e cbpdn in tutte le varie forme. Mi perdo sempre nei conti e ogni volta li devo rifare: buttiamoli gi� tutti bene una volta per tutte
% 
% codici admm per bpdn in C??? sarebbe figo averceli, magari vanno molto pi� veloci e una libreria cos� farebbe comodo anche in ottica dottorato
% 
% 
% 
% devo organizzare meglio i codici: i dizinari sembrano appresi bene con lambda = 0.1, meglio di quelli con lambda=1. Lo sparse coding � da tunare bene per�. In ogni caso questo paper voglio scriverlo io, con intro, related works experiments e tutto. Secondo me questo week posso buttare gi� bene la struttura. Deve essere mio questo qua, un buon esercizio per vedere a che punto sono.
% 
% 
% 
% 
% - tuning su multiscale per immagini cnr: dobbiamo cercare di migliorare
% - codici per anomaly detection con structural texture similarity distance (parlane con ale prima)
% - prepariamo qualche immagine con anomalia piccolae vediamo li le curve roc come vanno (il framework comunque servir� anche per la convolutional); in questo caso non usiamo oracle, ma l'altro per vedere come andiamo. per il salvataggio basta salvare il pixel, non l'immagine, cos� posso replicare i risultati senza settare il seme e non intasando l'hard disk
% - butta gi� una draft e mettiamo dentro qualche risultato (le curve che hai gi�, il fatto che le patch 7x7 non vanno meglio)
% 	. possiamo seguire la stessa struttura di ssci
% 	. modelli sparsi si sono rivelati efficaci
% 	. anomaly detector che sia scale invariant
% 	. per far questo abbiamo preparato un nuovo dictionary learning e uno specifico sparse coding 
% 	. utilizziamo un dataset di texture e un dataset di immagini industriali (forse)
% - prepariamo dei codici per il nuovo dictionary learning proposto da ale?
% 

% 
% direi che possiamo struttura il paper cos�:
% 
% - anomaly detection patchwise (immagini cnr)
% - serve il multiscale: in questo modo il detector non � soggetto a calo di prestazioni quando le immagini sane cambiano scala. Inoltre pu� essere utile quando le immagini presentano al loro interno diverse scale: ad esempio il diametro delle fibre non � uniforme nell'insieme di training; in questo senso essere in grado di trattare pi� scale pu� essere importante. 
% - 3 experiments
% 	. con patch prese casualmente da delle texture e disegnamo le curve roc (come va la zontak: in questo modo evitiamo di mostrare immagini met� sane e met� anomale). Consideramo diverse scale sia per le texture sane che per quelle anomale
% 	. immagini sintetiche generate con una finestra gaussiana (utilizziamo diverse scale)
% 	. immagini del cnr
% 
% 	Negli experiments direi di considerare questi 3 metodi: multiscale, oracle e ststim
% 
% 	parametri:
% 	
% 	per tutti:
% 		patch_size = 16
% 		scale_test_img = [1 0.875 0.75 0.625 0.5]
% 
% 	multiscale
% 		lambda_dict = 0.1
% 		lambda_cod = 0.1
% 		mu_cod = 0.1
% 		scale_dict = [1 0.75 0.5]
% 
% 	oracle
% 		lambda_dict = 0.1
% 		lambda_cod = 0.1
% 
% 
% 
% 
% 
% 












% 
% 330,67  442,174
% 604,60  621,117





