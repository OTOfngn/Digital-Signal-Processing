clear; clc; close all;

imageFiles = {'studded_tire.jpeg', 'summer_tire.jpg'};

for i = 1:numel(imageFiles)

    % ---------- 1) Read & resize ----------
    I = imread(imageFiles{i});
    I = imresize(I, 0.5);   % optional scaling
    % imshow(I);
    % ---------- 2) Convert to grayscale ----------
    % Changed: convert RGB images to grayscale.
    if ndims(I) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end

    % ---------- 3) Create tire mask ----------
    % Changed: threshold dark tire pixels and clean the mask.
    tireMask = Igray < 230;
    tireMask = imclose(tireMask, strel('disk', 5));
    tireMask = imfill(tireMask, 'holes');
    tireMask = bwareaopen(tireMask, 500);
    tireArea = nnz(tireMask);

    % ---------- 4) Candidate studs ----------
    % Changed: detect bright points inside the tire and remove noise.
    edges = edge(Igray, 'Canny', 0.3);
    cand = edges & tireMask;
    cand = imclose(cand, strel('disk', 2));
    cand = bwareaopen(cand, 3);

    % ---------- 5) Connected components ----------
    % Existing functionality: measure candidate components.
    CC = bwconncomp(cand);
    stats = regionprops(CC, 'Area', 'Perimeter', 'Eccentricity');

    % ---------- 6) Filter candidates ----------
    studMask = false(size(cand));
    studCount = 0;

    % Choose reasonable limits for your images:
    minA = 4;      % min area of a stud
    maxA = 60;    % max area of a stud
    minCirc = 0.6; % minimum circularity
    maxEcc = 0.85; % maximum eccentricity

    % Changed: filter components by area, circularity, and eccentricity.
    for k = 1:numel(stats)
        area = stats(k).Area;
        perimeter = stats(k).Perimeter;
        circularity = 4 * pi * area / max(perimeter^2, eps);

        if area >= minA && area <= maxA && ...
                circularity >= minCirc && stats(k).Eccentricity <= maxEcc
            studMask(CC.PixelIdxList{k}) = true;
            studCount = studCount + 1;
        end
    end

    % ---------- 7) Decision rule ----------
    % Changed: classify tires using the detected stud count.
    density = studCount / max(tireArea, 1);
    isStudded = studCount > 10 || density > 0.0001;

    % ---------- 8) Visualization ----------
    figure;
    subplot(1,3,1);
    imshow(I); title(sprintf('Input: %s', imageFiles{i}), 'Interpreter','none');

    subplot(1,3,2);
    imshow(cand); title('Candidate studs (binary)');

    subplot(1,3,3);
    imshow(I); hold on;
    visboundaries(studMask, 'LineWidth', 0.7);

    if isStudded
        title(sprintf('STUDDED TIRE (studs: %d)', studCount));
    end
    
end