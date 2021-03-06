function [ maskPoints ] = generateMaskPoints (verbosity, pointLimit)
%GENERATEMASKPOINTS Creates a classifier mask for training an SVM
%   During the initial stage, the system generates a randomized pool of
%   points based on the density mask as supplied by 'density_mask.png'. If
%   the mask_levels are set with increasing value, the brighter pixels on
%   the mask will be more prominent. When using reverse counting (255:-1:1), 
%   the darker pixels will be taken as more highly weighted.
    
    % mask_levels: Number of grayscale masks to consider (pixel val)
    % mask_count: Points per mask level
    mask_level_b    = 1;
    mask_level_t    = 255;
    mask_inc        = -1;       % -1 for decrement
    mask_file       = 'density_mask.png';
    
    % By disabling the mask count and entire count
    %mask_count      = 40;       % Number of points per mask layer
    %mask_entireimg  = 10000;    % Number of points from images (no mask)

    class_file      = 'density_class.png';

    class_one       = -1;       % White Mask
    class_two       = 1;        % Black Mask
    class_cutoff    = 128;      % Gray Midpoint
    
    mask_cullspace  = 0.10;     % Exponential Percent of points to add for culling.
    % Construct the heap of points to be used for training.
    mask_data  = rgb2gray(imread(mask_file));
    class_data = rgb2gray(imread(class_file));
    mask_size  = size(mask_data);
    if (~exist('verbosity','var'))
        verbosity = 0;
    end
    if (mask_inc == 1)
        if (verbosity >= 1)
            fprintf('Masking from %d to %d (increasing)\n',mask_level_b,mask_level_t )
        end
        mask_levels = mask_level_b:mask_inc:mask_level_t;
    else
        if (verbosity >=1)
            fprintf('Masking from %d to %d (decreasing)\n',mask_level_t,mask_level_b )
        end
        mask_levels = mask_level_t:mask_inc:mask_level_b;
    end
    
    
    % If we haven't defined the number of points per layer (mask_count) and
    % the number of points to take from the entire image (mask_entireimg),
    % we will take 20% more points to allow for culling space.
    %
    % POINTLIMIT ^(1.MASK_CULLSPACE) = 
    %       MASK_COUNT * length(mask_levels) + MASK_ENTIREIMG
    
    if (~exist('mask_count','var'))
        mask_count = max(round((pointLimit^(1 + mask_cullspace/2)) / length(mask_levels)),512);
    end
    if (~exist('mask_entireimg','var'))
        mask_entireimg = round(pointLimit^(1 + mask_cullspace) - mask_count * length(mask_levels));
    end
    
    point_heap = zeros(length(mask_levels) * mask_count, 3);

    if (mask_entireimg > 0)
        if (verbosity >= 1)
            fprintf('Grabbing %d points from entire image.\n',mask_entireimg)
        end
        
        prefix_heap = zeros(mask_entireimg,3);
        for i = 1:mask_entireimg
            pos_x = randi(mask_size(2));
            pos_y = randi(mask_size(1));
            if (class_data(pos_y,pos_x) >= class_cutoff)
                pos_c = class_one;
            else
                pos_c = class_two;
            end
            prefix_heap(i,:) = [pos_x,pos_y,pos_c];
            
        end
    else
        prefix_heap = [];
    end
    
    
    if (verbosity >= 1)
        fprintf('Permuting levels:\n')
    end
    i_count = 0;
    for i = mask_levels
        select_rp = randperm(mask_size(1) * mask_size(2));
        % Detect whether we are looking at a dark or light mask.
        if (mask_inc > 0)
            select_rp = select_rp(mask_data(select_rp) > i);
        else
            select_rp = select_rp(mask_data(select_rp) < i);
        end
        
        if (length(select_rp) < mask_count)
            continue;
        end
        for j = 1 : mask_count
            pos_y = mod(select_rp(j),mask_size(1)) + 1;
            pos_x = floor(select_rp(j) / mask_size(1)) + 1;
            if (class_data(pos_y, pos_x) >= class_cutoff)
                pos_c = class_one;
            else
                pos_c = class_two;
            end
            point_heap(i * mask_count + j , :) = [pos_x, pos_y, pos_c];
        end
        i_count = i_count + 1;
        if((mod(i_count,10) == 0) && (verbosity >= 1))
            fprintf('%d%% complete.\n',  round(i_count * 100 / length(mask_levels)))
        end
    end
    if (verbosity >= 1)
        fprintf('Mask value permutation complete\n')
    end
    
    old_phlen = size(point_heap,1);
    point_heap = unique(point_heap,'rows');
    if (verbosity >= 1)
        fprintf('%d unique points generated out of %d points\n',size(point_heap,1),old_phlen)
    end
    
    
    % Removing the first row as it contains the first point of the image
    point_heap(1,:) = [];
    
    point_heap = [prefix_heap;point_heap];
    
    % Since we've defined the number of points we want, we will permute
    % and filter the points down to the requested amount.
    permute_this = randperm(length(point_heap(:,1)));
    permute_this = permute_this(1:pointLimit);
    
    point_heap = point_heap(permute_this,:);
    fprintf('Limiting output to %d points\n',pointLimit)
        
    maskPoints = [point_heap(:,1), point_heap(:,2), point_heap(:,3)];
  
    
        % Accuracy
    imageCmp = imread('Haykin_cover_sketch-mask.bmp');
    
    img_plot = zeros(length(mask_data(1,:,1)), length(mask_data(:,1,1)), 3);
    for i=1:length(maskPoints(:,1,1))
       img_plot(maskPoints(i,1), maskPoints(i,2), maskPoints(i,3)+2) = 1;
    end
    image(img_plot);
end

