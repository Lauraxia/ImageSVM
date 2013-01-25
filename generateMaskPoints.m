function [ maskPoints ] = generateMaskPoints (verbosity)
%SVMCLASSIFY Sets up a Support Vector Machine to classify the target image.
%   During the initial stage, the system generates a randomized pool of
%   points based on the density mask as supplied by 'density_mask.png'. If
%   the mask_levels are set with increasing value, the brighter pixels on
%   the mask will be more prominent. When using reverse counting (255:-1:1), 
%   the darker pixels will be taken as more highly weighted.
    
    % mask_levels: Number of grayscale masks to consider (pixel val)
    % mask_count: Points per mask level
    mask_level_b  = 1;
    mask_level_t  = 255;
    mask_inc      = 1;  % -1 for decrement
    mask_count    = 40;   
    mask_file     = 'density_mask.png';

    
    % Construct the heap of points to be used for training.
    mask_data = rgb2gray(imread(mask_file));
    mask_size = size(mask_data);
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
    point_heap = zeros(length(mask_levels) * mask_count, 2);

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
        for j = 1:mask_count
            % Using select_rp as a pool of random slots in the 
            point_heap(i*mask_count + j,:) = [mod(select_rp(j), mask_size(1)) ,floor(select_rp(j) / mask_size(1)) ];
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
    
    maskPoints = point_heap;
end

