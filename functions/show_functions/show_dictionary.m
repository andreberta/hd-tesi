function [img,noise_dict] = show_dictionary(D,varargin)
% SHOW_DICTIONARY 

%plot_,no_noisy,random_number

if~(nargin == 1 || nargin == 2 || nargin == 3 || nargin == 4)
    error('Wrong number of parameter');
else
    bound = 2;
    [rows,cols] = size(D);
    psz = sqrt(rows);
    [plot_,no_noisy,random_number] = check_input(psz,varargin);
end

reshaped_D = reshape(D,psz,psz,cols);

noise = zeros(1,cols);
if no_noisy
    for ii=1:cols
    noise(ii) = estimate_noise(reshaped_D(:,:,ii));
    end
    no_noisy = noise < mean(noise);
    noise = noise(no_noisy);
    reshaped_D = reshaped_D(:,:,no_noisy);
    cols = sum(no_noisy);
    cols
end

if logical(random_number)
    if random_number > cols
        random_number = cols;
    end
    r = randperm(cols,random_number);
    reshaped_D = reshaped_D(:,:,r);
    cols = random_number;
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
    
    current_image = reshaped_D(:,:,ii);
    noise_dict(ii) = noise(ii);
    img(m:m+psz-1,n:n+psz-1) = current_image;
end
noise_dict = reshape(noise_dict,M,N);
if plot_
    figure,imagesc(img),colormap(gray);
end

end


%% functions

function [plot_,no_noisy,random_number] = check_input(psz,varargin)
  
    if (psz~=round(psz))
        error('Dictionary atoms should be squared');
    end
    
    var = varargin{1};
    input_args_number = length(var);
    
    if input_args_number == 0
        plot_ = 1;
        no_noisy = 0;
        random_number = 0;
    else if input_args_number == 1
            plot_ = var{1};
            no_noisy = 0;
            random_number = 0;
        else if input_args_number == 2
                plot_ = var{1};
                no_noisy = var{2};
                random_number = 0;
            else if input_args_number == 3
                    plot_ = var{1};
                    no_noisy = var{2};
                    random_number = var{3};
                end
            end
        end
    end

end


