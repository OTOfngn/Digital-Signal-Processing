Larger sigma smooths over finer details and suppresses noise, but also removes thin or nearby edges. 
Smoothing before Sobel reduces false edges in the noisy image, while sigma=1 Canny may retain noise-induced edges.
For example, noise can invent isolated edges in the smooth sky/background, while sigma=3 can lose the thin brim edge of the cameraman's hat, making the human figure mixed with the camera.
Edge-pixel counts alone do not measure correctness, because false and missed edges are counted just like correctly detected edges.
